module GitReposHelper
	def current_page
		(params[:page] || '1').to_i
	end

	def per_page
		(params[:per_page] || '20').to_i
	end

	def previous_page_class
		previous_page? ? '' : 'disabled' 
	end

	def next_page_class
		next_page? ?  '' : 'disabled'
	end

	def total_pages
		@repos_list['total_count']/per_page
	end

	def previous_page_path
		previous_page = current_page - 1
		previous_page? ? root_path(request.query_parameters.merge( "page"=> previous_page)) : '#'
	end

	def next_page_path
		next_page = current_page + 1
		next_page ? root_path(request.query_parameters.merge( "page"=> next_page)) : '0'
	end

	def first_page_path
		root_path(request.query_parameters.merge( "page"=> 1))
	end

	def last_page_path
		root_path(request.query_parameters.merge( "page"=> total_pages))
	end

	def previous_page?
    current_page > 1
  end

  def next_page?
  	current_page < total_pages
  end

  def start_page_number
  	per_page * (current_page - 1)
  end

end
