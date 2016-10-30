class SimilarFacesFinder
  def self.for(model)
    vector = NVector[*model]

    matches = DataRepository.all.map { |artwork|
      artwork[:faces].map { |face|
        other = NVector[*face[:model]]

        {
          artwork: artwork,
          face: face,
          match: vector * other
        }
      }
    }.flatten

    matches.sort_by { |e| e[:match] }.first(10).sort_by { |e|
      e[:artwork][:year].to_i
    }.reverse
  end
end
