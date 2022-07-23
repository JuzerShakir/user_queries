class UploadDataJob < ApplicationJob
  queue_as :default

  def perform(queries, current_user)
    # if Rails.env.production?
    #   args = %w[--headless --disable-gpu --no-sandbox --disable-dev-shm-usage]
    #   options = {
    #     binary: ENV['GOOGLE_CHROME_BIN'],
    #     prefs: { password_manager_enable: false, credentials_enable_service: false },
    #     args:  args,
    #     switches: ['--incognito']}

    #   browser = Watir::Browser.new :chrome, options: options
    # else
    # end
    # browser = Watir::Browser.new :chrome, switches: ['--incognito'], headless: 'start'
    # browser = Watir::Browser.new :chrome
    browser = Watir::Browser.new :chrome, options: {args: '--incognito'}

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
        sleep(25)
        redo
      else
        # saving search results data of that user
        current_user.search_results.create(keyword: query,
                                          html_code: page,
                                          links_count: links.count,
                                          adwords_count: search_ads + shopping_ads,
                                          results_count: results_count)
      end
    end
  end
end
