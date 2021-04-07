class ApplicationController < ActionController::Base
  helper_method :redis

  def redis
    @redis = Redis.new
  end
end
