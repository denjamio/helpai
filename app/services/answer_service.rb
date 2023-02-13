class AnswerService
  def initialize(search_query:, faq:)
    @search_query = search_query
    @faq = faq
  end

  def call
    return "Lo siento, no lo se" unless @faq

    result = open_ai.completions(
      parameters: {
        prompt: promt,
        temperature: 0,
        max_tokens: 100,
        top_p: 1,
        frequency_penalty: 0,
        presence_penalty: 0,
        model: 'text-davinci-003'
      }
    )

    result["choices"][0]["text"]
  end

  private

  def promt() = "#{veracity}.#{current_date}\nContexto:#{context}\nPregunta:#{question}\nRespuesta: ''"
  def veracity() = "Contesta la pregunta con la mayor vericidad posible,si no estás seguro de la respuesta, responde 'Lo siento, no lo se'"
  def current_date() = "Fecha actual: #{Date.current.strftime("%d/%m/%Y")}, solo se usa si la Pregunta incluye alguna referencia temporal."
  def context() = "#{@faq.question_with_answer}."
  def question() = @search_query
  def open_ai() = OpenAI::Client.new
end