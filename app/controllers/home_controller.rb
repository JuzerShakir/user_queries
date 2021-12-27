class HomeController < ApplicationController
  def index
    @search_result = SearchResult.new
    @searches = current_user.search_results.order(created_at: :desc) if current_user
  end
end
