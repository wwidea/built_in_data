require 'test_helper'

class BuiltInDataTest < ActiveSupport::TestCase
  
  test "should load built in data" do
    assert_difference 'NationalPark.count' do
      load_test_data
    end
    
    assert_equal 'Yellowstone National Park', NationalPark.find_by_built_in_key('test').name
  end
  
  test "should remove built in data" do
    load_test_data
    NationalPark.built_in_data_attributes = {}
    
    assert_difference 'NationalPark.count', -1 do
      NationalPark.load_built_in_data!
    end
    
    assert_nil NationalPark.find_by_built_in_key('test')
  end
  
  test "should not add or remove records" do
    load_test_data
    
    assert_no_difference "NationalPark.count" do
      NationalPark.load_built_in_data!
    end
  end
  
  test "should not remove a record without a built_in_key" do
    park = NationalPark.create(:name => 'Testing')
    
    assert_difference 'NationalPark.count', 1 do
      load_test_data
    end
    assert_equal 'Testing', park.reload.name
  end
  
  test "should update existing built in data" do
    load_test_data
    NationalPark.built_in_data_attributes[:test][:url] = 'http://en.wikipedia.org/wiki/Yellowstone_National_Park'
    
    NationalPark.load_built_in_data!
    assert_equal 'http://en.wikipedia.org/wiki/Yellowstone_National_Park', NationalPark.find_by_built_in_key('test').url
  end
  
  
  # loading from a yaml file
  test "should load data from yaml file" do
    NationalPark.built_in_data_attributes = nil
    assert_equal 2, NationalPark.built_in_data_attributes.length
  end
  
  test "should load built in data from yaml file" do
    NationalPark.built_in_data_attributes = nil
    
    assert_difference 'NationalPark.count', 2 do
      NationalPark.load_built_in_data!
    end
  end
  
  test "should load elements from file only once" do
    NationalPark.built_in_data_attributes = nil
    NationalPark.load_built_in_data!
    NationalPark.built_in_data_attributes = nil
    
    assert_no_difference 'NationalPark.count' do
      NationalPark.load_built_in_data!
    end
  end
  
  
  #######
  private
  #######
  
  def load_test_data
    NationalPark.built_in_data_attributes = {
      :test => {
        :name => 'Yellowstone National Park',
        :established => '1872-03-01',
        :url => 'http://www.nps.gov/yell/index.htm'
      }
    }
    
    NationalPark.load_built_in_data!
  end
end
