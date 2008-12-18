require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "ActiveRecord Model annotated with 'has_eav_behavior' with no options in declaration" do
  fixtures :posts, :post_attributes

  it "should have many attributes" do
    post_attr = Post.find_by_title("Hello World").post_attributes
    post_attr[0].should be_instance_of(PostAttribute)
    post_attr.size.should == 3
  end
  
  it "should create new attribute on save" do
    blog_post = Post.find_by_title("Following up from my first post.")
    blog_post.send :write_attribute, 'new_attribute', 'new_value'

    new_attribute = blog_post.post_attributes.to_a.find do |attribute|
      attribute.name == 'new_attribute'
    end
    new_attribute.should_not be_nil

    blog_post.send(:read_attribute, 'new_attribute').should == 'new_value'
    PostAttribute.find_by_name_and_post_id('new_attribute', 2).should be_nil
    blog_post.save!

    PostAttribute.find_by_name_and_post_id('new_attribute', 2).value.should == 'new_value'
    blog_post.send(:read_attribute, 'new_attribute').should == 'new_value'

  end

  it "should delete attribute" do
    blog_post = Post.find_by_title("Hello World")
    blog_post.send(:write_attribute, 'comment', nil)

    comment = blog_post.post_attributes.find_by_name('comment')
    comment.should_not be_nil

    blog_post.send(:read_attribute, 'comment').should be_nil
    blog_post.save!

    blog_post.send(:read_attribute, 'comment').should be_nil

    comment = blog_post.post_attributes.find_by_name('comment')
    blog_post.send(:read_attribute, 'comment').should be_nil
    PostAttribute.find_by_id(1).should be_nil
  end
  
  it "should write eav attributes to attributes table" do
    blog_post = Post.find_by_title("Hello World")
    blog_post.send(:write_attribute, 'intro', 'Blah Blah Blah')
    blog_post.send(:read_attribute, 'intro').should == 'Blah Blah Blah'
    PostAttribute.find(2).value.should_not == 'Blah Blah Blah'
    blog_post.save!
    PostAttribute.find(2).value.should == 'Blah Blah Blah'
  end
  
  it "should return nil when attribute does not exist" do
    blog_post = Post.find_by_title("Hello World")
    blog_post.send(:read_attribute, 'not_exist').should be_nil
  end
  
  it "should use method missing to make attribute seem as native property" do
    blog_post = Post.find_by_title("Hello World")
    blog_post.comment.should == 'Foo Bar Industries gets two thumbs up'
    blog_post.intro.should == 'We deliver quality foobars to consumers nationwide and around the globe'
    blog_post.teaser.should == 'Coming October 7, the foobarantator'
  end
  
  it "should read attributes using subscript notation" do
    blog_post = Post.find_by_title("Hello World")
    blog_post['comment'].should == 'Foo Bar Industries gets two thumbs up'
    blog_post['intro'].should == 'We deliver quality foobars to consumers nationwide and around the globe'
    blog_post['teaser'].should == 'Coming October 7, the foobarantator'
  end
  
  it "should read the attribute when invoking 'read_attribute'" do
    blog_post = Post.find_by_title("Hello World")
    blog_post.send(:read_attribute, 'comment').should == 'Foo Bar Industries gets two thumbs up'
    blog_post.send(:read_attribute, 'intro').should == 'We deliver quality foobars to consumers nationwide and around the globe'
    blog_post.send(:read_attribute, 'teaser').should == 'Coming October 7, the foobarantator'
  end
  
end
