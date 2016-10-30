class VampireScoreEvaluator
  def self.evaluate(years)
    oldest = years.sort.first

    return unless oldest

    score = (Time.now.year - oldest).abs

    return score if score < 100
    return 99.9
  end
end
