
# Basic Redis Leaderboard Demo Ruby on Rails

Show how the redis works with Ruby on Rails.

## Screenshots

![How it works](leaderboard/public/screenshot001.png)

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
    <li>Top 10 companies: <pre>ZREVRANGE companyLeaderboard 0 9 WITHSCORES</pre> </li>
    <li>All companies: <pre>ZREVRANGE companyLeaderboard 0 -1 WITHSCORES</pre> </li>
    <li>Bottom 10 companies: <pre>ZRANGE companyLeaderboard 0 9 WITHSCORES</pre></li>
    <li>Between rank 10 and 15: <pre>ZREVRANGE companyLeaderboard 9 14 WITHSCORES</pre></li>
    <li>Show ranks of AAPL, FB and TSLA: <pre>ZSCORE companyLeaderBoard company:AAPL company:FB company:TSLA</pre> </li>
    <li>Adding market cap to companies: <pre>ZINCRBY companyLeaderBoard 1000000000 "company:FB"</pre></li>
    <li>Reducing market cap to companies: <pre>ZINCRBY companyLeaderBoard -1000000000 "company:FB"</pre></li>
    <li>Companies over a Trillion: <pre>ZCOUNT companyLeaderBoard 1000000000000 +inf</pre> </li>
    <li>Companies between 500 billion and 1 trillion: <pre>ZCOUNT companyLeaderBoard 500000000000 1000000000000</pre></li>
</ol>

## How to run it locally?

#### Run frontend

```sh
cd client
npm i
npm run serve
```

#### Run backend

``` sh
cd leaderboard
bundle install
mv config/database.example.yml config/database.yml
rails s
```
