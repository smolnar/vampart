class Nasjonalmuseet
  def self.get(query)
    url = "https://snl.no/api/v1/search?query=#{query}&limit=10&offset=0"
    offset = 0
    results = Array.new

    loop do
      data = Parser.parse(Curl.get(url).body_str)

      break if data.empty?

      results += data
      url.gsub!(/offset=\d+/, "offset=#{(offset += 1) * 10}")
    end

    results.select { |e| e[:image_url].present? }
  end

  class Parser
    def self.parse(content)
      JSON.parse(content).map do |attributes|
        {
          id: attributes['article_id'],
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
