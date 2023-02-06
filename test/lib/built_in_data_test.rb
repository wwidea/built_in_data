require 'test_helper'

class BuiltInDataTest < ActiveSupport::TestCase
  HASH_DATA = {
    test: {
      name:         'Yellowstone National Park',
      established:  '1872-03-01',
      url:          'http://www.nps.gov/yell/index.htm',
    }
  }

  test 'should return true for built_in?' do
    assert_equal true, NationalPark.new(built_in_key: 'test').built_in?
  end

  test 'should return false for built_in?' do
    assert_equal false, NationalPark.new(built_in_key: '').built_in?
  end

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
    assert_equal '1910-05-11', NationalPark.send(:load_yaml_data)['glacier']['established'].to_fs(:db)
  end

  test 'should return active record objects from load' do
    parks = NationalPark.load_built_in_data!
    assert_equal(2,parks.size)
    assert_equal(NationalPark,parks.first.class)
    assert_equal(false,parks.first.new_record?)
  end

  test 'should load yaml defaults' do
    NationalPark.load_built_in_data!
    assert_equal true, NationalPark.find_by(name: 'Yellowstone National Park').active
  end

  test 'should return built_in_data object database id' do
    load_hash_data
    assert_equal NationalPark.where(name: 'Yellowstone National Park').first.id, NationalPark.built_in_object_id(:test)
  end

  test 'should clear built_in_object_ids cache when delete_all is called' do
    NationalPark.instance_variable_set('@built_in_object_ids', 'testing')

    NationalPark.delete_all
    assert_nil NationalPark.instance_variable_get('@built_in_object_ids')
  end

  private

  def load_hash_data
    NationalPark.load_built_in_data!(HASH_DATA)
  end

end
