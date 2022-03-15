require 'rails_helper'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

describe GitReposController do


  describe 'GET #search' do
    before do
      stub_request(:get, /api.github.com/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: "stubbed response", headers: {})
    end
    it 'fetch the repositories from github and display' do
      get :search
      expect(response.body).to be_an_instance_of(String)
    end
  end

end



