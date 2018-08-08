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

## Usage

### Indexing

```ruby
# creates a single document and commits it to index
doc = Solr::Indexing::Document.new
doc.add_field(:id, 1)
doc.add_field(:name, 'Solrb!!!')
request = Solr::Indexing::Request.new([doc])
request.run(commit: true)
```

You can also create indexing document directly from attributes:

```ruby
doc = Solr::Indexing::Document.new(id: 5, name: 'John')
```


### Deleting documents

```ruby
Solr.delete_by_id(3242343)
Solr.delete_by_id(3242343, commit: true)
Solr.delete_by_query('*:*')
Solr.delete_by_query('*:*', commit: true)
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
