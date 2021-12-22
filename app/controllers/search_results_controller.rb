class SearchResultsController < ApplicationController
  before_action :extract_data, only: :upload
  before_action :load_search, only: [:raw_code, :destroy]

  def upload(data)
    # converting data to array, nested arrays to single array and removing all null values if it exists
    queries = data.to_a.flatten.compact

    unless queries.empty? || queries.count > 100
      # send the data to redis server so sidekiq will load from there and save queries to database
      # calls class at app/jobs/upload_data_job.rb
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
          # rescue if user uploads invalid file type
          begin
            # using CSV to read the file
            data = CSV.read((file.path))
            # only csv file will be passed
            upload(data)
          rescue
            flash[:errors] = 'Unsupported file type! Only CSV type supported!'
            redirect_to :root
          end
        else
          flash[:errors] = 'Please Upload a File'
          redirect_to :root
        end
      end

      def load_search
        @search = SearchResult.find(params[:id])
      end
end
