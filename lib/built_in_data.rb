module BuiltInData
  extend ActiveSupport::Concern

  included do
    # all built in data objects should have a built_in_key, model objects without a key will not be modified or removed
    validates_uniqueness_of :built_in_key, :allow_nil => true

    scope :built_in, -> { where "#{table_name}.built_in_key IS NOT NULL" }
  end

  module ClassMethods
    def load_built_in_data!(hash = nil)
      objects_hash = prepare_objects_hash(hash)
      Array.new.tap do |updated_objects|

        objects_hash.each do |key, attributes|
          updated_objects << create_or_update!(key, attributes)
        end

        # destroy any built_in objects that have been removed from built_in_data_attributes
        self.built_in.each do |object|
          object.destroy unless objects_hash.has_key?(object.built_in_key)
        end
      end
    end

    #######
    private
    #######

    def prepare_objects_hash(hash)
      return hash.nil? ? load_yaml_data : hash.with_indifferent_access
    end

    def load_yaml_data
      YAML.load(ERB.new(File.read(Rails.root.join('db', 'built_in_data', "#{table_name}.yml"))).result)
    end

    def create_or_update!(key, attributes)
      attributes.merge!(:built_in_key => key.to_s)

      object = find_or_initialize_by_built_in_key(key)
      object.send(:built_in_data_attributes=,attributes)
      return object
    end

  end

  ####################
  # INSTANCE METHODS #
  ####################

  #######
  private
  #######

  # Assign attributes bypassing mass assignment protections
  def built_in_data_attributes=(attributes)
    attributes.each do |attribute_name,value|
      send("#{attribute_name}=",value)
    end
    save!
  end
end
