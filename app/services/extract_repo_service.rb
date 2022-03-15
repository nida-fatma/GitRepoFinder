class ExtractRepoService
	require 'net/http'
	attr_reader :search_keyword, :page, :per_page
	BASE_URL = 'https://api.github.com'.freeze


	def initialize(search_keyword, page, per_page)
    @search_keyword = search_keyword
    @page = page
    @per_page = per_page
  end

  def call
  	uri = URI.parse(request_url)
		begin
			Net::HTTP.get_response(URI.parse(request_url))
		rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError, SocketError => e
			Rails.logger.error { "#{e.message} #{e.backtrace.join("\n")}" }			
			OpenStruct.new({code: 500, body: {"message" => e.message}.to_json})
		end
  end

  private
  def request_url
  	"#{BASE_URL}/search/repositories?#{search_parameters.to_query}"
  end

  def search_parameters
  	{q: search_keyword, page: page, per_page: per_page}
  end

end
