class UploadDataJob < ApplicationJob
  queue_as :default

  def perform(queries, current_user)
      queries.each do | query |
        # initiating SearchResults table of that user
        user_search = current_user.search_results.new

        user_search.keyword = query     # => saving the search query in the table

        browser = Watir::Browser.new :chrome, headless: 'start'
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

  end
end
