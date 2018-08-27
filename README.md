[![CircleCI](https://circleci.com/gh/machinio/solrb/tree/master.svg?style=svg)](https://circleci.com/gh/machinio/solrb/tree/master)
[![Maintainability](https://api.codeclimate.com/v1/badges/81e84c1c42f10f9da801/maintainability)](https://codeclimate.com/github/machinio/solrb/maintainability)

# Solrb [WIP]

Object-Oriented approach to Solr in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'solrb'
```

## Configuration

The simplest way to use Solrb is `SORL_URL` environment variable with core's name:

```bash
  ENV['SOLR_URL'] = 'http://localhost:8983/test-core'
```

Specify `Solr.configure` for an extended configuration:

```ruby
# Single-core configuration
Solr.configure do |config|
  config.url = 'http://localhost:8983/core-name'

  # This gem uses faraday to make requests to Solr. You can pass additional faraday
  # options here.
  config.faraday_options = {}

  # Core's URL is be 'http://localhost:8983/core-name'
  config.define_core do |f|
    f.field :description
  end
end
```

```ruby
# Multi-core configuration
Solr.configure do |config|
  config.url = 'http://localhost:8983'

  # Define the core with fields that will be used for querying Solr.
  # Core's URL is 'http://localhost:8983/listings'
  config.define_core(name: :listings) do |f|
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

  # Pass `default: true` to use some core as a default one.
  # Core's URL is 'http://localhost:8983/cars'
  config.define_core(name: :cars, default: true) do |f|
    f.field :manufacturer
    f.field :model
  end
end
```

Warning: Solrb doesn't support fields with same name. If you have two fields with the same name mapping
to a distinct solr field you'll have to rename one of the fields.

```ruby
...
config.define_core do |f|
  ...
  # Not allowed: Two fields with same name 'title'
  f.field :title, solr_name: :article_title
  f.field :title, solr_name: :page_title
end
...
```

## Usage

### Indexing

```ruby
# creates a single document and commits it to index
doc = Solr::Indexing::Document.new
doc.add_field(:id, 1)
doc.add_field(:name, 'Solrb!!!')

request = Solr::Indexing::Request.new(documents: [doc])
request.run(commit: true)
```

You can also create indexing document directly from attributes:

```ruby
doc = Solr::Indexing::Document.new(id: 5, name: 'John')
```

### Querying

#### Simple Query

```ruby
  field = Solr::Query::Request::FieldWithBoost.new(field: :name_txt_en)

  request = Solr::Query::Request.new(search_term: 'term', fields: [field])
  request.run(page: 1, page_size: 10)
```

#### Query with field boost

```ruby
  fields = [
    # Use boost_magnitude argument to apply boost to a specific field
    Solr::Query::Request::FieldWithBoost.new(field: :name_txt_en, boost_magnitude: 16),
    Solr::Query::Request::FieldWithBoost.new(field: :title_txt_en)
  ]
  request = Solr::Query::Request.new(search_term: 'term', fields: fields)
  request.run(page: 1, page_size: 10)
```

#### Query with filters

```ruby
  fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name_txt_en),
    Solr::Query::Request::FieldWithBoost.new(field: :title_txt_en)
  ]
  filters = [Solr::Query::Request::Filter.new(type: :equal, field: :title_txt_en, value: 'title')]
  request = Solr::Query::Request.new(search_term: 'term', fields: fields, filters: filters)
  request.run(page: 1, page_size: 10)
```


#### Query with sorting

```ruby
  fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name_txt_en),
    Solr::Query::Request::FieldWithBoost.new(field: :title_txt_en)
  ]
  sort_fields = [Solr::Query::Request::Sorting::Field.new(name: :name_txt_en, direction: :asc)]
  request = Solr::Query::Request.new(search_term: 'term', fields: fields)
  request.sorting = Solr::Query::Request::Sorting.new(fields: sort_fields)
  request.run(page: 1, page_size: 10)
```

#### Query with grouping

```ruby
  fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name_txt_en),
    Solr::Query::Request::FieldWithBoost.new(field: :category_txt_en)
  ]
  request = Solr::Query::Request.new(search_term: 'term', fields: fields)
  request.grouping = Solr::Query::Request::Grouping.new(field: :category_txt_en, limit: 10)
  request.run(page: 1, page_size: 10)
```

#### Query with facets

```ruby
  fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name_txt_en),
    Solr::Query::Request::FieldWithBoost.new(field: :category_txt_en)
  ]
  request = Solr::Query::Request.new(search_term: 'term', fields: fields)
  request.facets = [Solr::Query::Request::Facet.new(type: :terms, field: :category_txt_en, options: { limit: 10 })]
  request.run(page: 1, page_size: 10)
```

#### Query with boosting functions

```ruby
  fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name_txt_en),
    Solr::Query::Request::FieldWithBoost.new(field: :category_txt_en)
  ]
  request = Solr::Query::Request.new(search_term: 'term', fields: fields)
  request.boosting = Solr::Query::Request::Boosting.new(
    multiplicative_boost_functions: [Solr::Query::Request::Boosting::RankingFieldBoostFunction.new(field: :name_txt_en)],
    phrase_boosts: [Solr::Query::Request::Boosting::PhraseProximityBoost.new(field: :category_txt_en, boost_magnitude: 4)]
  )
  request.run(page: 1, page_size: 10)
```

#### Field list


```ruby
  fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name_txt_en),
    Solr::Query::Request::FieldWithBoost.new(field: :category_txt_en)
  ]
  request = Solr::Query::Request.new(search_term: 'term', fields: fields)
  # Solr::Query::Request will return only :id field by default.
  # Specify additional return fields (fl param) by setting the request response_fields
  request.response_fields = [:name_txt_en, :category_txt_en]
  request.run(page: 1, page_size: 10)
```

### Deleting documents

```ruby
Solr.delete_by_id(3242343)
Solr.delete_by_id(3242343, commit: true)
Solr.delete_by_query('*:*')
Solr.delete_by_query('*:*', commit: true)
```

### Using multi-core configuration

For multi-core configuration use `Solr.with_core` block:

```ruby
Solr.with_core(:models) do
  Solr.delete_by_id(3242343)
  Solr::Query::Request.new(search_term: 'term', fields: fields)
  Solr::Indexing::Request.new(documents: [doc])
end
```

## Running specs

This project is setup to use CI to run all specs agains a real solr.

If you want to run it locally, you can either use  [CircleCI CLI](https://circleci.com/docs/2.0/local-cli/)
or do a completely manual setup (for up-to-date steps see circleci config)

```sh
docker pull solr:7.4.0
docker run -it --name test-solr -p 8983:8983/tcp -t solr:7.4.0
# create a core
curl 'http://localhost:8983/solr/admin/cores?action=CREATE&name=test-core&configSet=_default'
# disable field guessing
curl http://localhost:8983/solr/test-core/config -d '{"set-user-property": {"update.autoCreateFields":"false"}}'
SOLR_URL=http://localhost:8983/solr/test-core rspec
```
