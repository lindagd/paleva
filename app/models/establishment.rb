class Establishment < ApplicationRecord
  belongs_to :user
  has_many :opening_hours
  
  validates :trade_name, :corporate_name, :registration_number, :city,
            :state, :zip, :address, :phone_number, :email, presence: true
  validates :state, format: { with: /\A[a-zA-Z]+\z/, message: 'deve conter apenas letras' },
                    length: { is: 2 }

  validates :registration_number, uniqueness: true,
                     format: {with: /\A\d+\z/, message: 'deve conter apenas números'}
  validates_format_of :email, with: /\A(?!\.)[\w\-.]*[^\.]@\w+(\.\w+(\.\w+)?)\z/

  validate :registration_number_is_valid

  validates :phone_number, format: {with: /\A\d+\z/, message: 'deve conter apenas números'},
                           length: {minimum: 10, maximum: 11}

  before_create :generate_establishment_code

  def full_address
    "#{address}. #{city} - #{state.upcase}, #{zip}"
  end

  def formatted_phone_number
    "#{phone_number.gsub(/(\d{2})(\d+)(\d{4})/, '(\1) \2-\3')}"
  end

  private
  def generate_establishment_code
    self.code = SecureRandom.alphanumeric(6)
  end

  def registration_number_is_valid
    return if registration_number.blank?

    unless CNPJ.valid?(registration_number)
      errors.add(:registration_number, 'não é válido')
    end
  end
end
