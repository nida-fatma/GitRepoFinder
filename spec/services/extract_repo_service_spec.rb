require 'rails_helper'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

describe ExtractRepoService do

  before(:each) do
    stub_request(:get, /api.github.com/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: "stubbed response", headers: {})
  end

  describe 'ExtractRepoService #success call' do
  	before do
      stub_request(:get, "https://api.github.com/search/repositories?page=1&per_page=20&q=search_keyword").
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: {total_count: 5, incomplete_results: false, items: [{id: 1}, {id: 2}]}.to_json, headers: {})
    end
    it 'fetch the repositories from github' do
      response = ExtractRepoService.new('search_keyword', 1, 20).call
      expect(response.code).to eq("200")
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('items')
    end
  end

  describe 'ExtractRepoService #success call' do
  	before do
      stub_request(:get, "https://api.github.com/search/repositories?page=100&per_page=200&q=unrealistic123keyword567xyz").
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 422, body: {"message"=>"Only the first 1000 search results are available"}.to_json, headers: {})
    end
    it 'fetch the repositories from github' do
      response = ExtractRepoService.new('unrealistic123keyword567xyz', 100, 200).call
      expect(response.code).to eq("422")
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('message')
    end
  end

end


