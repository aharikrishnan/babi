require 'rubygems'
require 'json'

def fread file
  path = File.join(File.dirname(__FILE__), '..', 'out', file)
  return File.open(path, 'r') do |f|
      json = f.read
  end
end

def fread_json file
  json = fread file
  begin
    JSON.parse(json)
  rescue Exception => e
    {}
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



