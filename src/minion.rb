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
    #'Cookie' => 'ra_id=xxx1474349399747%7CG%7C0; btpdb.PCNPFl9.c3NvIGlkIChjb29raWVkKQ=MTM2OTM2NDIxOTk5MjEwMDIzXzQxMzcwXzI5Nzc3; sn.vi=vi||68513d33-a7de-431b-98c0-68fe4d0cfd2a; fsr.r=%7B%22d%22%3A90%2C%22i%22%3A%22d1159f3-80735113-7064-be48-cd1c7%22%2C%22e%22%3A1474981978864%2C%22s%22%3A1%7D; OAX=tjD+HlfuCJoADb/H; __gads=ID=d499c72f1c4bb40b:T=1475217564:S=ALNI_MZJecMI1PXTHazyNz_MSFzvq9bgAw; vfc=2; affiliateCookie=Guest; sears_m_pers_uid=c75cc4b2-89f4-11e6-8a5c-0b1ca7f8a1a6; pUserId=c75cc4b2-89f4-11e6-8a5c-0b1ca7f8a1a6; utag_main=v_id:0157461280b20019eb1f835d6db80506800370600086e$_sn:34$_ss:1$_st:1475661599826$dc_visit:34$_pn:1%3Bexp-session$ses_id:1475659797778%3Bexp-session$dc_event:1%3Bexp-session$dc_region:eu-central-1%3Bexp-session; _ga=GA1.2.1025749704.1474349401; RES_TRACKINGID=440469459039664; ResonanceSegment=1; IntlCntGrp=; IntnlShip=IN|INR; ot=i1-prod-ch3-vX-; Yottaacookie=2; ak_bmsc=D21DF15C86FB9DBDF0CAEDFD6EDFA4477C7C8010AA5E0000E1F7F5578C78A06A~plagag4zxRAxNS/xku1+n5LZGsDzqNtHZ3ujMwMQIO6AN8o7zfFwg8uVVVmdk+nz+ZHv15G/QloQYxdSRdoMCRdvj0e8rCIWdjIArH7Dn3po413Uxb1olvSMR9a+IDAXnGd2UfjaE16Rq8pkYTKJhKbss5l2TwWTbaVAh4ZF/BkZL/OatK6W6epG2u2BbZVSw78Bf/6ETAB63n+1+6zlHAUq7FwcpgHbV2MKfQu+YGXNA=; bounceClientVisit1400v=N4IgNgDiBcIBYBcEQKQGYCCKBMAxHuA7sQHQDOApgIYBOZJAxgPYC2BFAdgPoCWHCHMAQAmVVHjJwmECHwDmAWgRMArjR5kWJRCzAgANCBowQIAL5A; fsr.s=%7B%22v1%22%3A-1%2C%22v2%22%3A-1%2C%22rid%22%3A%22d1159f3-80571927-f257-a559-1cabd%22%2C%22sd%22%3A1%2C%22lk%22%3A1%2C%22c%22%3A%22http%3A%2F%2Fwww.sears.com%2Fen_intnl%2Fdap%2Fshopping-tourism.html%22%2C%22pv%22%3A1%2C%22lc%22%3A%7B%22d1%22%3A%7B%22v%22%3A1%2C%22s%22%3Afalse%7D%7D%2C%22cd%22%3A1%2C%22cp%22%3A%7B%22usrSessionID%22%3A%2245a34f8a-ac0e-4b4c-b6d3-96d2a337c067%7CjVXfzSEWnAn9WggTC%2Bw3DSUVQxYHB6l908NRVv76e1Q%3D%7CG%7C136936421999210023_41370_29777%7C0%7C1876596202%22%7D%7D; KI_FLAG=false; irp=eb55e285-5ee3-4f0b-be2a-01f33b408f47|gXpBd30VCNWGqHGBSPXk7vzMa4FIHRQOeFf4%2BN9IbOY%3D|G|136936421999210023_41370_29777|0|1876596202; s_sso=s_r|N|; mbox=PC#1474349399109-833111.22_10#1478329573|check#true#1475737633|session#1475737570390-993508#1475739433; bounceClientVisit1400=N4IgbiBcoMYEYEMBOB9AzgFwKYAcoDMEAbNLAGhDRRyQHscAmB9DWpBAcyyhBAqpr0GAZhZtO3SLwC+-AJYATKAwr4wGKAEYALAHZtwgKwAGbQDZhFMIq17Du4bvvbNADleaAnJooJaUY180AKscCEgfECUpJQoiPCkACwwMHABSYQBBNIYAMRzcgHdigDpSZDQSmFoAWwKsADsUOQaMBqIChQR0vLRE+hwWjgBaVgBXJDk0GpLkmqI+ECQeRZh1WycHTe0KDhhliMMKGpComykHb0NXYzNPY0MDG8MGXQZFonWIuy3naSA; s_vi=[CS]v1|2BF064AC052A33E5-600001070010A4C3[CE]; _br_uid_2=uid%3D2779338444285%3Av%3D11.8%3Ats%3D1474349414787%3Ahc%3D123; __CT_Data=gpv=133&apv_99_www04=110; WRUID20151512=0; s_pers=%20s_rp%3DSears%7C1478151512355%3B%20s_v47%3D%255B%255B%2527Appliances%252520%25253E%252520Refrigerators%2527%252C%25271475660108118%2527%255D%255D%7C1633426508118%3B%20s_vnum%3D1632029400126%2526vn%253D34%7C1632029400126%3B%20s_depth%3D1%7C1475739374258%3B%20s_fid%3D5425C49970C440E9-21A61656860D9E74%7C1633503997040%3B%20s_invisit%3Dtrue%7C1475739397043%3B%20gpv_pn%3DAppliances%2520%253E%2520Microwaves%2520%253E%2520Over%2520the%2520Range%2520Microwaves%7C1475739397048%3B%20gev_lst%3Devent80%7C1475739397052%3B%20gpv_sc%3DAppliances%7C1475739397056%3B%20gpv_pt%3DSubcategory%7C1475739397060%3B; s_sess=%20s_cc%3Dtrue%3B%20s_sq%3D%3B; aam_tnt=seg%3D104605~1914623~1963788~2245692~2938850~2938846~2938851~3061246~3061291~3061242~3266761~3679467~3341331~3610391~3610421~3397584~3907499~3907697~3610337~3610392~3907415~288959~3610422~4739658; aamsears=aam%3D2%26aam%3D3%26aam%3D4%26aam%3D289959; aam_chango=crt%3Dsears%2Ccrt%3Delectronicsenthusiast%2Ccrt%3Dautoenthusiast%2Ccrt%3Dfitnessenthusiast%2Ccrt%3Dapplianceenthusiast%2Ccrt%3Dclothingenthusiast%2Ccrt%3DLGenthusiast%2Ccrt%3Dmovers%2Ccrt%3Drehabber; aam_criteo=crt%3Dsears; sears_offers=offers%3D1; aam_profile_seg=seg%3D104605; aam_uuid=77201596207484307953385314060965954859' ,
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

def evil_plan
  # require minions for evil plan
  minions = fread_json('../data/minions.raw.json')
  trek(minions) do |hook|
    hook.before do |minion, parent|
      if is_last_minion? minion
        # Only the last standing minion is worth of Stealing moon
        recruit minion
      end
    end
  end
end

def steal_moon
  minionize
  evil_plan
end

def recruit minion, count=100, per_page=50
  url = 'http://www.sears.com/service/search/v2/productSearch'

  (1..(count.to_f/per_page).ceil).each do |page|
    params = MINION_SCHEMA[:params].merge({
      'pageNum' => page,
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
    fwrite_json("#{minion['category']}.#{page}.raw.json.gz", http.body_str, :no_override => true)
  end
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


