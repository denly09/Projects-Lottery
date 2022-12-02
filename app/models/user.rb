class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  enum role: { client: 0, admin: 1 }
  validates :phone_number, phone: { possible: true, allow_blank: true, types: [:voip, :mobile], countries: :ph }
  mount_uploader :image, ImageUploader

  has_many :addresses
end
