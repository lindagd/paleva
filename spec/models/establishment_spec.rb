require 'rails_helper'

RSpec.describe Establishment, type: :model do
  describe '#valid?' do
    it 'must have a trade name' do
      user = User.create!(name: 'Norma', surname: 'Blum', social_security_number: CPF.generate,
                          email: 'norma@email.com', password: 'password1234')
      establishment = Establishment.new(trade_name: '', registration_number: CNPJ.generate,
                                    corporate_name: 'Forneria Pizzas & Cia LTDA', city: 'João Pessoa',
                                    state: 'PB', zip: '58045-090', address: 'Av. Cabo Branco, 1706',
                                    phone_number: '64999807654', email: 'contato@forneriapizzas.com.br',
                                    user: user)
      
      expect(establishment.valid?).to eq false
      expect(establishment.errors.include? :trade_name).to eq true
    end

    it 'must have a corporate name' do
      establishment = Establishment.new(corporate_name: '')

      expect(establishment.valid?).to eq false
      expect(establishment.errors.include? :corporate_name).to eq true
      expect(establishment.errors[:corporate_name]).to include 'não pode ficar em branco'
    end

    it 'must have a city' do
      establishment = Establishment.new(city: '')

      expect(establishment.valid?).to eq false
      expect(establishment.errors[:city]).to include 'não pode ficar em branco' 
    end

    it 'must have a zip code' do
      establishment = Establishment.new(zip: '')

      expect(establishment.valid?).to eq false
      expect(establishment.errors[:zip]).to include 'não pode ficar em branco' 
    end

    it 'must have an address' do
      establishment = Establishment.new(address: '')

      establishment.valid?

      expect(establishment.errors.include? :address).to be true
      expect(establishment.errors[:address]).to include 'não pode ficar em branco'
    end

    context 'state' do
      it 'should not be blank' do
        establishment = Establishment.new(state: '')

        establishment.valid?

        expect(establishment.errors.include? :state).to be true
        expect(establishment.errors[:state]).to include 'não pode ficar em branco'
      end

      it 'should only contain letters' do
        establishment = Establishment.new(state: 'SP3')

        establishment.valid?

        expect(establishment.errors.include? :state).to be true
        expect(establishment.errors[:state]).to include 'deve conter apenas letras'
      end

      it 'must have lenght of 2' do
        establishment = Establishment.new(state: 'SPP')

        establishment.valid?

        expect(establishment.errors[:state]).to include 'não possui o tamanho esperado (2 caracteres)'
      end
    end

    context 'e-mail' do
      it 'should not be blank' do
        establishment = Establishment.new(email: '')

        expect(establishment.valid?).to be false
        expect(establishment.errors.include? :email).to be true
      end

      it "must not have dots right before '@'" do
        establishment = Establishment.new(email: 'norma.@com')
        
        expect(establishment).to be_invalid
        expect(establishment.errors.include? :email).to be true
        expect(establishment.errors[:email]).to include 'não é válido'
      end

      it "must not have dots right after '@'" do
        establishment = Establishment.new(email: 'norma@.com.br')
        
        establishment.valid?

        expect(establishment.errors.include? :email).to be true
        expect(establishment.errors[:email]).to include 'não é válido'
      end

      it 'must have top-level domain' do
        establishment = Establishment.new(email: 'norma@com')
      
        expect(establishment.valid?).to be false
        expect(establishment.errors.include? :email).to be true
        expect(establishment.errors[:email]).to include 'não é válido'
      end
    end

    context 'registration number (cnpj)' do
      it 'must only contain numbers' do
        establishment = Establishment.new(registration_number: '706a1b55n92090')

        establishment.valid?

        expect(establishment.errors.include? :registration_number).to be true
        expect(establishment.errors[:registration_number]).to include 'deve conter apenas números'
      end
      
      it 'must be unique' do
        User.create!(name: 'Norma', surname: 'Blum', social_security_number: CPF.generate,
                     email: 'norma@email.com', password: 'password1234')
        Establishment.create!(trade_name: 'Forneria Pizzaria', registration_number: '73420022000184',
                  corporate_name: 'Forneria Pizzas & Cia LTDA', city: 'João Pessoa',
                  state: 'PB', zip: '58045-090', address: 'Av. Cabo Branco, 1706',
                  phone_number: '64999807654', email: 'contato@forneriapizzas.com.br',
                  user: User.last)
        other_establishment = Establishment.new(registration_number: '73420022000184')

        other_establishment.valid?

        expect(other_establishment).not_to be_valid
        expect(other_establishment.errors.include? :registration_number).to be true
        expect(other_establishment.errors[:registration_number]).to include 'já está em uso'
      end

      it 'must be valid cnpj' do
        establishment = Establishment.new(registration_number: '1232133243212')

        establishment.valid?

        expect(establishment.errors.include? :registration_number).to be true
        expect(establishment.errors[:registration_number]).to include 'não é válido'
      end
    end
    
    context 'phone_number' do
      it 'must only contain numbers' do
        establishment = Establishment.new(phone_number: '9997865-2030')

        establishment.valid?

        expect(establishment.errors.include? :phone_number).to be true
        expect(establishment.errors[:phone_number]).to include 'deve conter apenas números'
      end

      it 'must have at least 10 characters' do
        establishment = Establishment.new(phone_number: '9'*9)

        establishment.valid?

        expect(establishment.errors.include? :phone_number).to be true
        expect(establishment.errors[:phone_number]).to include 'é muito curto (mínimo: 10 caracteres)'
      end
      
      it 'must have a maximum of 11 characters' do
        establishment = Establishment.new(phone_number: '9'*12)

        establishment.valid?

        expect(establishment.errors.include? :phone_number).to be true
        expect(establishment.errors[:phone_number]).to include 'é muito longo (máximo: 11 caracteres)'
      end
    end
    
    it 'must reference an user as owner' do
      establishment = Establishment.new(user: nil)

      establishment.valid?

      expect(establishment.errors.include? :user).to be true
      expect(establishment.errors[:user]).to include 'é obrigatório(a)'
    end
  end

  describe 'generates random code' do
    it 'once it is registered' do
      user = User.create!(name: 'Norma', surname: 'Blum', social_security_number: CPF.generate,
                          email: 'norma@email.com', password: 'password1234')
      establishment = Establishment.new(trade_name: 'Forneria Pizzaria', registration_number: CNPJ.generate,
                                    corporate_name: 'Forneria Pizzas & Cia LTDA', city: 'João Pessoa',
                                    state: 'PB', zip: '58045-090', address: 'Av. Cabo Branco, 1706',
                                    phone_number: '64999807654', email: 'contato@forneriapizzas.com.br',
                                    user: user)
      
      establishment.save!
      
      expect(establishment.code).not_to be_nil
      expect(establishment.code.length).to eq 6
    end

    it 'and it must be unique' do
      user = User.create!(name: 'Norma', surname: 'Blum', social_security_number: CPF.generate,
                          email: 'norma@email.com', password: 'password1234')
      establishment = Establishment.new(trade_name: 'Forneria Pizzaria', registration_number: CNPJ.generate,
                                    corporate_name: 'Forneria Pizzas & Cia LTDA', city: 'João Pessoa',
                                    state: 'PB', zip: '58045-090', address: 'Av. Cabo Branco, 1706',
                                    phone_number: '64999807654', email: 'contato@forneriapizzas.com.br',
                                    user: user)
      other_establishment = Establishment.new(trade_name: 'Forneria Pizzaria', registration_number: CNPJ.generate,
                                    corporate_name: 'Forneria Pizzas & Cia LTDA', city: 'João Pessoa',
                                    state: 'PB', zip: '58045-090', address: 'Av. Cabo Branco, 1706',
                                    phone_number: '64999807654', email: 'contato@forneriapizzas.com.br',
                                    user: user)
      
      other_establishment.save!

      expect(other_establishment.code).not_to eq establishment.code 
    end
  end

  describe '#full_address' do
    it 'displays address, city, state and zip' do
      establishment = Establishment.new(city: 'Guarulhos', state: 'SP',
                                        zip: '79805-766', address: 'Av. Aeroporto, 500')

      expect(establishment.full_address).to eq 'Av. Aeroporto, 500. Guarulhos - SP, 79805-766' 
    end
  end

  describe '#formatted_phone_number' do
    context 'displays phone number with mask' do
        it 'in 10 digits number' do
          establishment = Establishment.new(phone_number: '1187640255')

          expect(establishment.formatted_phone_number).to eq '(11) 8764-0255'
        end

        it 'in 11 digits number' do
          establishment = Establishment.new(phone_number: '11987640255')

          expect(establishment.formatted_phone_number).to eq '(11) 98764-0255'
        end
    end
  end
end
