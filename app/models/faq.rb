class Faq < ApplicationRecord
  validates :question, :answer, presence: true

  def question_with_answer
    "#{self.question} #{self.answer}"
  end
end
