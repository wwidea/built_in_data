class NationalPark < ActiveRecord::Base
  require BuiltInData
  
  attr_accessible :established, :name, :url
end
