require 'pinecone'

module FaqServices
  class PineconeSync
    def initialize(faq)
      @faq = faq
    end

    def call
      result = open_ai.embeddings(
        parameters: {
          model: "babbage-similarity",
          input: @faq.question_with_answer
        }
      )

      pinecone.upsert([{
         id: @faq.to_sgid.to_s,
         values: result["data"][0]["embedding"]
      }])
    end

    private

    def open_ai() = OpenAI::Client.new
    def pinecone() = Pinecone.new
  end
end