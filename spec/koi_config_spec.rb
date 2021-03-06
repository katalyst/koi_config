require 'spec_helper'

describe KoiConfig do
  before do
    @crud = KoiConfig::Config.new
    @crud.config do
      index :title => "Index",  :fields => [:id, :title]
      form  :new => "New Form", :edit => "Edit Form",
                                :fields => [:title, :description]
      config :admin do
        index :title => "Admin Index"
      end
    end
  end

  describe "testing deeply nested namespaces" do
    before do
      @crud = KoiConfig::Config.new(defaults: { admin: { form: { fields: [:title] } } })
    end

    it "must respond with the default hash merged" do
      @crud.settings.must_equal({
        admin: {
          form: {
            fields: [:title]
          },
          ignore: []
        },
        ignore: [],
        map: {},
        fields: {}
      })
    end

    it "must deep merge #config DSL settings" do
      @crud.config do
        config :admin do
          form fields: [:description]
        end
      end

      @crud.settings.must_equal({
        admin: {
          form: {
            fields: [:title, :description]
          },
          ignore: []
        },
        ignore: [],
        map: {},
        fields: {}
      })
    end
  end

  describe "when asked about it type" do
    it "must respond with a hash" do
      @crud.settings.must_be_instance_of Hash
    end
  end

  describe "when asked about it contents" do
    it "must respond with a content hash when no default is set" do
      @crud.settings.must_equal({
        :ignore => [:id, :created_at, :updated_at, :cached_slug, :slug, :ordinal, :aasm_state],
        :admin => { :ignore => [:id, :created_at, :updated_at, :cached_slug, :slug, :ordinal,
                    :aasm_state], :index => { :title => "Admin Index" } },
        :map => {
          :image_uid => :image,
          :file_uid => :file,
          :data_uid => :data
        },
        :fields => {
          :description => { :type => :rich_text },
          :image => { :type => :image },
          :file => { :type => :file }
        },
        :index => { :title => "Index", :fields => [:id, :title] },
        :form =>  { :new => "New Form", :edit => "Edit Form",
                    :fields => [:title, :description] }
      })
    end

    it "must respond with a content hash containing default options when :defaults is set" do
      crud = KoiConfig::Config.new(:defaults => { :ignore => [:id] })
      crud.config do
        index :title => "Index",  :fields => [:id, :title]
        form  :new => "New Form", :edit => "Edit Form",
                                  :fields => [:title, :description]
        config :admin do
          index :title => "Admin Index"
        end
      end
      crud.settings.must_equal({
        :ignore => [:id],
        :index  => { :title => "Index",
                     :fields => [:id, :title]
                   },
        :form   => { :new => "New Form",
                     :edit => "Edit Form",
                     :fields => [:title, :description]
                   },
        :map    => {},
        :fields => {},
        :admin  => { :ignore => [],
                     :index => {
                       :title => "Admin Index"
                     }
                   }
      })
    end
  end

  describe "when merging another simple hash" do
   it "must respond with a merged hash" do
      @crud.settings.deeper_merge!({ :index => { :title => "Changed Title" } })
      @crud.settings[:index].must_equal({ :title => "Changed Title",
                           :fields => [:id, :title] })
    end
  end

  describe "when merging another hash with arrays" do
   it "must respond with a merged hash" do
      @crud.settings.deeper_merge!({ :index => { :title => "Changed Title",
                                   :fields => [:description] } })
      @crud.settings[:index].must_equal({ :title => "Changed Title",
                           :fields => [:id, :title, :description] })
    end
  end

  describe "when merging another hash with arrays and strings" do
   it "must respond with a merged hash" do
      @crud.settings.deeper_merge!({ :index => { :title => "Changed Title",
                                   :fields => [:publish_date, :description,
                                               :created_at, :updated_at] } })
      @crud.settings[:index].must_equal({ :title => "Changed Title",
                           :fields => [:id, :title, :publish_date, :description,
                                       :created_at, :updated_at] })
    end
  end

  describe "when asked about a value which is a proc" do
    before do
      @proc_crud = KoiConfig::Config.new
      @proc_crud.config do
        index :title => Proc.new { title }
      end
    end

    def title
      "Hello I am a Proc"
    end

    it "must respond by returning the stored proc" do
      proc_method = @proc_crud.find(:index, :title)
      result = instance_eval &proc_method
      result.must_equal("#{title}")
    end
  end

  describe "when asked about an known nested hash key" do
    it "must respond with a the key value" do
      @crud.find(:admin, :index, :title).must_equal("Admin Index")
    end
  end

  describe "when asked about an unknow hash key" do
    it "must respond with a nil" do
      @crud.find(:unknow).must_be_nil
    end
  end

  describe "when asked about an known nested hash key" do
    it "must respond with its value" do
      @crud.find(:index, :title).must_equal "Index"
    end
  end

  describe "when asked about an unknow nested hash key" do
    it "must respond with a nil" do
      @crud.find(:something, :unknown).must_be_nil
    end
  end
end
