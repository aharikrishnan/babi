arr=[]
failed=[]
count=0
s=Time.now

output_path = File.join(File.dirname(__FILE__), '..', 'out.pdp')
glob_pat = File.join(output_path, '.')

Dir.foreach(glob_pat) do |item|
  begin
    next if item == '.' or item == '..'
    next if item.match(/gz/)
    offerID=item.split(".")[0]
    #next if all.include? offerID
    count+=1
    if count%1000==0
      #File.open('dump.json', 'w') do |f|
      #f.puts arr.to_json
      puts item+ " Iter: " +count.to_s
      puts (Time.now-s)
      s=Time.now
      #end
    end
    f=File.read(item)
    j=JSON.parse f

    seoTitle=j["data"]["product"]["seo"]["title"]
    bn=j["data"]["productmapping"]["primaryWebPath"].sort{|s,s1| s["level"]<=>s1["level"]}.map{|m| m["name"]}.join(" | ")
    title=j["data"]["product"]["name"]
    brand=j["data"]["product"]["brand"]["name"]
    model = (j["data"]["product"]["mfr"]["modelNo"] rescue "")
    arr<<[offerID, seoTitle, bn, title, brand, model]
  rescue
    failed << item
  end
end
