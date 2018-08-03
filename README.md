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

```
Solr.configure do |config|
  config.url = http://yoursolrurl/

  config.define_field_types do |t|
    t.dynamic_field_type :text, solr_definition: '*_text'
  end

  config.define_fields do |f|
    f.field :title, :text
    f.field :description, :text
  end
end
```
