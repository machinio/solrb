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

  # Define the fields that will be used for querying Solr
  config.define_fields do |f|
    f.field :description
    # When dynamic_field is present, the field name will be mapped to match the dynamic field
    # solr_name during query construction. Here, "title" will be mapped to "title_text"
    # You must define the dynamic field to be able to use the dynamic_field option
    f.field :title, dynamic_field: :text

    # When solr_name is present, the field name will be mapped to the solr_name during query construction
    f.field :tags, solr_name: :tags_array

    # define a dynamic field
    f.dynamic_field :text, solr_name: '*_text'
  end
end
```
