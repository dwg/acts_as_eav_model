class Post < ActiveRecord::Base
  
  has_eav_behavior
  
  validates_presence_of :intro, :message => "can't be blank", :on => :create
end