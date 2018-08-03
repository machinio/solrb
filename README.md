[![CircleCI](https://circleci.com/gh/machinio/solrb/tree/master.svg?style=svg)](https://circleci.com/gh/machinio/solrb/tree/master)
[![Maintainability](https://api.codeclimate.com/v1/badges/81e84c1c42f10f9da801/maintainability)](https://codeclimate.com/github/machinio/solrb/maintainability)

# Solrb

Object-Oriented approach to Solr in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'solrb'
```

## Configuration

```ruby
Solr.configure do |config|
  # Can be set using `SORL_URL` environment variable or through the configuration block.
  config.url = 'http://localhost:8983'
  # This gem uses faraday to make requests to Solr. You can pass additional faraday
  # options here.
  config.faraday_options = {}

  # The gem will automatically map field names to solr dynamic fields.
  # This is how you declare dynamic fields:
  config.define_dynamic_fields do |t|
    # arguments:
    # - dynamic field name
    # - solr_name option: The same name attribute of the dynamic field defined on solr schema
    t.dynamic_field :text, solr_name: '*_text'
  end

  # Declare the fields and associate them with a dynamic field.
  # Solrb will automatically convert the field name to match the dynamic field. In this example
  # "title" will be converted to "title_text" before querying solr.
  config.map_dynamic_fields do |f|
    # arguments:
    # - field_name
    # - dynamic field name: As defined in define_dynamic_fields block
    f.field :title, :text

    # dynamic_field_name_mapping (true or false, default true): when false, Solrb will use the field name
    # without dynamic field conversion for querying. Here "description" won't be converted to "description_text"
    f.field :description, :text, dynamic_field_name_mapping: false

    # solr_field: When set, Solrb will map the field name directly to solr_field attribute.
    # Here "tags" will be converted to "tags_array" on the query.
    f.field :tags, :text, solr_field: :tags_array
  end
end
```
