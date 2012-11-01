class AddProtectedAttributeColumnToNationalParks < ActiveRecord::Migration
  def change
    add_column :national_parks, :protected_attribute_column, :string
  end
end
