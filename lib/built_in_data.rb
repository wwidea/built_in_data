module BuiltInData
  extend ActiveSupport::Concern

  included do
    # all built in data objects should have a built_in_key, model objects without a key will not be modified or removed
    validates_uniqueness_of :built_in_key, allow_nil: true, case_sensitive: false

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

    # cached database id for fixture files
    def built_in_object_id(key)
      built_in_object_ids[key]
    end

    def delete_all
      @built_in_object_ids = nil
      super
    end

    private

    def prepare_objects_hash(hash)
      return hash.nil? ? load_yaml_data : hash.with_indifferent_access
    end

    def load_yaml_data
      # allow a standard key to be used for defaults in YAML files
      YAML.safe_load(
        read_and_erb_process_yaml_file,
        permitted_classes:  [Date],
        aliases:            true
      ).except('DEFAULTS')
    end

    def read_and_erb_process_yaml_file
      ERB.new(File.read(Rails.root.join('db', 'built_in_data', "#{table_name}.yml"))).result
    end

    def create_or_update!(key, attributes)
      find_or_initialize_by(built_in_key: key).tap do |object|
        object.attributes = attributes
        object.save!
      end
    end

    # memoized hash of built in object ids
    def built_in_object_ids
      @built_in_object_ids ||= Hash.new do |hash, key|
        hash[key] = where(built_in_key: key).pluck(:id).first
      end
    end
  end

  def built_in?
    !built_in_key.blank?
  end
end
