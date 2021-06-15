# Leaderboard app using Ruby on Rails and Redis

This application demonstrates a leaderboard backed by Redis. The app uses company valuation and stock tickers as its domain.

## Technical Stack

- Frontend: Ruby on Rails
- Backend: Redis

# How it works?

## How the data is stored:

- The stock ticker and valuation data are stored in a Redis hash like so:
  - `HSET "company:AAPL" symbol "AAPL" market_cap "2600000000000" country USA`
- The leaderboard and ranking themselves are stored in a sorted set using the <a href="https://redislabs.com/ebook/part-1-getting-started/chapter-1-getting-to-know-redis/1-2-what-redis-data-structures-look-like/1-2-5-sorted-sets-in-redis/">ZSET</a> command:
  - `ZADD companyLeaderboard 2600000000000 company:AAPL`

## How the data is accessed:

- Top 10 companies:
  - `ZREVRANGE companyLeaderboard 0 9 WITHSCORES`
- All companies:
  - `ZREVRANGE companyLeaderboard 0 -1 WITHSCORES`
- Bottom 10 companies:
  - `ZRANGE companyLeaderboard 0 9 WITHSCORES`
- Between rank 10 and 15:
  - `ZREVRANGE companyLeaderboard 9 14 WITHSCORES`
- Show ranks of AAPL, FB and TSLA:
  - `ZSCORE companyLeaderBoard company:AAPL company:FB company:TSLA`
- Adding market cap to companies:
  - `ZINCRBY companyLeaderBoard 1000000000 "company:FB"`
- Reducing market cap to companies:
  - `ZINCRBY companyLeaderBoard -1000000000 "company:FB"`

### Code Example: Get companies by filter

```Ruby
  def sort
    case @params[:sort]
    when 'top10'
      redis.zrevrange("companyLeaderboard", 0, 9, withscores: true)
      @redis.set('top10', add_rank(@companies.reverse.first(10), 1, 'plus'))
    when 'all'
      redis.zrevrange("companyLeaderboard", 0, -1, withscores: true)
      @redis.set('all', add_rank(@companies.reverse, 1, 'plus'))
    when 'bottom10'
      redis.zrange("companyLeaderboard", 0, 9, withscores: true)
      @redis.set('bottom10', add_rank(@companies.first(10), 10, 'minus'))
    when 'symbols'
      companies = @companies.select do |c|
        @params[:values].tr('[]', '')
                        .split(', ')
                        .map(&:upcase)
                        .include?(c['symbol'])
      end
      @redis.set('symbols', add_rank(companies.first(10), nil, nil))
    when 'between_rank'
      redis.zrange("companyLeaderboard", 9, 14, withscores: true)
      @redis.set('between_rank', add_rank(select_by_range(9, 14), 10, 'plus'))
    when 'inRank'
      companies = select_by_range(@params[:start], @params[:end])
      @redis.set('inRank', add_rank(companies, (@params[:end].to_i - 9), 'plus'))
    else
      @redis.get('companies')
    end
      @redis.get(@params[:sort])
    end
  end
```

## How to run it locally?

### Prerequisites

- Ruby - v2.7.2
- Rails - v6.1.3.1

## Development

```
git clone https://github.com/redis-developer/basic-redis-leaderboard-demo-ruby.git
```

#### Run app

```sh
bundle install
bin/rails server
```

#### Compile assets

```sh
bin/webpack-dev-server
```

#### Run in browser

```sh
open your browser and put 'http://localhost:3000'
```

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
