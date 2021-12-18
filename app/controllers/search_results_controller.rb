class SearchResultsController < ApplicationController
  before_action :extract_data, only: :upload
  before_action :load_search, only: [:raw_code, :destroy]

  def upload(data)
    # converting data to array, nested arrays to single array and removing all null values if it exists
    queries = data.to_a.flatten.compact

    unless queries.empty? || queries.count > 100
      UploadDataJob.perform_later(queries, current_user)
    else
      flash[:errors] = 'Search Queries in the file are either more than 100 or empty'
    end
    redirect_to :root
  end

  def raw_code
    @raw_data = @search.html_code
  end

  def destroy
    @search.destroy
    redirect_to :root
  end

  private

      def extract_data
        if params[:search_result] # =>  this will return nill if user clicks on 'upload' without a file
          # getting user-uploaded-file from params
          file = params[:search_result][:file]
          # using CSV to read the file
          data = CSV.read((file.path))
          upload(data)
        else
          flash[:errors] = 'Please Upload a File'
          redirect_to :root
        end
      end

      def load_search
        @search = SearchResult.find(params[:id])
      end
end
