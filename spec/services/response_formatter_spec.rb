require 'rails_helper'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

describe ResponseFormatter do

  describe 'ResponseFormatter #success call' do
    before do
      stub_request(:get, "https://api.github.com/search/repositories?page=1&per_page=20&q=search_keyword").
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: {total_count: 5, incomplete_results: false, items: [{id: 1}, {id: 2}]}.to_json, headers: {})
    end
    it 'format repositories from github response' do
      response = ResponseFormatter.new('search_keyword', 1, 20).call
      expect(response).to be_an_instance_of(OpenStruct)
      expect(response.success?).to eq(true)
      expect(response.body).to be_an_instance_of(Hash)
    end
  end

  describe 'ResponseFormatter #failed call' do
    before do
      stub_request(:get, "https://api.github.com/search/repositories?page=100&per_page=200&q=unrealistic123keyword567xyz").
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 422, body: {"message"=>"Only the first 1000 search results are available"}.to_json, headers: {})
    end
    it 'format error from github response' do
      response = ResponseFormatter.new('unrealistic123keyword567xyz', 100, 200).call
      expect(response).to be_an_instance_of(OpenStruct)
      expect(response.success?).to eq(false)
      expect(response.error).to be_an_instance_of(String)
    end
  end

end



