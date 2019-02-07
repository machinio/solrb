RSpec.describe Solr::Response::Parser do
  it 'parses 400 (bad request)' do
    body = <<~RESPONSE_BODY
      {
        "responseHeader":{
          "status":400,
          "QTime":2},
        "error":{
          "metadata":[
            "error-class","org.apache.solr.common.SolrException",
            "root-error-class","org.apache.solr.common.SolrException"],
          "msg":"Document is missing mandatory uniqueKey field: id",
          "code":400}}
    RESPONSE_BODY
    raw_response = double(status: 400, reason_phrase: 'Bad Request', body: body)
    res = described_class.call(raw_response)
    expect(res).not_to be_ok
    expect(res).to be_error
    expect(res.status).to eq 400
    expect(res.error_message).to eq 'Document is missing mandatory uniqueKey field: id'
  end

  it 'parses 404 (not found)' do
    body = <<~RESPONSE_BODY
      <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
        <title>Error 404 Not Found</title>
      </head>
      <body>
        <h2>HTTP ERROR 404</h2>
        <p>Problem accessing /solr/parts/update. Reason:
          <pre>    Not Found</pre>
        </p>
      </body>
      </html>
    RESPONSE_BODY
    raw_response = double(status: 404, reason_phrase: 'Not Found', body: body)
    res = described_class.call(raw_response)
    expect(res).not_to be_ok
    expect(res).to be_error
    expect(res.status).to eq 404
    expect(res.solr_error).not_to be
  end
end
