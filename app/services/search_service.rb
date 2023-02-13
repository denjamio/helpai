require 'pinecone'

class SearchService
  def initialize(query, answer_service = AnswerService)
    @query = query
    @answer_service = answer_service
  end

  def call
    return "" unless @query.present?
    open_ai_result = open_ai.embeddings(
      parameters: {
        model: "babbage-similarity",
        input: @query
      }
    )

    pinecone_result = pinecone.query(open_ai_result["data"][0]["embedding"])
    faq_id = pinecone_result["matches"][0]["id"]
    faq = GlobalID::Locator.locate_signed faq_id

    @answer_service.new(search_query: @query, faq: faq).call
  end

  private

  def open_ai() = OpenAI::Client.new
  def pinecone() = Pinecone.new
end