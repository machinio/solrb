[![CircleCI](https://circleci.com/gh/machinio/solrb/tree/master.svg?style=svg)](https://circleci.com/gh/machinio/solrb/tree/master)
[![Maintainability](https://api.codeclimate.com/v1/badges/81e84c1c42f10f9da801/maintainability)](https://codeclimate.com/github/machinio/solrb/maintainability)

# Solrb

Object-Oriented approach to Solr in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'solrb', require: 'solr'
```

## Configuration

The simplest way to use Solrb is `SORL_URL` environment variable (that has a core name in it):

```bash
  ENV['SOLR_URL'] = 'http://localhost:8983/solr/demo'
```

or through `Solr.configure` to specify the solr URL:

```ruby
# Single core configuration
Solr.configure do |config|
  config.url = 'http://localhost:8983/solr/demo'
end
```

Use `Solr.configure` for an additional configuration:

```ruby
# Single core configuration
Solr.configure do |config|
  config.url = 'http://localhost:8983/solr/demo'

  # This gem uses faraday to make requests to Solr. You can specify additional faraday
  # options here.
  config.faraday_options = {}

  # Core's URL is 'http://localhost:8983/solr/demo'
  # Adding fields to work with
  config.define_core do |f|
    f.field :title, dynamic_field: :text
    f.dynamic_field :text, solr_name: '*_text'
  end
end
```

```ruby
# Multiple core configuration
Solr.configure do |config|
  config.url = 'http://localhost:8983/solr'

  # Define a core with fields that will be used with Solr.
  # Core URL is 'http://localhost:8983/solr/listings'
  config.define_core(name: :listings) do |f|
    # When a dynamic_field is present, the field name will be mapped to match the dynamic field.
    # Here, "title" will be mapped to "title_text"
    # You must define a dynamic field to be able to use the dynamic_field option
    f.field :title, dynamic_field: :text

    # When solr_name is present, the field name will be mapped to the solr_name at runtime
    f.field :tags, solr_name: :tags_array

    # define a dynamic field
    f.dynamic_field :text, solr_name: '*_text'
  end

  # Pass `default: true` to use one core as a default.
  # Core's URL is 'http://localhost:8983/solr/cars'
  config.define_core(name: :cars, default: true) do |f|
    f.field :manufacturer, solr_name: :manuf_s
    f.field :model, solr_name: :model_s
  end
end
```

It's important to note that those fields that are not configured, will be passed as-is to solr.
*So you only need to specify fields in configuration if you want Solrb to modify them at runtime*.


Warning: Solrb doesn't support fields with the same name. If you have two fields with the same name mapping
to a single solr field,  you'll have to rename one of the fields.

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
  field = Solr::Query::Request::FieldWithBoost.new(field: :name)

  request = Solr::Query::Request.new(search_term: 'term', fields: [field])
  request.run(page: 1, page_size: 10)
```

#### Query with field boost

```ruby
  fields = [
    # Use boost_magnitude argument to apply boost to a specific field that you query
    Solr::Query::Request::FieldWithBoost.new(field: :name, boost_magnitude: 16),
    Solr::Query::Request::FieldWithBoost.new(field: :title)
  ]
  request = Solr::Query::Request.new(search_term: 'term', fields: fields)
  request.run(page: 1, page_size: 10)
```

#### Query with filters

```ruby
  fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name),
    Solr::Query::Request::FieldWithBoost.new(field: :title)
  ]
  filters = [Solr::Query::Request::Filter.new(type: :equal, field: :title, value: 'A title')]
  request = Solr::Query::Request.new(search_term: 'term', fields: fields, filters: filters)
  request.run(page: 1, page_size: 10)
```


#### Query with sorting

```ruby
  fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name),
    Solr::Query::Request::FieldWithBoost.new(field: :title)
  ]
  sort_fields = [Solr::Query::Request::Sorting::Field.new(name: :name, direction: :asc)]
  request = Solr::Query::Request.new(search_term: 'term', fields: fields)
  request.sorting = Solr::Query::Request::Sorting.new(fields: sort_fields)
  request.run(page: 1, page_size: 10)
```

#### Query with grouping

```ruby
  fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name),
    Solr::Query::Request::FieldWithBoost.new(field: :category)
  ]
  request = Solr::Query::Request.new(search_term: 'term', fields: fields)
  request.grouping = Solr::Query::Request::Grouping.new(field: :category, limit: 10)
  request.run(page: 1, page_size: 10)
```

#### Query with facets

```ruby
  fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name),
    Solr::Query::Request::FieldWithBoost.new(field: :category)
  ]
  request = Solr::Query::Request.new(search_term: 'term', fields: fields)
  request.facets = [Solr::Query::Request::Facet.new(type: :terms, field: :category, options: { limit: 10 })]
  request.run(page: 1, page_size: 10)
```

#### Query with boosting functions

```ruby
  fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name),
    Solr::Query::Request::FieldWithBoost.new(field: :category)
  ]
  request = Solr::Query::Request.new(search_term: 'term', fields: fields)
  request.boosting = Solr::Query::Request::Boosting.new(
    multiplicative_boost_functions: [Solr::Query::Request::Boosting::RankingFieldBoostFunction.new(field: :name)],
    phrase_boosts: [Solr::Query::Request::Boosting::PhraseProximityBoost.new(field: :category, boost_magnitude: 4)]
  )
  request.run(page: 1, page_size: 10)
```

#### Field list


```ruby
  fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name),
    Solr::Query::Request::FieldWithBoost.new(field: :category)
  ]
  request = Solr::Query::Request.new(search_term: 'term', fields: fields)
  # Solr::Query::Request will return only :id field by default.
  # Specify additional return fields (fl param) by setting the request response_fields
  request.response_fields = [:name, :category]
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
