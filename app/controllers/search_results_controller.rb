class SearchResultsController < ApplicationController
  before_action :extract_data, only: :upload
  before_action :load_search, only: [:raw_code, :destroy]

  def upload(data)
    # converting data to array, nested arrays to single array and removing all null values if it exists
    queries = data.to_a.flatten.compact

    unless queries.empty? || queries.count > 100
      queries.each do | query |
        # initiating SearchResults table of that user
        user_search = current_user.search_results.new

        user_search.keyword = query     # => saving the search query in the table

        if Rails.env.production?
          args = %w[--headless --disable-gpu]
          options = {
            binary: ENV['GOOGLE_CHROME_BIN'],
            prefs: { password_manager_enable: false, credentials_enable_service: false },
            args:  args
          }
          browser = Watir::Browser.new :chrome, options: options
        else
          browser = Watir::Browser.new :chrome, headless: 'start'
        end

        en_query = ERB::Util.url_encode(query)       # =>  URL encode the string for special characters to work
        browser.goto "https://www.google.com/search?q=#{en_query}"
        page = Nokogiri::HTML(browser.html)    # =>  extract all html code of the page
        user_search.html_code = page

        #query = page.title.split('-')[0]  # =>  returns search query string

        links = page.css('a')
        links.map {|element| element["href"]}
        user_search.links_count = links.count              # =>  returns total no. of links in a query

        results = page.xpath("//div[contains(@id, 'result-stats')]")
        no_of_results = results.children[0]       # =>  returns no.of results
        result_time = results.children.children   # =>  returns response time
        user_search.results_count = "#{no_of_results}#{result_time}"   # =>  concatenate both varaibles

        search_ads = page.xpath("//div[contains(@data-text-ad, 1)]").count           # =>  no.of adwords show up on a page
        shopping_ads = page.xpath("//div[contains(@class, 'mnr-c pla-unit')]").count      # =>  no.of shopping ads show up on a page
        user_search.adwords_count = search_ads + shopping_ads
        user_search.save
      end
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
