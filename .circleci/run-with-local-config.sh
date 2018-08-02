#!/usr/bin/env bash
curl --user ${CIRCLE_TOKEN}: \
    --request POST \
    --form revision=80bb07a5e12ef23379ce3404960e9eb87a9f4129 \
    --form config=@config.yml \
    --form notify=false \
        https://circleci.com/api/v1.1/project/github/machinio/solrb/tree/master