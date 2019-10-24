[![CircleCI](https://circleci.com/gh/machinio/solrb/tree/master.svg?style=svg)](https://circleci.com/gh/machinio/solrb/tree/master)
[![Maintainability](https://api.codeclimate.com/v1/badges/81e84c1c42f10f9da801/maintainability)](https://codeclimate.com/github/machinio/solrb/maintainability)
[![Gem Version](https://badge.fury.io/rb/solrb.svg)](https://badge.fury.io/rb/solrb)

Solrb
======

Object-Oriented approach to Solr in Ruby.

## Table of contents

* [Installation](#installation)
* [Configuration](#configuration)
  * [Setting Solr URL via environment variable](#setting-solr-url-via-environment-variable)
  * [Single core configuration](#single-core-configuration)
  * [Multiple core configuration](#multiple-core-configuration)
  * [Solr Cloud](#solr-cloud)
  * [Basic Authentication](#basic-authentication)
* [Indexing](#indexing)
* [Querying](#querying)
  * [Simple Query](#simple-query)
  * [Querying multiple cores](#querying-multiple-cores)
  * [Query with field boost](#query-with-field-boost)
  * [Query with filtering](#query-with-filtering)
  * [Query with sorting](#query-with-sorting)
  * [Query with grouping](#query-with-grouping)
  * [Query with facets](#query-with-facets)
  * [Query with boosting functions](#query-with-boosting-functions)
    * [Dictionary boosting function](#dictionary-boosting-function)
  * [Field list](#field-list)
* [Deleting documents](#deleting-documents)
* [Active Support instrumentation](#active-support-instrumentation)
* [Testing](#running-specs)
* [Running specs](#running-specs)


# Installation

Add `solrb` to your Gemfile:

```ruby
gem 'solrb'
```

If you are going to use solrb with solr cloud:

```ruby
gem 'zk' # required for solrb solr-cloud integration
gem 'solrb'
```

# Configuration

## Setting Solr URL via environment variable

The simplest way to use Solrb is `SORL_URL` environment variable (that has a core name in it):

```bash
  ENV['SOLR_URL'] = 'http://localhost:8983/solr/demo'
```


You can also use `Solr.configure` to specify the solr URL explicitly:

```ruby
Solr.configure do |config|
  config.url = 'http://localhost:8983/solr/demo'
end
```

It's important to note that those fields that are not configured, will be passed as-is to solr.
*So you only need to specify fields in configuration if you want Solrb to modify them at runtime*.

## Single core configuration

Use `Solr.configure` for an additional configuration:

```ruby
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

## Multiple core configuration

```ruby
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

## Solr Cloud

To enable solr cloud mode you must define a zookeeper url on solr config block.
In solr cloud mode you don't need to provide a solr url (`config.url` or `ENV['SOLR_URL']`).
Solrb will watch the zookeeper state to receive up-to-date information about active solr nodes including the solr urls.


You can also specify the ACL credentials for Zookeeper. [More Information](https://lucene.apache.org/solr/guide/7_6/zookeeper-access-control.html#ZooKeeperAccessControl-AboutZooKeeperACLs)


```ruby
Solr.configure do |config|
  config.zookeeper_urls = ['localhost:2181', 'localhost:2182', 'localhost:2183']
  config.zookeeper_auth_user = 'zk_acl_user'
  config.zookeeper_auth_password = 'zk_acl_password'
end
```

If you are using puma web server in clustered mode you must call `enable_solr_cloud!` on `on_worker_boot`
callback to make each puma worker connect with zookeeper.


```ruby
on_worker_boot do
  Solr.enable_solr_cloud!
end
```

## Master-slave

To enable master-slave mode you must define a master url and slave url on solr config block.
In solr master-slave mode you don't need to provide a solr url (`config.url` or `ENV['SOLR_URL']`).

```ruby
Solr.configure do |config|
  config.master_url = 'localhost:8983'
  config.slave_url = 'localhost:8984'
  # Disable select queries from master:
  config.disable_read_from_master = true
end
```

If you are using puma web server in clustered mode you must call `enable_master_slave!` on `on_worker_boot`
callback to make each puma worker connect with zookeeper.


```ruby
on_worker_boot do
  Solr.enable_master_slave!
end
```

## Force node URL

You can force solrb to use a specific node URL with the `with_node_url` method:

```ruby
Solr.with_node_url('http://localhost:9000') do
  Solr::Query::Request.new(search_term: 'example', query_fields: query_fields).run
end
```


## Basic Authentication

Basic authentication is supported by solrb. You can enable it by providing `auth_user` and `auth_password`
on the config block.

```ruby
Solr.configure do |config|
  config.auth_user = 'user'
  config.auth_password = 'password'
end
```

# Indexing

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

# Querying

## Simple Query

```ruby
  query_field = Solr::Query::Request::FieldWithBoost.new(field: :name)

  request = Solr::Query::Request.new(search_term: 'term', query_fields: [query_field])
  request.run(page: 1, page_size: 10)
```
## Querying multiple cores

For multi-core configuration use `Solr.with_core` block:

```ruby
Solr.with_core(:models) do
  Solr.delete_by_id(3242343)
  Solr::Query::Request.new(search_term: 'term', query_fields: query_fields)
  Solr::Indexing::Request.new(documents: [doc])
end
```

## Query with field boost

```ruby
  query_fields = [
    # Use boost_magnitude argument to apply boost to a specific field that you query
    Solr::Query::Request::FieldWithBoost.new(field: :name, boost_magnitude: 16),
    Solr::Query::Request::FieldWithBoost.new(field: :title)
  ]
  request = Solr::Query::Request.new(search_term: 'term', query_fields: query_fields)
  request.run(page: 1, page_size: 10)
```

## Query with filtering

```ruby
  query_fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name),
    Solr::Query::Request::FieldWithBoost.new(field: :title)
  ]
  filters = [Solr::Query::Request::Filter.new(type: :equal, field: :title, value: 'A title')]
  request = Solr::Query::Request.new(search_term: 'term', query_fields: query_fields, filters: filters)
  request.run(page: 1, page_size: 10)
```

### AND and OR filters

```ruby
  usa_filter =
    Solr::Query::Request::AndFilter.new(
      Solr::Query::Request::Filter.new(type: :equal, field: :contry, value: 'USA'),
      Solr::Query::Request::Filter.new(type: :equal, field: :region, value: 'Idaho')
    )
  canada_filter =
    Solr::Query::Request::AndFilter.new(
      Solr::Query::Request::Filter.new(type: :equal, field: :contry, value: 'Canada'),
      Solr::Query::Request::Filter.new(type: :equal, field: :region, value: 'Alberta')
    )

  location_filters = Solr::Query::Request::OrFilter.new(usa_filter, canada_filter)
  request = Solr::Query::Request.new(search_term: 'term', filters: location_filters)
  request.run(page: 1, page_size: 10)
```

## Query with sorting

```ruby
  query_fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name),
    Solr::Query::Request::FieldWithBoost.new(field: :title)
  ]
  sort_fields = [Solr::Query::Request::Sorting::Field.new(name: :name, direction: :asc)]
  request = Solr::Query::Request.new(search_term: 'term', query_fields: query_fields)
  request.sorting = Solr::Query::Request::Sorting.new(fields: sort_fields)
  request.run(page: 1, page_size: 10)
```

Default sorting logic is following: nulls last, not-nulls first.

```ruby
  query_fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name)
  ]
  sort_fields = [
    Solr::Query::Request::Sorting::Field.new(name: :is_featured, direction: :desc),
    Solr::Query::Request::Sorting::Function.new(function: "score desc")
  ]
  request = Solr::Query::Request.new(search_term: 'term', query_fields: query_fields)
  request.sorting = Solr::Query::Request::Sorting.new(fields: sort_fields)
  request.run(page: 1, page_size: 10)
```

## Query with grouping

```ruby
  query_fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name),
    Solr::Query::Request::FieldWithBoost.new(field: :category)
  ]
  request = Solr::Query::Request.new(search_term: 'term', query_fields: query_fields)
  request.grouping = Solr::Query::Request::Grouping.new(field: :category, limit: 10)
  request.run(page: 1, page_size: 10)
```

## Query with facets

```ruby
  query_fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name),
    Solr::Query::Request::FieldWithBoost.new(field: :category)
  ]
  request = Solr::Query::Request.new(search_term: 'term', query_fields: query_fields)
  request.facets = [Solr::Query::Request::Facet.new(type: :terms, field: :category, options: { limit: 10 })]
  request.run(page: 1, page_size: 10)
```

## Query with boosting functions

```ruby
  query_fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name),
    Solr::Query::Request::FieldWithBoost.new(field: :category)
  ]
  request = Solr::Query::Request.new(search_term: 'term', query_fields: query_fields)
  request.boosting = Solr::Query::Request::Boosting.new(
    multiplicative_boost_functions: [Solr::Query::Request::Boosting::RankingFieldBoostFunction.new(field: :name)],
    phrase_boosts: [Solr::Query::Request::Boosting::PhraseProximityBoost.new(field: :category, boost_magnitude: 4)]
  )
  request.run(page: 1, page_size: 10)
```
### Dictionary boosting function
Sometimes you want to do a dictionary-style boosting
example: given a hash (dictionary)

```ruby
{3025 => 2.0, 3024 => 1.5, 3023 => 1.2}
```

and a field of `category_id`
the resulting boosting function will be:
```
if(eq(category_id_it, 3025), 2.0, if(eq(category_id_it, 3024), 1.5, if(eq(category_id_it, 3023), 1.2, 1)))
```
note that I added spaces for readability, real Solr query functions must always be w/out spaces

Example of usage:

```ruby
  category_id_boosts = {3025 => 2.0, 3024 => 1.5, 3023 => 1.2}
  request.boosting = Solr::Query::Request::Boosting.new(
    multiplicative_boost_functions: [
      Solr::Query::Request::Boosting::DictionaryBoostFunction.new(field: :category_id,
        dictionary: category_id_boosts)
    ]
  )
```

## Field list


```ruby
  query_fields = [
    Solr::Query::Request::FieldWithBoost.new(field: :name),
    Solr::Query::Request::FieldWithBoost.new(field: :category)
  ]
  request = Solr::Query::Request.new(search_term: 'term', query_fields: query_fields)
  # Solr::Query::Request will return only :id field by default.
  # Specify additional return fields (fl param) by setting the request field_list
  request.field_list = [:name, :category]
  request.run(page: 1, page_size: 10)
```

# Deleting documents

```ruby
Solr.delete_by_id(3242343)
Solr.delete_by_id(3242343, commit: true)
Solr.delete_by_query('*:*')
Solr.delete_by_query('*:*', commit: true)
```

# Active Support instrumentation

This gem publishes events via [Active Support Instrumentation](https://edgeguides.rubyonrails.org/active_support_instrumentation.html)

To subscribe to solrb events, you can add this code to initializer:

```ruby
ActiveSupport::Notifications.subscribe('request.solrb')  do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  if Logger::INFO == Rails.logger.level
    Rails.logger.info("Solrb #{event.duration.round(1)}ms")
  elsif Logger::DEBUG == Rails.logger.level && Rails.env.development?
    Pry::ColorPrinter.pp(event.payload)
  end
end
```

# Testing

It's possible to inspect the parameters for each solr query request done using Solrb by requiring
`solr/testing` file in your test suite. The query parameters will be accessible by reading
`Solr::Testing.last_solr_request_params` after each request.

```ruby
require 'solr/testing'

RSpec.describe MyTest do
  let(:query) { Solr::Query::Request.new(search_term: 'Solrb') }
  it 'returns the last solr request params' do
    query.run(page: 1, page_size: 10)
    expect(Solr::Testing.last_solr_request_params).to eq({ ... })
  end
end
```



# Running specs

This project is setup to use CI to run all specs agains a real solr.

If you want to run it locally, you can either use  [CircleCI CLI](https://circleci.com/docs/2.0/local-cli/)
or do a completely manual setup (for up-to-date steps see circleci config)

```sh
docker pull solr:7.7.1
docker run -it --name test-solr -p 8983:8983/tcp -t solr:7.7.1
# create a core
curl 'http://localhost:8983/solr/admin/cores?action=CREATE&name=test-core&configSet=_default'
# disable field guessing
curl http://localhost:8983/solr/test-core/config -d '{"set-user-property": {"update.autoCreateFields":"false"}}'
SOLR_URL=http://localhost:8983/solr/test-core rspec
```
