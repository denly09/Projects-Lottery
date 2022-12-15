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

  def destroy
    update(deleted_at: Time.current)
  end

  has_many :categories
  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

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
      transitions from: :starting, to: :ended
    end

    event :cancel do
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

end
