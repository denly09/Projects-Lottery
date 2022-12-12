class User < ApplicationRecord
  belongs_to :parent, class_name: "User", optional: true , counter_cache: :children_members
  has_many :children, class_name: "User", foreign_key: 'parent_id'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable



  enum role: { client: 0, admin: 1 }
  validates :phone_number, phone: { possible: true, allow_blank: true, types: [:voip, :mobile], countries: :ph }, length: { maximum: 13 }
  mount_uploader :image, ImageUploader

  has_many :addresses




end
