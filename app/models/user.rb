class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :role, optional: true

  validates :name, :surname, :social_security_number, presence: true
  validates :social_security_number, uniqueness: true,
                     format: {with: /\A\d+\z/, message: 'deve conter apenas números'}
  validate :social_security_number_is_valid

  before_create :set_default_role

  private
  def social_security_number_is_valid
    return if social_security_number.blank?

    unless CPF.valid?(social_security_number)
      errors.add(:social_security_number, 'deve ser válido')
    end
  end

  def set_default_role
    self.role = Role.find_by(description: 'Dono de estabelecimento')
  end
end
