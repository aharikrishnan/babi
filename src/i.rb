require 'rubygems'
require 'net/http'
require 'cgi'
require 'json'
require 'curb'
require 'fastercsv'

DEFAULT_PARAMS = {
  :storeId => "10153",
  #:catGroupId => "1279778244",
  :catGroupId => "5000288",
  :catalogId => "12605",
  :startIndex => 1,
  :cpcDisableInd => true,
  :disableBundleInd => false,
  :eagerCacheLoad => true,
  :endIndex => "10",
  :includeFiltersInd => true,
  :regPriceInd => true,
  :searchType => "category",
  #:seoURLPath => "clothing-shoes-jewelry-clothing-women-s-clothing/b-1279778244",
  :slimResponseInd => true,
  :sortBy => "ORIGINAL_SORT_ORDER",
  :zipCode => "60602"
}

def headers_for_category category
end

def path_with_params path, params
  "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))
end

def fread_json file
  path = File.join(File.dirname(__FILE__), '..', 'out', file)
  return File.open(path, 'r') do |f|
    json = f.read()
    begin
      JSON.parse(json)
    rescue Exception => e
      {}
    end
  end
end

def fwrite_json file, json, options={}
  path = File.join(File.dirname(__FILE__), '..', 'out', file)
  if (options[:no_override] == true) && File.exists?(path)
    write_log "Skipping: File exists: #{path}"
  end
  File.open(path, 'w') do |f|
    f.write(json)
    write_log "Wrote (#{json.length}) to file #{path}"
  end
end

def write_log data, file='out.log'
  path = File.join(File.dirname(__FILE__), '..', 'log', file)
  File.open(path, 'a') do |f|
    f.write("[#{Time.now}] #{data}\n")
    puts "Wrote (#{data.length}) to file #{path}"
  end
end


def save_tree category
  url = 'http://m.sears.com/mobileapi/v3/products/search'
  params = DEFAULT_PARAMS.merge({:catGroupId => category, :endIndex => "100"})
  uri = URI.parse(path_with_params(url, params))
  headers = {
    'Authorization' => 'SEARSMWEB',
    'Accept-Language' => 'en-US,en;q=0.8',
    'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.82 Safari/537.36',
    'Accept' => '*/*',
    'Referer' => 'http://m.sears.com/appliances-refrigerators/b-1020022?Price=0$-100000&filterList=&sortOption=ORIGINAL_SORT_ORDER&subCatView=true',
    'Cookie' => 'ra_id=xxx1474349399747%7CG%7C0; sn.vi=vi||68513d33-a7de-431b-98c0-68fe4d0cfd2a; fsr.r=%7B%22d%22%3A90%2C%22i%22%3A%22d1159f3-80735113-7064-be48-cd1c7%22%2C%22e%22%3A1474981978864%2C%22s%22%3A1%7D; OAX=tjD+HlfuCJoADb/H; __gads=ID=d499c72f1c4bb40b:T=1475217564:S=ALNI_MZJecMI1PXTHazyNz_MSFzvq9bgAw; IntlCntGrp=; IntnlShip=IN|INR; Yottaacookie=2; KI_FLAG=false; _br_uid_2=uid%3D2779338444285%3Av%3D11.8%3Ats%3D1474349414787%3Ahc%3D109; aam_tnt=seg%3D104605~1914623~1963788~2938851~3061246~3266761~3679467~3341331~3610391~3610421~3397584~3907499~3907697~3610392~3907415~288959~3610422; aamsears=aam%3D2%26aam%3D3%26aam%3D4%26aam%3D289959; aam_chango=crt%3Dsears%2Ccrt%3Delectronicsenthusiast%2Ccrt%3Dautoenthusiast%2Ccrt%3Dfitnessenthusiast%2Ccrt%3Dapplianceenthusiast%2Ccrt%3DLGenthusiast%2Ccrt%3Dmovers%2Ccrt%3Drehabber; aam_criteo=crt%3Dsears; sears_offers=offers%3D1; aam_profile_seg=seg%3D104605; aam_uuid=77201596207484307953385314060965954859; s_vi=[CS]v1|2BF064AC052A33E5-600001070010A4C3[CE]; __CT_Data=gpv=120&apv_99_www04=99; WRUID20151512=0; vfc=2; APP_INIT_URL=http%3A%2F%2Fm.sears.com%2F%3F_ga%3D1.114311815.1025749704.1474349401; trackChange=true; btpdb.iW3qs6M.dGZjLjE0Nzk4MjI=U0VTU0lPTg; btpdb.iW3qs6M.dGZjLjIwMzk0ODU=U0VTU0lPTg; s_e5=xsite_Sears; fsr.s={"v1":-1,"v2":-2,"rid":"d1159f3-80462751-594a-eeae-1e653","sd":1,"lk":1,"c":"http://www.sears.com/en_us/sitemap/tvs-electronics.html","pv":11,"lc":{"d1":{"v":4,"s":true}},"cd":1,"cp":{"usrSessionID":"008a59e6-e035-4cdd-902a-855edddfca9c|MVn8jvU0LLyuSaIZaM2XKoOP3Hp71Kh2x8gsw4rMzrw=|G|136936421999210023_41370_29777|0|1876596202"},"to":4,"f":1475560134573}; mbox=PC#1474349399109-833111.22_10#1538804936|session#1475559460489-123215#1475561999; utag_main=v_id:0157461280b20019eb1f835d6db80506800370600086e$_sn:31$_ss:0$_st:1475561939493$dc_visit:31$_pn:7%3Bexp-session$ses_id:1475559462280%3Bexp-session$dc_event:11%3Bexp-session$dc_region:eu-central-1%3Bexp-session; ot=PROD; bounceClientVisit1400=N4IgbiBcoMYEYEMBOB9AzgFwKYAcoDMEAbNLAGhDRRyQHscAmB9DWpBAcyyhBAqpr0GAZhZtO3SLwC+-AJYATKAEYALBXxgMK1QHZVwgKwAGVQDZhFMIp27D9gJznDqhk+NmKCWlGNe0vlY4EJDKyhRKUkoURHhSABYYGDgApMIAgikMAGJZ2QDuhQB0pMhoRTC0ALZ5WAB2KHJ1GHVEeQoIqTlo8fQ4TRwAtKwArkhyaFVFiVVEfCBIPPMwWrb2hk5mhhQcMIuh2yBVgSAKNlK6wg7KhgAcHg7GLsL3hgy6DPNEq6F69mbGZTCXTSIA; RES_TRACKINGID=440469459039664; ResonanceSegment=1; affiliateCookie=Guest; _ga=GA1.2.1025749704.1474349401; _gat=1; aam_tnt=seg%3D104605~1914623~1963788~2245692~2938851~3061246~3061242~3266761~3679467~3341331~3610391~3610421~3397584~3907499~3907697~3610392~3907415~288959~3610422~4739658; aamsears=aam%3D2%26aam%3D3%26aam%3D4%26aam%3D289959; aam_chango=crt%3Dsears%2Ccrt%3Delectronicsenthusiast%2Ccrt%3Dautoenthusiast%2Ccrt%3Dfitnessenthusiast%2Ccrt%3Dapplianceenthusiast%2Ccrt%3DLGenthusiast%2Ccrt%3Dmovers%2Ccrt%3Drehabber; aam_criteo=crt%3Dsears; sears_offers=offers%3D1; aam_profile_seg=seg%3D104605; aam_uuid=77201596207484307953385314060965954859; s_sess=%20s_e30%3DAnonymous%3B%20s_sq%3Dsearscom%253D%252526c.%252526a.%252526activitymap.%252526page%25253DSitemapVerticalPage%25252520%2525253E%25252520SiteMap%25252520%2525253E%25252520TVs%25252520%25252526%25252520Electronics%252526link%25253DMobile%25252520Site%252526region%25253Dgnf_footer%252526pageIDType%25253D1%252526.activitymap%252526.a%252526.c%3B%20s_ppvl%3DAppliances%252520%25253E%252520Refrigerators%252C100%252C100%252C5543.222349967489%252C582%252C721%252C1366%252C768%252C0.9%252CP%3B%20s_cc%3Dtrue%3B%20s_ppv%3DAppliances%252520%25253E%252520Refrigerators%252C100%252C100%252C956%252C582%252C721%252C1366%252C768%252C0.9%252CP%3B; s_e30=Anonymous; s_pers=%20s_rp%3DSears%7C1478151512355%3B%20s_vnum%3D1632029400126%2526vn%253D30%7C1632029400126%3B%20s_fid%3D5425C49970C440E9-21A61656860D9E74%7C1633330288226%3B%20s_invisit%3Dtrue%7C1475565688231%3B%20gpv_pn%3DFilter%2520Page%7C1475565688247%3B%20s_v47%3D%255B%255B%2527Home%252520Page-N%2527%252C%25271475559533081%2527%255D%252C%255B%2527Appliances%2527%252C%25271475559573556%2527%255D%252C%255B%2527Appliances%252520%25253E%252520Refrigerators%2527%252C%25271475563880559%2527%255D%252C%255B%2527Filter%252520Page%2527%252C%25271475563888264%2527%255D%255D%7C1633330288264%3B; sears_m_pers_uid=c75cc4b2-89f4-11e6-8a5c-0b1ca7f8a1a6; pUserId=c75cc4b2-89f4-11e6-8a5c-0b1ca7f8a1a6; ShopMyStore=Yes' ,
    'Connection' => 'keep-alive',
    'X-Requested-With' =>  'XMLHttpRequest'
  }
  http = Curl.get(uri.to_s) do|http|
    headers.each do |k, v|
      http.headers[k] = v
    end
  end
  sleep 1
  fwrite_json("#{category}.raw.json", http.body_str, :no_override => true)
end

def expand_tree tree, parent=nil, &blk
  return if tree.nil?

  if block_given?
    blk.call(tree, parent)
  end

  childrens = if !tree['c'].nil? && tree['c'].length
                tree['c']
              elsif !tree['l'].nil? && tree['l'].length
                tree['l']
              else
                []
              end
  if childrens.length
    on_forest(childrens, tree, &blk)
  end
end

def on_forest forest, parent=nil, &blk
  forest.each do |tree|
    expand_tree tree, parent, &blk
  end
end

def write_stat
  pruned_forest = fread_json('../data/leaf.json')
  #expand_forest pruned_forest

  count = 0;
  names  = []
  on_forest(pruned_forest) do |node, parent|
    if node['h'] =~ /^http/ && node['h'].match(/b-([\d]+)$/)
      names << node['n']
      count = count + 1
    end
  end
  write_log "Total number of node count:#{count}, unique nodes: #{names.uniq.length}"
  fwrite_json('names.raw.json', names.to_json)
end

def run
  pruned_forest = fread_json('../data/leaf.json')
  on_forest(pruned_forest) do |node, parent|
    if node['h'] =~ /^http/ && node['h'].match(/b-([\d]+)$/)
      if $1
        save_tree $1
      end
    end
  end
end

def gardening
  output_path = File.join(File.dirname(__FILE__), '..', 'out')
  glob_pat = File.join(output_path, '*.raw.json')

  table = []
  Dir[glob_pat].each do |file|
    bdata = fread_json(File.basename(file))
    category_str = ""
    if bdata['metadata'] && bdata['metadata']['catGroupPath']
      category_str = bdata['metadata']['catGroupPath']
    else
      write_log " --> ERROR: metadata not found #{file}"
    end
    category = category_str.split('|')
    first = category[0]
    last = category[-1]

    items = bdata['items']
    if !bdata['items'].nil?
      write_log "processing #{file} ..."
      items.each do |item|
        table << [first, last, item['name'], category_str]
        item['name']
      end
    else
      write_log "NOT processing #{file} ..."
    end
  end
  #  Till to do gardening
  table_csv_file = File.join(File.dirname(__FILE__), '..', 'data', 'table.csv')
  File.open(table_csv_file, 'w') do |f|
    f.write("")
  end
  File.open(table_csv_file, 'a') do |f|
    table.each do |row|
      f.write(row.to_csv)
      #f.write(row.map{|c| c.sub('"', "'")}.to_csv)
    end
  end
  "Done #{table.length}"
end





################################################################################
TreeHooks = Struct.new(:before,:after) do
  def before &blk
    before = blk
  end

  def after &blk
    after = blk
  end
end

def trek forest, parent=nil, &blk
  tree_hooks=TreeHooks.new
  blk.call(tree_hooks)

  puts tree_hooks.before.inspect
  puts tree_hooks.after.inspect

  walk(forest, nil, tree_hooks)
end

def walk forest, parent, tree_hooks
  return if forest.nil?
  forest.each do |tree|
    climb(tree, forest, tree_hooks)
  end
end

def climb tree, parent, tree_hooks
  if !tree_hooks.before.nil?
    tree_hooks.call(forest, parent)
  end

  walk(tree['children'], tree, tree_hooks)

  if !tree_hooks.after.nil?
    tree_hooks.call(forest, parent)
  end
end

def check_count
  forest = fread_json('tree.json')
  count = 0

  trek(forest) do |hook|
    hook.before do |node, parent|
      puts "Before Hook"
      if node['h'] =~ /^http/ && node['h'].match(/b-([\d]+)$/)
        names << node['n']
        count = count + 1
      end
    end

    hook.after do |node, parent|
      puts "After Hook"
    end
  end

  puts count
  #fwrite_json('alien.raw.json', names.to_json)
end

