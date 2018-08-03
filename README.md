[![CircleCI](https://circleci.com/gh/machinio/solrb/tree/master.svg?style=svg)](https://circleci.com/gh/machinio/solrb/tree/master)
[![Maintainability](https://api.codeclimate.com/v1/badges/81e84c1c42f10f9da801/maintainability)](https://codeclimate.com/github/machinio/solrb/maintainability)

# Solrb [WIP]

Object-Oriented approach to Solr in Ruby. 
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'solrb'
```

## Usage

### Indexing

```ruby
# creates a single document and commits it to index
doc = Solr::Indexing::Document.new
doc.add_field(:id, 1)
doc.add_field(:name, 'Solrb!!!')
request = Solr::Indexing::Request.new([doc], commit: true)
request.run
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
or do a completely manual setup:

```sh
docker pull solr:7.4.0
docker run -it --name test-solr -p 8983:8983/tcp -t solr:7.4.0
# create a core
curl 'http://localhost:8983/solr/admin/cores?action=CREATE&name=test-core&configSet=_default'
SOLR_URL=http://localhost:8983/solr/test-core rspec
```
