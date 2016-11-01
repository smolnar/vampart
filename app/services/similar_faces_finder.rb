class SimilarFacesFinder
  def self.for(model)
    vector = NVector[*model]

    matches = DataRepository.all.map { |artwork|
      artwork[:faces].map { |face|
        other = NVector[*face[:model]]
        similarity = ModelComparator.compare(vector, other)

        next if similarity >= 1.0

        {
          artwork: artwork,
          face: face,
          similarity: ModelComparator.compare(vector, other)
        }
      }
    }.flatten.compact.sort_by { |e| e[:similarity] }

    matches.first(10).sort_by { |e|
      e[:artwork][:year].to_i
    }.reverse
  end

  class ModelComparator
    def self.compare(a, b)
      difference = b - a

      difference * difference
    end
  end
end
