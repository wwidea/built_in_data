class RemoveProtectedAttributeColumnFromNationalParks < ActiveRecord::Migration
  def change
    remove_column :national_parks, :protected_attribute_column, :string
  end
end
