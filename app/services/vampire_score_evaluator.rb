class VampireScoreEvaluator
  def self.evaluate(years)
    years = years.sort
    youngest, oldest = [years.first, years.last]

    return unless oldest && youngest

    (youngest - oldest)
  end
end
