class Bet < ApplicationRecord
  include AASM
  belongs_to :item
  belongs_to :user
  has_many :winners
  after_validation :coins_not_enough?
  after_create :assign_serial_number, :deduct_coins

  aasm column: :state do
    state :betting, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :betting, to: :won
    end

    event :lose do
      transitions from: :betting, to: :lost
    end

    event :cancel do
      transitions from: :betting, to: :cancelled, after: :refund_coins
    end
  end

  def assign_serial_number
    number_count = Bet.where(batch_count: item.batch_count, item_id: item.id).count.to_s.rjust(4, '0')
    self.update!(serial_number: "#{Time.current.strftime("%y%m%d")}-#{item.id}-#{item.batch_count}-#{number_count}")
  end

  def deduct_coins
    self.user.update!(coins: self.user.coins - self.coins)
  end

  def refund_coins
    self.user.update!(coins: self.user.coins + self.coins)
  end

  def coins_not_enough?
    if self.user.coins < 1
      errors.add(:base, "You don't have enough coins!")
    end
  end
end
