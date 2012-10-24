class NationalPark < ActiveRecord::Base
  include BuiltInData
  
  attr_accessible :established, :name, :url, :built_in_key
end
