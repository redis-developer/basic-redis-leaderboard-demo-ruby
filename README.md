
# Basic Redis Leaderboard Demo Ruby on Rails

Show how the redis works with Ruby on Rails.

#### Deploy to Heroku

<p>
  <a href="https://heroku.com/deploy" target="_blank">
      <img src="https://www.herokucdn.com/deploy/button.svg" alt="Deploy to Heorku" />
  </a>
</p>
<p>
  <a href="https://deploy.cloud.run/?git_repo=https://github.com/redis-developer/basic-redis-leaderboard-demo-ruby" target="_blank">
      <img src="https://deploy.cloud.run/button.svg" alt="Run on Google Cloud" width="150px"/>
  </a>
</p>


## Screenshots

![How it works](public/screenshot001.png)
<img src="public/screenshot002.png" width="50%" height='200'/><img src="public/screenshot003.png" width="50%" height='200'/>

# How it works?
## 1. How the data is stored:
<ol>
  <li>The company data is stored in a hash like below:
    <pre>HSET "company:AAPL" symbol "AAPL" market_cap "2600000000000" country USA</pre>
   </li>
  <li>The Ranks are stored in a ZSET.
    <pre>ZADD companyLeaderboard 2600000000000 company:AAPL</pre>
  </li>
</ol>

<br/>

## 2. How the data is accessed:
<ol>
    <li>
      Top 10 companies:
      <img src="public/screenshot001.png"/>
      <pre>ZREVRANGE companyLeaderboard 0 9 WITHSCORES</pre>
    </li>
    <li>
      All companies:
      <img src="app/javascript/images/all_companies.png"/>
      <pre>ZREVRANGE companyLeaderboard 0 -1 WITHSCORES</pre>
    </li>
    <li>
      Bottom 10 companies:
      <img src="app/javascript/images/bottom.png"/>
      <pre>ZRANGE companyLeaderboard 0 9 WITHSCORES</pre>
    </li>
    <li>
      Between rank 10 and 15:
      <img src="app/javascript/images/10_15.png"/>
      <pre>ZREVRANGE companyLeaderboard 9 14 WITHSCORES</pre>
    </li>
    <li>
      Show ranks of AAPL, FB and TSLA:
      <img src="app/javascript/images/3_companies.png"/>
      <pre>ZSCORE companyLeaderBoard company:AAPL company:FB company:TSLA</pre>
    </li>
    <li>
      Adding market cap to companies:
      <br>
      <img src="app/javascript/images/add_cap.png"/>
      <pre>ZINCRBY companyLeaderBoard 1000000000 "company:FB"</pre>
    </li>
    <li>
      Reducing market cap to companies:
      <br>
      <img src="app/javascript/images/reduce_cap.png"/>
      <pre>ZINCRBY companyLeaderBoard -1000000000 "company:FB"</pre>
    </li>
</ol>

## How to run it locally?

### Prerequisites

- Ruby - v2.7.2
- Rails - v6.1.3.1

## Development

```
git clone https://github.com/redis-developer/basic-redis-leaderboard-demo-ruby.git
```

#### Run app

``` sh
bundle install
rails db:create

rails s
```

#### Compile assets
``` sh
bin/webpack-dev-server
```

#### Run in browser

``` sh
open your browser and put 'http://localhost:3000'
```
