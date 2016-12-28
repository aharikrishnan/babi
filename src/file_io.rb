require 'rubygems'
require 'json'
require 'pathname'

def get_relative_path
  @path ||= Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))
end

def fread file, preserve=false
  path = File.join(File.dirname(__FILE__), '..', 'out', file)
  gzip = false
  if file.to_s =~ /gz/
    gzip = true
    `gzip -fqd #{path}`
    path  = path.sub(/.gz$/, '')
  end
  json = nil
  if File.exists? path
    File.open(path, 'r') do |f|
      json = f.read
    end
    if gzip && preserve
      `gzip #{path}`
    end
  end
  return json
end

def fread_json file
  json = fread file
  begin
    JSON.parse(json)
  rescue Exception => e
    puts file
    puts e.inspect
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
  end
end

def write_log data, file='out.log'
  path = File.join(File.dirname(__FILE__), '..', 'log', file)
  File.open(path, 'a') do |f|
    f.write("[#{Time.now}] #{data}\n")
  end
end



