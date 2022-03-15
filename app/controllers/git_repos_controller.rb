class GitReposController < ApplicationController
	def search
		if params[:search_keyword]
			response_data = ResponseFormatter.new(filter_params[:search_keyword], page, per_page).call  
			response_data.success? ? set_data(response_data) : set_error(response_data)
		end
	end

	private

	def filter_params
  	params.permit(:search_keyword, :per_page, :page)
	end

	def page
		filter_params[:page] || PAGE
	end

	def per_page
		filter_params[:per_page] || PER_PAGE
	end

	def set_data(response_data)
		@repos_list = response_data.body
	end

	def set_error(response_data)
		@error = response_data.error
	end

end
