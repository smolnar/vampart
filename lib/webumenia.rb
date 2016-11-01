require 'elasticsearch'
require 'typhoeus'
require 'typhoeus/adapters/faraday'
require 'curb'

class Webumenia
  def self.get(query, size: 10_000)
    BasicLogger.log('Getting artworks for Webumenia API')

    client = Elasticsearch::Client.new(url: ENV['WEBUMENIA_ELASTICSEARCH_URL'])

    results = client.search(
      index: 'items',
      body: {
        query: {
          bool: {
            must: [
            {
              term: {
                has_image: true
              }
            }
          ],
          should: [
            multi_match: {
              query: query,
              analyzer: :slovencina,
              operator: :or,
              fields: [:title, :author, :description, :topic, :tag, :techinque].map { |e| :"#{e}.stemmed" }
            }
          ],
          minimum_should_match: 1,
        }
      },
      size: size
    })

    artworks = Parser.parse(results)
    downloader = SimpleThreadedDownloader.new

    artworks.each do |artwork|
      downloader.enqueue("http://media.webumenia.sk/#{artwork[:id]}") do |response|
        BasicLogger.log("Downloaded Webumenia Media URL for \"#{artwork[:title]}\" (#{artwork[:id]})")

        artwork[:image_url] = response.body.strip
      end
    end

    downloader.run

    artworks
  end

  class Parser
    def self.parse(json)
      json['hits']['hits'].map { |e| Mapper.map(e['_source']) }
    end
  end

  class Mapper
    def self.map(attributes)
      match = attributes['dating'].match(/\d+/)
      year = match ? match[0].to_i : nil

      {
        id: attributes['id'],
        source: 'api.webumenia.sk',
        dating: attributes['dating'],
        year: year,
        title: attributes['title'],
        author: attributes['author'],
        url: "http://webumenia.sk/dielo/#{attributes['id']}"
      }
    end
  end
end
