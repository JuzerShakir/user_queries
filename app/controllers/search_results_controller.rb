class SearchResultsController < ApplicationController
  before_action :extract_data, only: :upload
  before_action :load_search, only: [:raw_code, :destroy]

  def upload(data)
    # converting data to array, nested arrays to single array and removing all null values if it exists
    queries = data.to_a.flatten.compact

    if Rails.env.production?
      args = %w[--headless --disable-gpu --no-sandbox --disable-dev-shm-usage]
      options = {
        binary: ENV['GOOGLE_CHROME_BIN'],
        prefs: { password_manager_enable: false, credentials_enable_service: false },
        args:  args,
        switches: ['--incognito']}

      browser = Watir::Browser.new :chrome, options: options
    else
      browser = Watir::Browser.new :chrome, switches: ['--incognito'], headless: 'start'
    end

    unless queries.empty? || queries.count > 100
        queries.each do | query |
          en_query = ERB::Util.url_encode(query)       # =>  URL encode the string for special characters to work
          browser.goto "https://www.google.com/search?q=#{en_query}"

          page = Nokogiri::HTML(browser.html)    # =>  extract all html code of the page

          links = page.css('a')
          links.map {|element| element["href"]}

          results = page.xpath("//div[contains(@id, 'result-stats')]")
          no_of_results = results.children[0]       # =>  returns no.of results
          result_time = results.children.children   # =>  returns response time
          results_count = "#{no_of_results}#{result_time}"   # =>  concatenate both varaibles

          search_ads = page.xpath("//div[contains(@data-text-ad, 1)]").count           # =>  no.of adwords show up on a page
          shopping_ads = page.xpath("//div[contains(@class, 'mnr-c pla-unit')]").count      # =>  no.of shopping ads show up on a page

          # when there are more than 60-65 queries, google stops giving results and asks for recaptcha..
          # .. to make sure a robot is not making huge number of requests, hence the 'page' variable has inapprpriate data..
          # .. to avoid this, the 'results' var will have no data so we check if its empty, when it is we pause the..
          # .. program for about a min and continue from the query we left off
          if results_count.empty?
            sleep(50)
            redo
          else
            # initiating SearchResults table of uploader
            user_search = current_user.search_results.new
            user_search.keyword = query     # => saving the search query in the table
            user_search.html_code = page
            user_search.links_count = links.count              # =>  returns total no. of links in a query
            user_search.adwords_count = search_ads + shopping_ads
            user_search.results_count = results_count
            user_search.save
          end
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
