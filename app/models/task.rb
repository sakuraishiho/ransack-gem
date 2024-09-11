class Task < ApplicationRecord
  enum status: { todo: 0, doing: 1, done: 2 }
  validates :title, presence: true
  validates :status, presence: true
  validates :deadline, presence: true
  # validate :deadline, :must_start_from_today

  # def must_start_from_today
  #   errors.add(:deadline, 'must start from today.') if deadline.present? && deadline < Date.current
  # end

  # 検索可能な属性を明示的に指定
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "deadline", "description", "id", "status", "title", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    []  # 'task' という関連モデルを検索対象に含める
  end

  scope :within_date_range, ->(start_date, end_date) {
    if start_date.present? && end_date.present?
      where(deadline: start_date..end_date)
    elsif start_date.present?
      where('deadline >= ?', start_date)
    elsif end_date.present?
      where('deadline <= ?', end_date)
    else
      all
    end
  }
end
