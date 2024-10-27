require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    context 'social security number (cpf)' do
      it 'must only contain numbers' do
        user = User.new(social_security_number: '706a1b55n92090')

        user.valid?

        expect(user.errors.include? :social_security_number).to be true
        expect(user.errors[:social_security_number]).to include 'deve conter apenas números'
      end
      
      it 'must be valid number' do
        user = User.new(name: 'Norma', surname: 'Blum', social_security_number: '12233445566',
                            email: 'norma@email.com', password: 'dummy-password')
  
        expect(user.valid?).to eq false
        expect(user.errors.include? :social_security_number).to be true
        expect(user.errors[:social_security_number]).to include 'deve ser válido'
      end
    end
    
    context 'e-mail' do
      it 'must not be blank' do
        user = User.new(name: 'Norma', surname: 'Blum', social_security_number: '70615592090',
                      email: '', password: 'dummy-password')
        
        expect(user).to be_invalid
        expect(user.errors.include? :email).to be true
      end

      it "must not have dots right before '@'" do
        user = User.new(name: 'Norma', surname: 'Blum', social_security_number: '70615592090',
                               email: 'norma.@com', password: 'dummy-password')
        
        expect(user).to be_invalid
        expect(user.errors.include? :email).to be true
        expect(user.errors[:email]).to include 'não é válido'
      end

      it "must not have dots right after '@'" do
        user = User.new(name: 'Norma', surname: 'Blum', social_security_number: '70615592090',
                               email: 'norma@.com.br', password: 'dummy-password')
        
        expect(user.valid?).to be false
        expect(user.errors.include? :email).to be true
        expect(user.errors[:email]).to include 'não é válido'
      end

      it 'must have top-level domain' do
        user = User.new(name: 'Norma', surname: 'Blum', social_security_number: '70615592090',
                      email: 'norma@com', password: 'dummy-password')
      
        expect(user.valid?).to be false
        expect(user.errors.include? :email).to be true
        expect(user.errors[:email]).to include 'não é válido'
      end
    end

    context 'name and surname' do
      it 'must be present' do
        user = User.new(name: '', surname: '')
    
        user.valid?
    
        expect(user.errors.include? :name).to be true
        expect(user.errors.include? :surname).to be true
        expect(user.errors[:name]).to include 'não pode ficar em branco'
        expect(user.errors[:surname]).to include 'não pode ficar em branco'
      end
    end

    context 'password' do
      it 'must be longer than 12 characters' do
        user = User.new(password: 'p'*11)
  
        user.valid?
  
        expect(user.errors.include? :password).to be true
        expect(user.errors[:password]).to include 'é muito curto (mínimo: 12 caracteres)'
      end
    end
  end

  describe 'is registered as establishment owner' do
    before do
      Role.create!(description: 'Dono de estabelecimento')
    end

    it 'after signing up' do
      user = User.create!(name: 'Norma', surname: 'Blum', email: 'norma@mail.com',
                          social_security_number: CPF.generate, password: 'password1234')
      
      expect(user.role_id).not_to be nil
      expect(user.role.description).to eq 'Dono de estabelecimento'
    end
  end

  describe '#full_name' do
    it 'displays name and surname' do
      user = User.new(name: 'Gal', surname: 'Costa')

      expect(user.full_name).to eq 'Gal Costa'
    end    
  end
  
end
