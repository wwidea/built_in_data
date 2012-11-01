class NationalPark < ActiveRecord::Base
  include BuiltInData

  attr_accessible :established, :name, :url
end
