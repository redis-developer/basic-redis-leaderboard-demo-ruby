class CompanyQuery
  def initialize(redis, companies, params)
    @params = params
    @redis = redis
    @companies = companies
  end

  def call
    JSON.parse(sort)
  end

  private

  def sort
    case @params[:sort]
    when 'top10'
      @redis.set('top10', add_rank(@companies.reverse.first(10), 1, 'plus'))
    when 'all'
      @redis.set('all', add_rank(@companies.reverse, 1, 'plus'))
    when 'bottom10'
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
      @redis.set('between_rank', add_rank(select_by_range(9, 14), 10, 'plus'))
    when 'inRank'
      companies = select_by_range(@params[:start], @params[:end])
      @redis.set('inRank', add_rank(companies, (@params[:end].to_i - 9), 'plus'))
    else
      @companies
    end
    @redis.get(@params[:sort])
  end

  def select_by_range(start_range, end_range)
    @companies.reverse.select.with_index { |_c, i| i.between?(start_range.to_i, end_range.to_i) }
  end

  def add_rank(collection, value, operator)
    if operator.nil?
      collection.each.with_index { |c, _i| c[:rank] = nil }.to_json
    else
      collection.each.with_index do |c, i|
        c[:rank] = operator == 'plus' ? (c[:rank] = value + i) : (c[:rank] = value - i)
      end.to_json
    end
  end
end
