RSpec.describe Solr::BasicResponse do
  it 'parses bad request' do
    body = <<~EOF
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
      EOF
    raw_response = double(status: 400, reason_phrase: 'Bad Request', body: body)
    res = described_class.from_raw_response(raw_response)
    expect(res).not_to be_ok
    expect(res).to be_error
    expect(res.status).to eq 400
    expect(res.error_message).to eq 'Document is missing mandatory uniqueKey field: id'
  end
end