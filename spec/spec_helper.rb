require 'rubygems'
require 'spec'
gem 'activerecord', '>= 2'
require 'active_record'

require "#{File.dirname(__FILE__)}/../init"

ActiveRecord::Base.establish_connection(:adapter=>'sqlite3', :dbfile=>':memory:')

load(File.dirname(__FILE__) + "/schema.rb")

class Document < ActiveRecord::Base
  has_eav_behavior

  def is_eav_attribute?(attr_name, model)
    attr_name =~ /attr$/
  end
end

class Person < ActiveRecord::Base
  has_eav_behavior :class_name => 'Preference', 
                   :name_field => :key
                   
  has_eav_behavior :class_name => 'PersonContactInfo', 
                   :foreign_key => :contact_id, 
                   :fields => %w(phone aim icq)

  def eav_attributes(model)
    model == Preference ? %w(project_search project_order) : nil
  end
end

class Post < ActiveRecord::Base
  has_eav_behavior
  
  validates_presence_of :intro, :message => "can't be blank", :on => :create
end
