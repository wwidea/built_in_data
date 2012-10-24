module BuiltInData
  # add built_in_key to your model
  # generate migration AddBuiltInKeyToYourModel built_in_key:string
  #
  # require in your model
  # require BuiltInData
  #
  # there are two methods to load data
  # 1) assign built_in_data_attributes
  # YourModel.built_in_data_attributes = {
  #   :glacier => {
  #     :name => 'Glacier National Park',
  #   },
  #   
  #   :yellowstone => {
  #     :name => 'Yellowstone National Park',
  #   }
  # }
  #
  # 2) create a yaml load file in db/built_in_data with the name of the model (ie. national_parks.yml)
  # glacier:
  #   name: Glacier National Park
  # 
  # yellowstone:
  #  name: Yellowstone National Park
  #
  #
  # call load_built_in_data! to load
  # YourModel.load_built_in_data!
  
  extend ActiveSupport::Concern
  
  included do
    # all built in data objects should have a built_in_key, model objects without a key will not be modified or removed
    validates_uniqueness_of :built_in_key, :allow_nil => true
    
    scope :built_in, :conditions => 'built_in_key IS NOT NULL'
  end
  
  module ClassMethods
    def load_built_in_data!
      Array.new.tap do |updated_objects|
        
        built_in_data_attributes.each do |key, attributes|
          updated_objects << create_or_update!(key, attributes)
        end
        
        # destroy any built_in objects that have been removed from built_in_data_attributes
        self.built_in.each do |object|
          object.destroy unless built_in_data_attributes.has_key?(object.built_in_key)
        end
      end
    end
    
    def built_in_data_attributes
      @built_in_data_attributes ||= load_yaml_data
    end
    
    def built_in_data_attributes=(attributes)
      @built_in_data_attributes = (attributes.respond_to?(:with_indifferent_access) ? attributes.with_indifferent_access : attributes)
    end
    
    
    #######
    private
    #######
    
    def create_or_update!(key, attributes)
      attributes.merge!(:built_in_key => key.to_s)
      
      object = find_by_built_in_key(key)
      if object
        object.update_attributes!(attributes)
        object
      else
        result = create!(attributes)
      end
    end
    
    def load_yaml_data
      YAML.load_file(Rails.root.join('db', 'built_in_data', "#{table_name}.yml"))
    end
  end
end
