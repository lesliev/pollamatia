require 'data_mapper'
require_relative '../config/config'

DataMapper::Logger.new(MyConfig.db_log, :debug)
DataMapper.setup(:default, MyConfig.db_string)

require_relative './commit'
require_relative './user'
require_relative './review'

DataMapper.finalize
DataMapper.auto_upgrade!
