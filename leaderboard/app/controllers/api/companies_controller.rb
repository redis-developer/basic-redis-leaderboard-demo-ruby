module Api
  class CompaniesController < ApplicationController
    def index
      render json: CompanyQuery.new(params).call, status: :ok
    end

    def update
      company = COMPANIES.select { |c| c[:symbol] == params[:symbol] }[0]
      company[:marketCap] += params[:amount].to_i
      render json: COMPANIES, status: :ok
    end
  end
end
