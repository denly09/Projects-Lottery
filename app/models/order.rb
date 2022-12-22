class Order < ApplicationRecord
  include AASM
  belongs_to :user
  belongs_to :offer
  after_create :assign_serial_number

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:pending, :submitted], to: :cancelled
      transitions from: :paid, to: :cancelled, after: [:cancel_deduction, :decrease_total_deposit], guard: :enough_coins
    end

    event :pay do
      transitions from: :submitted, to: :paid, after: [:deduct_pay, :increase_total_deposit]
    end
  end

  def deduction_pay
    if deduct?
      self.user.update(coins: self.user.coins + coins)
    else
      self.user.update(coins: self.user.coins - coins)
    end
  end

  def cancel_deduction
    if deduct?
      self.user.update(coins: self.user.coins + self.coins)
    else
      self.user.update(coins: self.user.coins - self.coins)
    end
  end

  def decrease_total_deposit
    if deposit?
      self.user.update(total_deposit: self.user.total_deposit - self.amount)
    end
  end

  def increase_total_deposit
    if deposit?
      self.user.update(total_deposit: self.user.total_deposit + self.amount)
    end
  end

  def assign_serial_number
    number_count = Order.where(user_id: user.id).count.to_s.rjust(4, '0')
    self.update!(serial_number: "#{Time.current.strftime("%y%m%d")}-#{order.id}-#{user.id}-#{number_count}")
  end

  def enough_coins?
    self.user.coins >= coins
  end

  def enough_total_deposit?
    if deposit?
      amount >= 1
    end
  end
end
