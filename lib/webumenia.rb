require 'elasticsearch'
require 'curb'

class Webumenia
  def self.get(query, size: 10_000)
    client = Elasticsearch::Client.new(url: ENV['WEBUMENIA_ELASTICSEARCH_URL'])

    response = client.search(
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

    Parser.parse(response)
  end

  class Parser
    def self.parse(response)
      response['hits']['hits'].map { |e| Mapper.map(e['_source']) }
    end
  end

  class Mapper
    def self.map(attributes)
      {
        id: attributes['id'],
        source: 'api.webumenia.sk',
        year: attributes['dating'],
        title: attributes['title'],
        author: attributes['author'],
        url: "http://webumenia.sk/dielo/#{attributes['id']}",
        image_url: Curl.get("http://media.webumenia.sk/#{attributes['id']}").body_str
      }
    end
  end
end
