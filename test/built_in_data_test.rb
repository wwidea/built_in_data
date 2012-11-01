require 'test_helper'

class BuiltInDataTest < ActiveSupport::TestCase
  HASH_DATA = {
    :test => {
      :name => 'Yellowstone National Park',
      :established => '1872-03-01',
      :url => 'http://www.nps.gov/yell/index.htm'
    }
  }

  test "should load built in data" do
    assert_difference 'NationalPark.count' do
      load_hash_data
    end

    assert_equal 'Yellowstone National Park', NationalPark.find_by_built_in_key('test').name
  end

  test "should remove built in data" do
    load_hash_data

    assert_difference 'NationalPark.count', -1 do
      NationalPark.load_built_in_data!({})
    end

    assert_nil NationalPark.find_by_built_in_key('test')
  end

  test "should not remove a record without a built_in_key" do
    park = NationalPark.create(:name => 'Testing')

    assert_difference 'NationalPark.count', 1 do
      load_hash_data
    end
    assert_equal 'Testing', park.reload.name
  end

  test "should update existing built in data" do
    load_hash_data
    assert_not_equal 'http://en.wikipedia.org/wiki/Yellowstone_National_Park', NationalPark.find_by_built_in_key('test').url
    modified_hash = HASH_DATA.dup
    modified_hash[:test][:url] = 'http://en.wikipedia.org/wiki/Yellowstone_National_Park'
    NationalPark.load_built_in_data!(modified_hash)
    assert_equal 'http://en.wikipedia.org/wiki/Yellowstone_National_Park', NationalPark.find_by_built_in_key('test').url
  end

  test "should load built in data from yaml file" do
    assert_difference 'NationalPark.count', 2 do
      NationalPark.load_built_in_data!
    end
  end

  test "should load elements from file only once" do
    NationalPark.load_built_in_data!

    assert_no_difference 'NationalPark.count' do
      NationalPark.load_built_in_data!
    end
  end
  
  test "should process erb in yaml file" do
    assert_equal '1910-05-11', NationalPark.send(:load_yaml_data)['glacier']['established'].to_s(:db)
  end


  #######
  private
  #######

  def load_hash_data
    NationalPark.load_built_in_data!(HASH_DATA)
  end

end
