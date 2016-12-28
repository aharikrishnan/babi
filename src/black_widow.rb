#
# Latrodectus mactans

require 'rubygems'
require 'faster_csv'
require 'set'
require 'uri'
require 'curl'
require File.join(File.dirname(__FILE__), 'file_io.rb')
require File.join(File.dirname(__FILE__), 'tree_walker.rb')

module BlackWidow
  def template
    @template || {}
  end

  def request_template
    if block_given?
      @template = yield
    else
      template
    end
  end

  def http_get url
    resp = Curl.get(url) do |http|
      template[:headers].each do |k, v|
        http.headers[k] = v
      end
    end
    resp
  end

  def http_post url, data
    resp = Curl.post(url, data) do |http|
      template[:headers].each do |k, v|
        http.headers[k] = v
      end
    end
    resp
  end

  def thread
  end

  def cobweb
  end

  def hunt
    thread
    cobweb
  end

end

class BlackWidow::Price
  extend BlackWidow

  request_template do
    {
      :headers => {
        'Origin' => 'http://www.sears.com',
        'Accept-Encoding' => 'gzip, deflate',
        'Accept-Language' => 'en-US,en;q=0.8',
        'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36',
        'Content-Type' => 'application/json;charset=UTF-8',
        'Accept' => 'application/json, text/plain, */*',
        'Referer' => 'http://www.sears.com/appliances-sewing-garment-care-sewing-machines/b-1325469095',
        'Cookie' => 'btpdb.PCNPFl9.c3NvIGlkIChjb29raWVkKQ=MTM2OTM2NDIxOTk5MjEwMDIzXzQxMzcwXzI5Nzc3; sn.vi=vi||68513d33-a7de-431b-98c0-68fe4d0cfd2a; OAX=tjD+HlfuCJoADb/H; __gads=ID=d499c72f1c4bb40b:T=1475217564:S=ALNI_MZJecMI1PXTHazyNz_MSFzvq9bgAw; vfc=2; affiliateCookie=Guest; sears_m_pers_uid=c75cc4b2-89f4-11e6-8a5c-0b1ca7f8a1a6; expo_us_llt=76bc5fd7-6ea5-4642-8f6a-10cff290b20f; ra_id=xxx1481808739103%7CG%7C0; __ibxl=1; __CG=u%3A9113738139700083000%2Cs%3A1651933176%2Ct%3A1481808960291%2Cc%3A1%2Ck%3Awww.sears.com%2F72%2F72%2F1344%2Cf%3A1; IntlCntGrp=; IntnlShip=IN|INR; ot=i2-prod-ch4-vX-; KI_FLAG=false; cust_info=%7B%22customerinfo%22%3A%7B%22userName%22%3A%22%22%2C%22isAkamaiZipSniff%22%3Afalse%2C%22isGuest%22%3Atrue%2C%22isSYWR%22%3Afalse%2C%22sywrNo%22%3A%22%22%2C%22encryptedSywrNo%22%3A%22%22%2C%22sywrPoints%22%3A0%2C%22sywrAmount%22%3A0%2C%22expiringPoints%22%3A0%2C%22expiringPointsDate%22%3Anull%2C%22expiringPointsWarn%22%3Afalse%2C%22spendingYear%22%3A0%2C%22vipLevel%22%3A%22%22%2C%22nextLevel%22%3A0%2C%22maxStatus%22%3A%22SVU%22%2C%22maxSavings%22%3A0%2C%22sessionID%22%3A%22a7f935fd-e9f4-4104-b707-366916cf31b2%22%2C%22globalID%22%3A%22137011015397360174_30870_11686%22%2C%22memberID%22%3A%22137011015397360174_30870_11686%22%2C%22associate%22%3Afalse%2C%22pgtToken%22%3A%22%22%2C%22displayName%22%3A%22%22%2C%22partialLogin%22%3Afalse%2C%22cartCount%22%3A0%7D%7D; irp=e07035f8-fe83-4fc0-a3bf-d26e79ca773e|savSASEXJcBwCK8GZrXiEbnfHvDSvVWt15aD4dWF4b8%3D|G|137011015397360174_30870_11686|0|-2133080357; s_sso=s_r%7CY%7C; _gat_tealium_0=1; bounceClientVisit1400v=N4IgNgDiBcIBYBcEQKQGYCCKBMAxHuA7sQHQDOApgIYBOZJAxgPYC2BFAdgPoCuZBZAJYIKLKqjziIYQVQ4MK9RCzAgANCBowQIAL5A; RES_TRACKINGID=481598494978758; RES_SESSIONID=35910316360575; fsr.s=%7B%22v2%22%3A-2%2C%22v1%22%3A1%2C%22rid%22%3A%22d1159f3-80209794-8557-06de-fcd95%22%2C%22r%22%3A%22www.sears.com%22%2C%22st%22%3A%22%22%2C%22c%22%3A%22http%3A%2F%2Fwww.sears.com%2Fappliances-sewing-garment-care%2Fb-1023587%22%2C%22pv%22%3A4%2C%22lc%22%3A%7B%22d1%22%3A%7B%22v%22%3A4%2C%22s%22%3Atrue%7D%7D%2C%22cd%22%3A1%2C%22cp%22%3A%7B%22usrSessionID%22%3A%22e07035f8-fe83-4fc0-a3bf-d26e79ca773e%7CsavSASEXJcBwCK8GZrXiEbnfHvDSvVWt15aD4dWF4b8%3D%7CG%7C137011015397360174_30870_11686%7C0%7C-2133080357%22%7D%2C%22sd%22%3A1%7D; mbox=PC#5df0b3ab75854f3788af7c71a433b642.22_10#1546171574|session#6c68112c83674f4b95ea6a2564df4299#1482928635; s_pers=%20s_vnum%3D1639488740049%2526vn%253D6%7C1639488740049%3B%20s_fid%3D1883F0E73557AACC-1E5CC5D490C48B59%7C1640693175849%3B%20s_invisit%3Dtrue%7C1482928575858%3B%20s_depth%3D3%7C1482928575863%3B%20gpv_pn%3DAppliances%2520%253E%2520Sewing%2520%2526%2520Garment%2520Care%2520%253E%2520Sewing%2520Machines%7C1482928575868%3B%20gev_lst%3Devent80%7C1482928575872%3B%20gpv_sc%3DAppliances%7C1482928575876%3B%20gpv_pt%3DSubcategory%7C1482928575880%3B; s_sess=%20s_e30%3DAnonymous%3B%20s_sq%3D%3B%20s_cc%3Dtrue%3B; s_vi=[CS]v1|2C294DB2052A399E-60000100C0007554[CE]; aam_tnt=seg%3D104605~1932117~1963788~2938851~3610391~3610421~3397584; aam_chango=crt%3Dsears%2Ccrt%3Delectronicsenthusiast%2Ccrt%3Dapplianceenthusiast; aamsears=aam%3D3; aam_criteo=crt%3Dsears; sears_offers=offers%3D1; aam_profile_seg=seg%3D104605; aam_uuid=01542113841289814183857375180363906126; ak_bmsc=3D2C016CC304E66F9CB490C89C30C9A41703463DAE3E000097AA635865D04246~plODi3Ct5OPbChtxqetqsQ3kbxCUMYrms378jovzPyTy7iMUgvWUtNkhfjiJ7+cyPi17W4c9DUACcMvdRa7lI7T8XI0rQTnujVHoVUibOHhcYeGd0QaVh51ah0VVu/LE7Z3aswJqD9elDRh+P0mHtQzLKBfr3TFaqFuliQXPtc+xApoBiDM9vz6GnlR29lQMRPTy9d6A29SNqCpOPTEFoA+w==; akavpau_Prod=1482927076~id=3a9e4c223ee3e4716f8c7b693836355f; tealium_aam_segments=3907697; _ga=GA1.2.1749610826.1481808740; _br_uid_2=uid%3D9585349496522%3Av%3D11.8%3Ats%3D1481808739983%3Ahc%3D14; utag_main=v_id:015902aefca8001701fc4cb1b92b0506800370600086e$_sn:6$_ss:0$_st:1482928578040$dc_visit:6$ses_id:1482926744675%3Bexp-session$_pn:3%3Bexp-session$dc_event:3%3Bexp-session$dc_region:eu-central-1%3Bexp-session; phfsid=default; __CT_Data=gpv=14&apv_99_www04=14; WRUID20151512=0',
        'Connection' => 'keep-alive'
      },
      #:data => '{"data":[{"pid":"02098031000","ssin":"02098031000P","pidType":"NONVARIATION"},{"pid":"02082092000","ssin":"02082092000P","pidType":"NONVARIATION"},{"pid":"SPM8712935502","ssin":"SPM8712935502","pidType":"NONVARIATION"},{"pid":"SPM7270828802","ssin":"SPM7270828802","pidType":"NONVARIATION"},{"pid":"SPM10177316918","ssin":"SPM10177316918","pidType":"NONVARIATION"},{"pid":"SPM8803312323","ssin":"SPM8803312323","pidType":"NONVARIATION"},{"pid":"SPM12156253504","ssin":"SPM12156253504","pidType":"NONVARIATION"},{"pid":"SPM7700245203","ssin":"SPM7700245203","pidType":"NONVARIATION"}],"storeId":"10153","zipcode":"","storeUnitNumber":"","countryCode":"US","currencyCode":"USD"}'
      :data => ''
    }
  end

  # preprocess
  def self.thread
    table_csv_file = File.join(File.dirname(__FILE__), '..', 'data', 'black-widow.price.csv')

    if File.exists?(table_csv_file)
      puts "Sure to replace the file (yes/no)"
      choice = gets.chomp
      case choice
      when /^y/i
        puts "Overriding the file #{table_csv_file}"
      else
        return
      end
    end

    FasterCSV.open(table_csv_file, "w", :skip_blanks => true, :col_sep => "\t") do |csv|
      csv << ['partNumber',  'sin', 'pbType', 'catEntryId']
      glob_pat = File.join(get_relative_path, 'out.search', '.')
      Dir.foreach(glob_pat) do |item|
        next if !File.file?(File.join(get_relative_path, 'out.search', item))
        json_data = fread_json("../out.search/#{item}")
        data = json_data['data'] || {}
        items = data['products'] || []

        if !items.nil?
          items.each do |item|
            csv << [item['partNumber'],  item['sin'], item['pbType'], item['catEntryId']].map{|k| k.to_s.gsub("\t", " ").gsub("\n", " ")}
          end
        else
          write_log "NOT processing #{file} ..."
        end
      end
    end
  end

  # crawling
  def self.cobweb
    data = {"data" => [
      {"pid" => "02098031000",
       "ssin" => "02098031000P",
       "pidType" => "NONVARIATION"
    }],
    "storeId" => "10153",
    "zipcode" => "",
    "storeUnitNumber" => "",
    "countryCode" => "US",
    "currencyCode" => "USD"
    }

    url = 'http://www.sears.com/service/search/price/json'
    result = http_post url, data.to_json
  end


end

module BlackWidow::Product
  extend BlackWidow
  request_template do
     {
      :headers => {
        'Accept-Encoding' => 'gzip, deflate, sdch' ,
        'Accept-Language' => 'en-US,en;q=0.8' ,
        'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.82 Safari/537.36' ,
        'Accept' => 'application/json, text/plain, */*' ,
        'Referer' => 'http://www.sears.com/appliances-microwaves-over-the-range-microwaves/b-1020309?pageNum=2' ,
        'Connection' => 'keep-alive --compressed',
        'Cookie' =>  'ra_id=xxx1476873860807%7CG%7C0; btpdb.PCNPFl9.c3NvIGlkIChjb29raWVkKQ=MTM2OTYxNjY2NjEyMzUwMDg2XzMwNzcwXzMxMzE4; OAX=ylMSs1gHTocAC9IL; __gads=ID=50f2e9636e69a48f:T=1476873864:S=ALNI_MZx3PwL-xUvs-AzImd-3kBtxCc5gg; sn.vi=vi||8707bf8a-e399-4245-9e7e-3df3bcfbf675; expo_us_llt=05feabd9-d151-477e-ac59-9af4b26f9dec; irp=5213c527-1696-4c1f-9d86-8f95b7edf1ea|5nqOuONm5fqjsvF2eRxPVFBcP7uPcXuhB6EfXkUesBE%3D|G|136961666612350086_30770_31318|0|1876596202; ot=i2-prod-ch3-vX-; Yottaacookie=1; KI_FLAG=false; s_sso=s_r%7CY%7C; ResonanceSegment=1; IntnlShip=US%7CUSD%7C1%7C12425778%7C%7C%7CN; IntlCntGrp=; cust_info=%7B%22customerinfo%22%3A%7B%22userName%22%3A%22%22%2C%22isAkamaiZipSniff%22%3Afalse%2C%22isGuest%22%3Atrue%2C%22isSYWR%22%3Afalse%2C%22sywrNo%22%3A%22%22%2C%22encryptedSywrNo%22%3A%22%22%2C%22sywrPoints%22%3A0%2C%22sywrAmount%22%3A0%2C%22expiringPoints%22%3A0%2C%22expiringPointsDate%22%3Anull%2C%22expiringPointsWarn%22%3Afalse%2C%22spendingYear%22%3A0%2C%22vipLevel%22%3A%22%22%2C%22nextLevel%22%3A0%2C%22maxStatus%22%3A%22SVU%22%2C%22maxSavings%22%3A0%2C%22sessionID%22%3A%225213c527-1696-4c1f-9d86-8f95b7edf1ea%22%2C%22globalID%22%3A%22136961666612350086_30770_31318%22%2C%22memberID%22%3A%22136961666612350086_30770_31318%22%2C%22associate%22%3Afalse%2C%22pgtToken%22%3A%22%22%2C%22displayName%22%3A%22%22%2C%22partialLogin%22%3Afalse%2C%22cartCount%22%3A8%7D%7D; _gat_tealium_0=1; mbox=PC%2309958532f30244b6865ff15d16aa5601.22_6%231540194915%7Csession%2332a6f51da51946079314420c5edb693d%231476951976; RES_TRACKINGID=375805419181096; RES_SESSIONID=614384310934796; BTT_X0siD=4769457815293224518; __CG=u%3A5732322810063839000%2Cs%3A90748869%2Ct%3A1476950116274%2Cc%3A7%2Ck%3Awww.sears.com/82/92/2234%2Cf%3A0%2Ci%3A1; s_pers=%20s_vnum%3D1634553861208%2526vn%253D2%7C1634553861208%3B%20s_fid%3D7D39DA6F4EC2CBA5-31CE4E1CB7813D8E%7C1634716517556%3B%20s_invisit%3Dtrue%7C1476951917562%3B%20s_depth%3D7%7C1476951917565%3B%20gpv_pn%3DProduct%2520Summary%7C1476951917570%3B%20gev_lst%3DprodView%252Cevent10%252Cevent45%253D1%252Cevent77%7C1476951917572%3B%20gpv_sc%3DLawn%2520%2526%2520Garden%7C1476951917577%3B%20gpv_pt%3DProduct%2520Summary%2520%253E%2520CFG01%7C1476951917579%3B; s_sess=%20s_sq%3D%3B%20s_e30%3DAnonymous%3B%20s_e26%3DMP%2520%2526%2520SHC%2520PIDs%2520seen%3B%20s_cc%3Dtrue%3B; s_vi=[CS]v1|2C03A742852A1887-4000010700034566[CE]; aam_tnt=seg%3D104605~1932117~2938850~3610337; aam_chango=crt%3Dsears%2Ccrt%3Dsearsabandoncart%2Ccrt%3Dclothingenthusiast; aamsears=aam%3D3; aam_criteo=crt%3Dsears; sears_offers=offers%3D1; aam_profile_seg=seg%3D104605; aam_uuid=81201937849952017684083103320705558661; phfsid=default; _br_uid_2=uid%3D5724284217291%3Av%3D11.8%3Ats%3D1476873875585%3Ahc%3D12; _ga=GA1.2.1024801762.1476873867; utag_main=v_id:0157dc8ab71800519b0ae2e7d1700506800370600086e$_sn:2$_ss:0$_st:1476951917927$dc_visit:2$_pn:7%3Bexp-session$ses_id:1476945786986%3Bexp-session$dc_event:8%3Bexp-session$dc_region:eu-central-1%3Bexp-session; BTT_WCD_Collect=on; fsr.s=%7B%22v2%22%3A-2%2C%22v1%22%3A1%2C%22rid%22%3A%22d1159f3-80458147-b321-eba0-b9cbd%22%2C%22r%22%3A%22www.sears.com%22%2C%22st%22%3A%22%22%2C%22c%22%3A%22http%3A%2F%2Fwww.sears.com%2Flevi-s-men-s-501-original-straight-leg-jeans%2Fp-SPM12105154016%22%2C%22pv%22%3A5%2C%22lc%22%3A%7B%22d1%22%3A%7B%22v%22%3A5%2C%22s%22%3Atrue%7D%7D%2C%22cd%22%3A1%2C%22cp%22%3A%7B%22usrSessionID%22%3A%225213c527-1696-4c1f-9d86-8f95b7edf1ea%7C5nqOuONm5fqjsvF2eRxPVFBcP7uPcXuhB6EfXkUesBE%3D%7CG%7C136961666612350086_30770_31318%7C0%7C1876596202%22%2C%22shcMPSHC%22%3A%22MP%20%26%20SHC%20PIDs%20seen%22%7D%2C%22sd%22%3A1%7D; bounceClientVisit1400=N4IgbiBcoMYEYEMBOB9AzgFwKYAcoDMEAbNLAGhDRRyQHscAmB9DWpBAcyyhBAqpr0GAZhZtO3SLwC+-AJYATKAA4K+MBigBGACwB2AGzK9OkavCLt+gwE4dAVj3Kbe+zYOuKCWlAAMXtD8KMBwISD0KJSklCiI8KQALDAwcAFJhAEFUhgAxbJyAdyKAOlJkNGKYWgBbfKIsMDkAWjQm6qwAOxam+18tJrY5DjkO4haMdiGkpvqOJoArLAQOtHycJt8dLQA1DI9lXxctBgAFdJykJCwYdIARCYBXbgokHj4QGA0rQztHZwoODBXpAjBRqkEQApLFIDG4bI4tPCGLC9DYtMIGDobO8iF9ILofr0tFplNIgA; __CT_Data=gpv=14&apv_99_www04=12; WRUID20151512=0; ak_bmsc=1F56CCC01C3192D244E3882CED0CF68B170346177B300000726708585E50147B~pl8DZyGrAfsL0zOHmYLKaPGkowREr8b5O6q7WDgORv6GBLMnf9JP+YyFmZtOwifHJhL7DjsfDqziDOeuA6eQLKllr03q/Kby6txMFvs3/RMnmoYPFqPx72dU6yPGkVdSLGc9WxYfUVWkCC4wRF0evlgmuZ2vMl4cIzvDRn7yvnRJALKmnx5oDmiijroEQU944ZuN0ry7MhYdkHDpGXGkTMRA=='
      }
    }
  end

  class << self
    def cobweb
      table_csv_file = File.join(File.dirname(__FILE__), '..', 'data', 'black-widow.csv')

      FasterCSV.open(table_csv_file, "r", :skip_blanks => true, :col_sep => "\t") do |csv|
        index = 0
        csv.each do |category, prod_sku|
          page = 1
          out_path = "../out.pdp/#{prod_sku}.#{page}.raw.json.gz"
          next if File.exists? File.join(File.dirname(__FILE__), out_path)

          uri = URI.parse("http://www.sears.com/content/pdp/config/products/v1/products/#{prod_sku}?site=sears")
          puts uri.to_s
          http = http_get(uri.to_s)
          fwrite_json(out_path, http.body_str)
          index = index + 1
          sleep(rand(10)) if index % 30 == 0
        end
      end
    end

    def thread
      categories = fread('../data/bn2.csv').split.to_set

      table_csv_file = File.join(File.dirname(__FILE__), '..', 'data', 'black-widow.csv')
      FasterCSV.open(table_csv_file, "w", :skip_blanks => true, :col_sep => "\t") do |csv|
        minions = fread_json('../data/minions.raw.json')
        trek(minions) do |hook| hook.before do |minion, parent|
          category = minion["category"].to_s.strip
          if category && categories.include?(category)
            category_data_path = File.join(File.join(File.dirname(__FILE__), '..', 'out'), "#{category}*.raw.json")
            Dir[ category_data_path ].each do |file|
              json_data = fread_json(File.basename(file))
              data = json_data['data']
              next if data.nil?
              items = data['products']

              if !items.nil?
                items.each do |item|
                  csv << [ category, item['sin']]
                end
              else
                write_log "NOT processing #{file} ..."
              end
            end
          end
        end
        end
      end
    end


    def extract
      count=0
      s=Time.now

      output_path = File.join(File.dirname(__FILE__), '..', 'out.pdp')
      glob_pat = File.join(output_path, '.')

      table_csv_file = File.join(File.dirname(__FILE__), '..', 'data', 'products.0.csv')
      FasterCSV.open(table_csv_file, "w", :skip_blanks => true, :col_sep => "\t") do |csv|
        csv << ['id', 'seo title', 'browse node', 'bn id', 'title', 'brand', 'model', 'offer id']
        Dir.foreach(glob_pat) do |item|
          begin
            arr = []
            next if item == '.' || item == '..' || item.match(/gz/)
            offerID=item.split(".")[0]
            #next if all.include? offerID
            j = fread_json("../out.pdp/#{item}")
            data = j["data"] || {}
            raise "not valid JSON #{item}" if (data == {})

            if (data["productstatus"]||{})["isBundle"]
              bundle = data["bundle"] || {}
              bundle_groups = bundle["bundleGroup"] || []
              bundle_groups.each do |bundle_group|
                products = bundle_group["products"]||[]
                products.each do |product|
                  id       = product["id"]
                  seoTitle = product["name"]
                  bn       = data["productmapping"]["primaryWebPath"].sort{|s,s1| s["level"]<=>s1["level"]}.map{|m| m["name"]}.join(" | ")
                  bn_id       = data["productmapping"]["primaryWebPath"].sort{|s,s1| s["level"]<=>s1["level"]}.map{|m| m["id"]}.join(" | ")
                  title    = product["name"]
                  brand    = product["brand"]
                  model    = product["modelNo"]
                  offerId  = product["offerId"]
                  arr << [id, seoTitle, bn, bn_id,  title, brand, model, offerId]
                  write_log "[offer] #{offerId} -> #{id}"
                end
              end
            else
              product  = data["product"] || {}
              id       = product["id"]
              title    = product["name"]
              seoTitle = product["seo"]["title"] rescue title
              bn       = data["productmapping"]["primaryWebPath"].sort{|s,s1| s["level"]<=>s1["level"]}.map{|m| m["name"]}.join(" | ")
              bn_id       = data["productmapping"]["primaryWebPath"].sort{|s,s1| s["level"]<=>s1["level"]}.map{|m| m["id"]}.join(" | ")
              brand    = product["brand"]["name"] rescue nil
              model    = product["mfr"]["modelNo"] rescue nil
              arr << [id, seoTitle, bn, bn_id, title, brand, model]
            end

            arr.each do |row|
              csv << row.map{|cell| cell.to_s.gsub(/[\r\t\n]/, ' ').gsub(/[^A-Za-z0-9\.\-,\&\|'"]/, ' ')}
            end
            write_log "[DONE] #{item}"
          rescue Exception => e
            write_log "[ERROR] #{item}"
            write_log "!!!  Failed #{item} | Reason: #{e.message} | #{e.backtrace.inspect}"
          end
        end
      end
    end

  end
end

