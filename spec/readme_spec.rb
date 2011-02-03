  require 'spec_helper'

  describe "A blog post" do

    with_model :blog_post do

      # The table block works just like a migration.
      table do |t|
        t.string :title
        t.timestamps
      end

      # The model block works just like the class definition.
      model do
        include SomeModule
        has_many :comments
        validates_presence_of :title

        def self.some_class_method
          'chunky'
        end

        def some_instance_method
          'bacon'
        end
      end
    end

    # with_model classes can have associations.
    with_model :comment do
      table do |t|
        t.string :text
        t.belongs_to :blog_post
        t.timestamps
      end

      model do
        belongs_to :blog_post
      end
    end

    it "can be accessed as a constant" do
      BlogPost.should be
    end

    it "can be accessed as a local variable" do
      blog_post.should be
    end

    it "can be accessed as an instance variable" do
      @blog_post.should be
    end

    it "has the module" do
      BlogPost.include?(SomeModule).should be_true
    end

    it "has the class method" do
      BlogPost.some_class_method.should == 'chunky'
    end

    it "has the instance method" do
      BlogPost.new.some_instance_method.should == 'bacon'
    end

    it "can do all the things a regular model can" do
      record = BlogPost.new
      record.should_not be_valid
      record.title = "foo"
      record.should be_valid
      record.save.should be_true
      record.reload.should == record
      record.comments.create!(:text => "Lorem ipsum")
      record.comments.count.should == 1
    end
  end

  describe "another example group" do
    it "should not have the constant anymore" do
      defined?(BlogPost).should be_false
    end
  end