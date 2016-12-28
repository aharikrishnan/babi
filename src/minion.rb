require 'rubygems'
require 'faster_csv'
require 'pathname'
require 'uri'
require 'cgi'
require 'curl'

require File.join(File.dirname(__FILE__), 'file_io.rb')
require File.join(File.dirname(__FILE__), 'tree_walker.rb')
#
# @TODO: make code readable
#

MINION_SCHEMA = {
  :headers => {
    'Accept-Encoding' => 'gzip, deflate, sdch' ,
    'Accept-Language' => 'en-US,en;q=0.8' ,
    'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.82 Safari/537.36' ,
    'Accept' => 'application/json, text/plain, */*' ,
    'Referer' => 'http://www.sears.com/appliances-microwaves-over-the-range-microwaves/b-1020309?pageNum=2' ,
    'Connection' => 'keep-alive --compressed'
  },
  :params =>  {
    'catalogId' => '12605',
    'catgroupId' => '1020309',
    'catgroupIdPath' => '1020003_1020021_1020309',
    'levels' => 'Appliances_Microwaves_Over+the+Range+Microwaves',
    'pageNum' => '2',
    'primaryPath' => 'Appliances_Microwaves_Over+the+Range+Microwaves',
    'rmMattressBundle' => 'true',
    'searchBy' => 'subcategory',
    'storeId' => '10153',
    'tabClicked' => 'All',
    'visitorId' => 'Test'
  }
}

def minionize
  minions = fread_json('../data/tree.json')
  trek(minions) do |hook|
    hook.before do |minion, parent|
      category = get_category_from_link minion['h']
      if category
        minion['category'] = category
        minion['categories'] = category
        minion['path'] = minion['n']
      end
      if !parent.nil? && category && category.length
        minion['categories'] = normalize( [parent['categories'], minion['categories']] ).join('_')
        minion['path'] = normalize([parent['path'], minion['path']]).join('_')
      end
    end
  end
  fwrite_json('../data/minions.raw.json', minions.to_json)
end

def find_dup_minions
  minions = fread_json('../data/minions.raw.json')
  terror_minions= {}
  trek(minions) do |hook|
    hook.before do |minion, parent|
      if is_last_minion? minion
        name = minion['n']
        terror_minions[name] = ( terror_minions[name] || [] ) << minion['path']
      end
    end
  end
  terror_minions = Hash[terror_minions.select{|k, v| v.length > 1}]

  fwrite_json('../data/minions.terror.raw.json',terror_minions.to_json)
  terror_minions
end


def steal_moon
  # require minions for evil plan
  minions = fread_json('../data/minions.raw.json')
  trek(minions) do |hook|
    hook.before do |minion, parent|
      if is_last_minion? minion
        # Only the last standing minion is worth of Stealing moon
        recruit minion, 16, 20
      end
    end
  end
end

def prepare_categories_csv
  table_csv_file = File.join(File.dirname(__FILE__), '..', 'data', 'categories.csv')
  FasterCSV.open(table_csv_file, "w", :skip_blanks => true, :col_sep => "\t") do |csv|
    minions = fread_json('../data/minions.raw.json')
    trek(minions) do |hook| hook.before do |minion, parent|
      if minion["category"]
        csv << [minion["n"], minion["category"], minion["path"].split('_').join(" | "), minion["categories"].split('_').join(" | ")]
      end
    end
    end
  end
end

def prepare_bn_csv
  table_csv_file = File.join(File.dirname(__FILE__), '..', 'data', 'bn.0.csv')
  FasterCSV.open(table_csv_file, "w", :skip_blanks => true, :col_sep => "\t") do |csv|
    minions = fread_json('../data/minions.raw.json')
    trek(minions) do |hook| hook.before do |minion, parent|
      if minion["category"]
        csv << [minion["category"]]
      end
    end
    end
  end
end

def compact_moon
  output_path = File.join(File.dirname(__FILE__), '..', 'out')
  glob_pat = File.join(output_path, '*.raw.json')

  puts "To process #{Dir[glob_pat].length}"

  terror_minions = find_dup_minions
  table_csv_file = File.join(File.dirname(__FILE__), '..', 'data', 't100.csv')
  FasterCSV.open(table_csv_file, "w", :skip_blanks => true, :col_sep => "\t") do |csv|
    csv << ['Root Category', 'Leaf Category', 'Brand Name', 'Name', 'SIN', 'Part NUmber', 'Url', 'Categories']
    Dir[glob_pat].each do |file|
      json_data = fread_json(File.basename(file))
      data = json_data['data']
      categories = []
      if data && data['breadCrumb']
        categories = [ data['breadCrumb'].map{|category| category['name']} ]
      else
        write_log " --> ERROR: data not found #{file}"
        next
      end
      first = categories[0][0]
      last = categories[0][-1]
      items = data['products']

      if !items.nil?
        if !terror_minions[last].nil?
          paths = terror_minions[last]
          categories = paths.map{|path| path.split('_')}
        end

        categories.each do |category|
          category_path = category.join(' | ')
          items.each do |item|
            csv << [category[0], category[-1], item['brandName'], item['name'], item['sin'], item['partNumber'], item['url'], category_path].map{|k| k.to_s.gsub("\t", " ").gsub("\n", " ")}
          end
        end
      else
        write_log "NOT processing #{file} ..."
      end
    end

  end
  puts "Done."
end

def evil_plan
  raise "Are you sure ?"
  minionize
  steal_moon
  compact_moon
end

def path_with_params path, params
  "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))
end


def recruit minion, start_page=1, end_page=20
  url = 'http://www.sears.com/service/search/v2/productSearch'

  #(1..pages).each do |page|

    params = MINION_SCHEMA[:params].merge({
      'pageNum' => start_page,
      'catgroupId' => minion['category'],
      'catgroupIdPath' => minion['categories'],
      'levels' => minion['path'],
      'primaryPath' => minion['path']
    })
    uri = URI.parse(path_with_params(url, params))
    http = Curl.get(uri.to_s) do|http|
      MINION_SCHEMA[:headers].each do |k, v|
        http.headers[k] = v
      end
    end

    #sleep 1
    fwrite_json("#{minion['categories']}.#{start_page}.raw.json.gz", http.body_str, :no_override => true)
    tar_file = File.join(get_relative_path, 'out', 'search.tar')
    file_name = "#{minion['categories']}.#{start_page}.raw.json.gz"
    file_path = Pathname.new(File.expand_path(File.join(get_relative_path, 'out', file_name)))
    `cd #{get_relative_path} && tar --append --file=#{tar_file} #{file_path.relative_path_from(get_relative_path)} `
    search_data = fread_json(file_name)
    pagination = (search_data["data"]|| {})["pagination"] || []
    # Array index starts from 0
    next_page = pagination[start_page]

    start_page  = start_page + 1
	if File.exists?(file_path)
	`rm #{file_path}`
	end
	decompressed = file_path.sub(/.gz$/, '')
	if File.exists?(decompressed)
	`rm #{decompressed}`
	end

    if (start_page <= end_page) && (!next_page.nil? && !next_page["value"].nil?)
      recruit minion, start_page, end_page
    end

  #end
end


def catch_em_all average=0
  paths = fread('../data/paths.lst').split("\n")
  path_map = Hash[paths.map{|p| p.split("\t", 2).reverse}]
  tree_map = path_map.clone
  path_map.each do  |path, count|
    count = count.to_i
    sub_paths = path.split("|").map{|p| p.strip}
    (1..(sub_paths.length-1)).each do |path_length|
      current_path = sub_paths[0..(path_length -1)].join(" | ")
      tree_map[current_path] = (tree_map[current_path] || 0) + count
    end
  end
  fwrite_json('../data/minions.count.raw.json',tree_map.to_json)

  average = average.to_i
  if average
    selected_paths = {}
    path_map.each do |path, count|
      count = count.to_i
      sub_paths = path.split("|").map{|p| p.strip}
      (0..[0, sub_paths.length-1 ].max).to_a.reverse.each do |path_length|
        current_path = sub_paths[0..(path_length)].join(" | ")
        product_count = tree_map[current_path].to_i
        if product_count >= average
          selected_paths[current_path] = product_count
          break
        else
          puts "### Fail #{average} > #{current_path} -> #{product_count}"
        end
      end
    end
    fwrite_json('../data/minions.selected.raw.json',selected_paths.to_json)
  end

  table_csv_file = File.join(File.dirname(__FILE__), '..', 'data', 'minions.count.csv')
  FasterCSV.open(table_csv_file, "w", :skip_blanks => true, :col_sep => "\t") do |csv|
    table = []
    tree_map.each do |k, v|
      table << [v, k]
    end
    table = table.sort{|a, b| a[1] <=> b[1]}
    table.each do |row|
      csv << row
    end
  end
  nil
end

def normalize arr
  arr.reject{|n| n.nil? || n.length == 0}
end

def is_last_minion? minion
  is_minion?(minion) && ( minion['c'].nil? || minion['c'] && minion['c'].length == 0 )
end

def is_minion? minion
  !minion['h'].nil? && minion['h'].length > 0 && minion['h'] =~ /^http/
end

def get_category_from_link link
  link =~ /^http/ && link.match(/b-([\d]+)$/)
  $1
end

