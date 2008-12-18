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