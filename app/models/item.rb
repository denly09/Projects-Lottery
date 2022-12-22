class Item < ApplicationRecord
  include AASM
  default_scope { where(deleted_at: nil) }
  validates :image, presence: true
  validates :name, presence: true
  validates :minimum_bets, presence: true
  validates :online_at, presence: true
  validates :start_at, presence: true
  validates :status, presence: true

  mount_uploader :image, ImageUploader

  enum status: { inactive: 0, active: 1 }

  has_many :categories
  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
  has_many :bets
  has_many :winners

  def destroy
    unless bets.present?
      update(deleted_at: Time.current)
      flash[:notice] = "Cannot Delete"
    end
  end

  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :cancelled, :ended], to: :starting, after: :total_batch, guard: [:quantity_not_negative?, :offline?, :active?]
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended, after: :select_winner, guard: :min_bets
    end

    event :cancel, after: [:bet_cancel, :return_quantity] do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  def total_batch
    self.update!(batch_count: self.batch_count + 1, quantity: self.quantity - 1)
  end

  def quantity_not_negative?
    quantity >= 0
  end

  def offline?
    offline_at > Time.current
  end

  def bet_cancel
    bets.where(batch_count: batch_count).where.not(state: :cancelled).each{|bet| bet.cancel!}
  end

  def return_quantity
    self.update!(quantity: self.quantity + 1 )
  end

  def min_bets
    bets.where(batch_count: batch_count).count >= self.minimum_bets
  end

  def  select_winner
    select_bet = self.bets.where(batch_count: batch_count).all
    winner = select_bet.sample
    winner.win!
    select_bet.where.not(id: winner.id).update(state: :lost)
    lucky_winner = Winner.new(item_batch_count: winner.batch_count, user: winner.user, item: winner.item, bet: winner)
    lucky_winner.save!
  end
end
