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

  describe "when asked about it type" do
    it "must respond with a hash" do
      @crud.settings.must_be_instance_of Hash
    end
  end

  describe "when asked about it contents" do
   it "must respond with a content hash" do
      @crud.settings.must_equal({
        :ignore => [:id, :created_at, :updated_at, :cached_slug, :ordinal, :aasm_state],
        :admin => { :ignore => [:id, :created_at, :updated_at, :cached_slug, :ordinal,
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
  end

  describe "when merging another simple hash" do
   it "must respond with a merged hash" do
      @crud.settings.deep_merge!({ :index => { :title => "Changed Title" } })
      @crud.settings[:index].must_equal({ :title => "Changed Title",
                           :fields => [:id, :title] })
    end
  end

  describe "when merging another hash with arrays" do
   it "must respond with a merged hash" do
      @crud.settings.deep_merge!({ :index => { :title => "Changed Title",
                                   :fields => [:description] } })
      @crud.settings[:index].must_equal({ :title => "Changed Title",
                           :fields => [:id, :title, :description] })
    end
  end

  describe "when merging another hash with arrays and strings" do
   it "must respond with a merged hash" do
      @crud.settings.deep_merge!({ :index => { :title => "Changed Title",
                                   :fields => [:publish_date, :description,
                                               :created_at, :updated_at] } })
      @crud.settings[:index].must_equal({ :title => "Changed Title",
                           :fields => [:id, :title, :publish_date, :description,
                                       :created_at, :updated_at] })
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
