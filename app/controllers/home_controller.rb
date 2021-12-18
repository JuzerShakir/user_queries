class HomeController < ApplicationController
  def index
    @search_result = SearchResult.new
    @searches = current_user.search_results
  end
end
