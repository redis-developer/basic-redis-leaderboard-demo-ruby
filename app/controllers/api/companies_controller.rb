module Api
  class CompaniesController < ApplicationController
    before_action :set_companies

    def index
      render json: CompanyQuery.new(redis, @companies, params).call, status: :ok
    end

    def update
      company = COMPANIES.select { |c| c[:symbol] == params[:symbol] }[0]
      company[:marketCap] += params[:amount].to_i
      render json: COMPANIES, status: :ok
    end

    private

    def set_companies
      redis.set('companies', COMPANIES.sort_by { |company| company[:marketCap] }.to_json)
      @companies = JSON.parse(redis.get('companies'))
    end
  end
end
