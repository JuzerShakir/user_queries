# Project: User Queries
*Extracts large amounts of data from the Google search results page of search queries from a user uploaded CSV file.*

<div align="center">
  <img src="public/assets/project_logo.png" />
</div>

![](https://visitor-badge-reloaded.herokuapp.com/badge?page_id=juzershakir.user-queries&color=000000&lcolor=000000&style=for-the-badge&logo=Github)


<a href="https://wakatime.com/@JuzerShakir/projects/zelluuuysx?start=2021-12-16" target="_blank"><img src="https://wakatime.com/badge/user/ccef187f-4308-4666-920d-d0a9a07d713a/project/81f9ebde-1232-4e91-946d-dc8ba839d060.svg" alt="wakatime"></a>


## ❗ Objectives
This web-app must accomplish the following:
- [x] Use devise gem to authenticate user.
- [x] Authenticated users can upload a CSV file of keywords.
- [x] This upload file can be in any size from 1 to 100 keywords.
- [x] The uploaded file contains keywords. Each of these keywords will be used to search on
[Google](http://www.google.com) and they will start to run as soon as they are uploaded.
- [x] For each search result/keyword result page on Google, store the following information on
the first page of results:
  - [1] Total number of AdWords advertisers on the page.
  - [2] Total number of links (all of them) on the page.
  - [3] Total of search results for this keyword e.g. About 21,600,000 results (0.42 seconds).
  - [4] HTML code of the page/cache of the page.

- [x] Allow users to view the list of their uploaded keywords. For each keyword, users can also view the search result information stored in the database.

----

## 💎 Required Gems

**This project was built on Ruby version *2.4.10p364*.**

Following important gems were installed in these versions:

|  **Gem Names**  |         **Gem**         | **Version** |                      **Use**                     |
| :------------:  |     :------------:      | :---------: |                    :---------:                   |
|      Rails      |        _'rails'_        |  **5.2.6**  |    *Use for executing and rendering web-app*     |
|   Postgresql    |          _'pg'_         |  **1.2.3**  | *Use postgres as the database for Active Record* |
|    Bootstrap    |  _'bootstrap-sass'_      |  **3.4.1**  |                *For SCSS Styling*                 |
|    Devise       |        _'devise'_       |  **4.8.1** |      *Flexible authentication solution*      |
|    Sidekiq      |      _'sidekiq'_        |  **5.2.9** |  *For running background Jobs.*     |
|    CSV          |      _'csv'_            |  **3.1.5** |  *To extract data from CSV file*     |
|    Watir        |      _'watir'_          |  **6.16.5** |  *To run browser for the search queries*     |
|    Nokogiri     |       _'nokogiri'_        |  **1.10.10** |  *For extracting HTML code of the search result*     |
|   Webdriver     |    _'webdriver'_        |  **0.19.0**   |  *To run Selenium Webdrivers* |

----

## ⚙️ Setting up a PostgreSQL user

If you don't have a user set on postgres, here's how to set new user:

```bash
sudo -u postgres createuser -s [username]
```
To set a password for this user, log in to the PostgreSQL command line client:
```bash
sudo -u postgres psql
```
Enter the following command to set the password:
```bash
\password your_password
```
Enter and confirm the password. Then exit the PostgreSQL client:
```bash
\q
```

-----

## 📋 Execution

Run the following commands to execute locally:

The following will install required version of ruby (make sure [rvm is installed](https://rvm.io/rvm/install).)

```bash
rvm use 2.4.10
```
```bash
git clone git@github.com:JuzerShakir/user_queries.git
```
```bash
cd user_queries
```
```bash
bundle install
```

### 💡 Imp Note:
> The `config/database.yml` has been added to `.gitignore` but a similar file `config/database.yml.clone` exists in its place. You will need to add your own postgresql username and password in the file. And then rename the file by:

```bash
mv config/database.yml.clone config/database.yml
```
```bash
rails db:create
```

### Setting Up Sidekiq
[Video Tutorial](https://youtu.be/aaGSh38nzq8)

### Setting Up Redis
[Blog Tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-18-04)

After setting up all this, you're ready to use this webapp.

```bash
rails s
```

ENJOY!

-----

To see this web-app up and running without executing above commands locally, I have deployed it on [Heroku](https://user-queries.herokuapp.com/). On heroku, it doesn't use Sideqik yet!

-----

