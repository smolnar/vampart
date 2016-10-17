class Nasjonalmuseet
  def self.get(query, size: 10_000)
    url = "https://snl.no/api/v1/search?query=#{query}&limit=10&offset=0"
    offset = 0
    results = Array.new

    loop do
      data = Parser.parse(Curl.get(url).body_str)

      break if data.empty? || (offset * 10) >= size

      results += data
      url.gsub!(/offset=\d+/, "offset=#{(offset += 1) * 10}")
    end

    results.select { |e| e[:image_url].present? }
  end

  class Parser
    def self.parse(content)
      JSON.parse(content).map do |attributes|
        {
          id: attributes['article_id'].to_s,
          source: 'nkl.snl.no/api/v1',
          title: attributes['title'],
          year: nil, # TODO what to do?
          url: attributes['article_url'],
          image_url: attributes['first_image_url']
        }
      end
    end
  end
end
