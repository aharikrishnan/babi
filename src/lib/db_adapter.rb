require 'rubygems'
require 'active_record'
require 'logger'
require 'yaml'

module DB
  class << self

    def establish_connection db_config_path=default_db_config_path
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      @config = YAML::load_file(db_config_path)
      ActiveRecord::Base.establish_connection(@config['development'])
    end

    def default_db_config_path
      @@db_config_path
    end
    @@db_config_path =  File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'db', 'database.yml'))

  end
end

