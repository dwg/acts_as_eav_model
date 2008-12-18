require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "ActiveRecord Model annotated with 'has_eav_behavior' with options in declaration" do
  fixtures :people, :preferences, :person_contact_infos

  it "should be 'has_many' association on both sides" do
    marcus = Person.find_by_name('Marcus Wyatt')

    prefs = marcus.preferences
    prefs[0].should be_instance_of(Preference)
    prefs.size.should == 2

    contact_info = marcus.person_contact_infos
    contact_info[0].should be_instance_of(PersonContactInfo)
    contact_info.size.should == 2
  end

  it "should only allow restricted fields when specified (:fields => %w(phone aim icq))" do
    marcus = Person.find_by_name('Marcus Wyatt')
    marcus.aim.should == 'marcus.wyatt'
    lambda { marcus.doesnt_exist }.should raise_error(NoMethodError)
  end

  it "should raise 'NoMethodError' when attribute not in 'eav_attributes' method array" do
    marcus = Person.find_by_name('Marcus Wyatt')

    marcus.project_order.should == 'name'
    lambda { marcus.project_blah }.should raise_error(NoMethodError)
  end

  it "should raise 'NoMethodError' when attribute does not satisfy 'is_eav_attribute?' method" do
    doc = Document.new

    doc.copyright_attr.should be_nil
    lambda { doc.no_exist }.should raise_error(NoMethodError)

  end
end
