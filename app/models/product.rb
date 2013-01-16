class Product < ActiveRecord::Base
  establish_connection :external_mysql
  set_table_name 'products'
  set_primary_key 'products_id'
  set_inheritance_column :ruby_type
end