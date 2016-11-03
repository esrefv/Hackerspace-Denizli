class User < ActiveRecord::Base
  # Virtual attributes
  attr_accessor :is_generated_password

  # Scopes
  scope :active, -> { where(is_active: true) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :async,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  #\b[1-9][0-9]{2}[1,3,5,7,9]\b -- tam olarak 4 basamaklı tek sayıları bulan regex \bdhs[1-9][0-9]{2}[1,3,5,7,9]\b
  # Relations
  has_many :answers
  belongs_to :card
  # Helpers
  audited except: [:password]

  # Validations
  validates_presence_of :name, :email, :surname
  validates :email, uniqueness: true
  validates :cardnumber, length: {is: 7}, uniqueness: true, include_blank: false,
            format: {with: /\bdhs[1-9][0-9]{2}[1,3,5,7,9]\b/, message: "Uyumsuz kart numarası. Örnek: dhs0001, dhs0007"}

  validate :check_cardnumber
  # Callbacks
  after_commit :send_login_info, on: :create
  before_validation :create_password, on: :create
  after_initialize do |obj|
    obj.is_generated_password = false
  end

  def active_for_authentication?
    super && self.is_active
  end

  def full_name
    "#{self.name} #{self.surname}"
  end

  private

  def create_password
    if self.password.nil?
      password                    = Devise.friendly_token.first(8)
      self.password               = password
      self.password_confirmation  = password
      self.is_generated_password  = true
    end
  end

  def check_cardnumber
    c = Card.new
    c = Card.find_by card_number: self.cardnumber
    unless c.nil?
      self.card_id = c.id
    else
      errors.add(:cardnumber, "Böyle bir kart bulunmamaktadır.")
    end
  end

  def send_login_info
    UserMailer.login_info(self.id, self.password).deliver_later! if self.is_generated_password
  end

end
