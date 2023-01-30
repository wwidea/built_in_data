# BuiltInData

[![Maintainability](https://api.codeclimate.com/v1/badges/02eb42a4a53414adae01/maintainability)](https://codeclimate.com/github/wwidea/built_in_data/maintainability)

BuiltInData is a simple tool for loading and updating data in a Rails application.

Objects are stored in the database with a **built_in_key** that is used on subsequent loads to update or remove the object. Items in the table without a **built_in_key** will not be modified or removed.

BuiltInData is designed to address the data gray area between customer data and constants. It allows developers to deliver, update, and destroy data that is stored in the database.

## Setup
Add **built_in_key** to your model:
```bash
ruby script/rails generate migration AddBuiltInKeyToYourModel built_in_key:string:index
rake db:migrate
```

Include **BuiltInData** in your model:
```ruby
class YourModel < ActiveRecord::Base
  include BuiltInData
end
```

## Loading Data
There are two methods to load data

- Pass as a hash to load_built_in_data!
```ruby
YourModel.load_built_in_data!({
  glacier: {
    name: 'Glacier National Park'
  },
  yellowstone: {
    name: 'Yellowstone National Park'
  }
})
```

- Create a yaml load file in **db/built_in_data** with the name of the model (ie. national_parks.yml), and load the data with `YourModel.load_built_in_data!` without any arguments.  The yaml file can contain erb.
```yaml
glacier:
  name: Glacier National Park
  established: <%= Date.parse('1910-05-11') %>

yellowstone:
  name: Yellowstone National Park
  established: 1872-03-01
```

## Other
Use **built_in?** to check if an object was loaded by BuiltInData:
```ruby
object.built_in?
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
