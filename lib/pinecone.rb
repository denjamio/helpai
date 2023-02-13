class Pinecone
  include HTTParty

  def initialize(index_url: ENV.fetch('PINECONE_INDEX_URL'), api_key: ENV.fetch('PINECONE_API_KEY'))
    @index_url = index_url
    @options   = {headers: {'Content-Type': 'application/json', 'Api-Key': api_key}}
  end

  def upsert(vectors)
    body = {
      vectors: vectors
    }.to_json

    self.class.post("#{@index_url}/vectors/upsert", @options.merge({body: body}))
  end

  def query(vector)
    body = {
      includeValues: true,
      includeMetadata: true,
      topK: 3,
      vector: vector
    }.to_json

    response = self.class.post("#{@index_url}/query", @options.merge({body: body}))
    response.parsed_response
  end
end