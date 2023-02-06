# frozen_string_literal: true

require "built_in_data/version"

module BuiltInData
  extend ActiveSupport::Concern

  included do
    # All built in data objects should have a built_in_key, model objects without a key will not be modified or removed
    validates_uniqueness_of :built_in_key, allow_nil: true, case_sensitive: false

    scope :built_in, -> { where.not(built_in_key: nil) }
  end

  module ClassMethods
    # Inserts new, updates existing, and destorys removed built_in objects
    def load_built_in_data!(hash = nil)
      objects_hash = prepare_objects_hash(hash)
      destroy_removed_built_in_objects!(objects_hash.keys)

      objects_hash.map do |key, attributes|
        create_or_update!(key, attributes)
      end
    end

    # Cached database id for fixture files
    def built_in_object_id(key)
      built_in_object_ids[key]
    end

    def delete_all
      @built_in_object_ids = nil
      super
    end

    private

    def prepare_objects_hash(hash)
      hash.nil? ? load_yaml_data : hash.with_indifferent_access
    end

    def load_yaml_data
      # allow a standard key to be used for defaults in YAML files
      YAML.safe_load(
        read_and_erb_process_yaml_file,
        permitted_classes: [Date],
        aliases:           true
      ).except("DEFAULTS")
    end

    def read_and_erb_process_yaml_file
      ERB.new(Rails.root.join("db", "built_in_data", "#{table_name}.yml").read).result
    end

    # Destroys built_in objects with a built_in_key not present in built_in_keys array
    def destroy_removed_built_in_objects!(built_in_keys)
      built_in.where.not(built_in_key: built_in_keys).destroy_all
    end

    def create_or_update!(key, attributes)
      find_or_initialize_by(built_in_key: key).tap do |object|
        object.attributes = attributes
        object.save!
      end
    end

    # Memoized hash of built in object ids
    def built_in_object_ids
      @built_in_object_ids ||= Hash.new do |hash, key|
        hash[key] = where(built_in_key: key).pick(:id)
      end
    end
  end

  def built_in?
    built_in_key.present?
  end
end
