class AddBuiltInKeyToNationalParks < ActiveRecord::Migration
  def change
    add_column :national_parks, :built_in_key, :string
  end
end
