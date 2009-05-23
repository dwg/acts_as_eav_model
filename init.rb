$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'active_record/acts/eav_model'
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::EavModel }