class CompanyQuery
  def initialize(params)
    @params = params
    @companies = COMPANIES.sort_by { |company| company[:marketCap] }
  end

  def call
    sort
  end

  private

  def sort
    case @params[:sort]
    when 'top10'
      add_rank(@companies.reverse.first(10), 1, 'plus')
    when 'all'
      @companies.reverse
      add_rank(@companies.reverse, 1, 'plus')
    when 'bottom10'
      add_rank(@companies.first(10), 10, 'minus')
    when 'symbols'
      companies = @companies.select do |c|
        @params[:values].tr('[]', '')
                        .split(', ')
                        .map(&:upcase)
                        .include?(c[:symbol])
      end
      add_rank(companies.first(10), nil, nil)
    when 'between_rank'
      add_rank(select_by_range(9, 14), 10, 'plus')
    when 'inRank'
      companies = select_by_range(@params[:start], @params[:end])
      add_rank(companies, (@params[:end].to_i - 9), 'plus')
    else
      @companies
    end
  end

  def select_by_range(start_range, end_range)
    @companies.reverse.select.with_index { |_c, i| i.between?(start_range.to_i, end_range.to_i) }
  end

  def add_rank(collection, value, operator)
    if operator.nil?
      collection.each.with_index { |c, _i| c[:rank] = nil }
    else
      collection.each.with_index do |c, i|
        c[:rank] = operator == 'plus' ? (c[:rank] = value + i) : (c[:rank] = value - i)
      end
    end
  end
end
