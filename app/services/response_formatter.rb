class ResponseFormatter
	attr_reader :search_keyword, :page, :per_page

	def initialize(search_keyword, page, per_page)
    @search_keyword = search_keyword
    @page = page
    @per_page = per_page
  end

  def call
    response = ExtractRepoService.new(search_keyword, page, per_page).call
    OpenStruct.new(process_response(response))
  end

  private

  def process_response(response)
  	if response.kind_of? Net::HTTPSuccess			
			{success?: true, body: format_response(response.body)}
		else
			{success?: false, error:  format_error(response.code, response.body)}
		end
  end

  def format_response(repos_json)
  	repo_list = JSON.parse(repos_json)
  	repo_list["items"] = repo_list["items"].map{|h| h.slice('full_name', 'html_url', 'forks_count', 'open_issues_count', 'watchers_count', 'owner')}
  	repo_list
  end

  def format_error(response_code, error_json)
  	error_hash = JSON.parse(error_json)
  	"Api Failed with code: #{response_code} and message: #{error_hash['message']}"
  end

end