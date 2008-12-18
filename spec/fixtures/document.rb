class Document < ActiveRecord::Base
  has_eav_behavior

  def is_eav_attribute?(attr_name, model)
    attr_name =~ /attr$/
  end
end