require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => :sqllite, :database => :sears)
ActiveRecord::Base.logger = Logger.new(STDOUT)


