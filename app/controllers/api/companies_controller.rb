module Api
  class CompaniesController < ApplicationController
    before_action :set_companies

    def index
      render json: CompanyQuery.new(redis, @companies, params).call, status: :ok
    end

    def update
      company = @companies.select { |c| c['symbol'] == params['symbol'] }[0]
      company['marketCap'] += params['amount'].to_i
      redis.zincrby("companyLeaderboard", params['amount'].to_i, company['company'])
      redis.del('companies')
      redis.set('companies', @companies.to_json)
      render json: JSON.parse(redis.get('companies')), status: :ok
    end

    private

    def set_companies
      if redis.get('companies').nil?
        redis.set('companies', COMPANIES.to_json)
        redis.hset("company:#{c[:company]}", "symbol", c['symbol'], "market_cap", c['marketCap'], "country", c['country'])
        redis.zadd('companyLeaderboard', c[:marketCap], "company:#{c[:company]}")
      end

      @companies = JSON.parse(redis.get('companies')).sort_by { |company| company['marketCap'] }
    end
  end
end
