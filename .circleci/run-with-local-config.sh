#!/usr/bin/env bash
curl --user ${CIRCLE_TOKEN}: \
    --request POST \
    --form revision=67d7c5937163 \
    --form config=@config.yml \
    --form notify=false \
        https://circleci.com/api/v1.1/project/github/machinio/solrb/tree/master