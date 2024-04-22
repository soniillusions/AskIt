class Question < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 2 }

  has_many :answers, dependent: :destroy

  def formatted_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
