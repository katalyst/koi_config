require 'koi_config'

crud = KoiConfig::Config.new

crud.config do
  ignore [:description]
  index :title => "Index", :fields => [:id, :title]
  fields :image => { :type => :file }
  config :admin do
    index :title => "Admin Index", :fields => [:id]
    ignore [:published_at]
  end
end

puts "Default Config"
p crud.settings

crud.settings.deep_merge!({ :index => { :title => "Changed Title" } })
puts "Simple Merged Config"
p crud.settings[:index]

crud.settings.deep_merge!({ :index => { :fields => [:description] } })
puts "Complicated merged Config"
p crud.settings[:index]

crud.settings.deep_merge!({ :index => { :title => "Changed Title",
                                        :fields => [:publish_date, :description,
                                                    :created_at, :updated_at] } })
puts "Another complicated merged Config"
p crud.settings[:index]
