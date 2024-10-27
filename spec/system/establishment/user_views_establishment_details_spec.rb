require 'rails_helper'

describe 'User views establishment details' do
  it 'if authenticated' do
    visit establishment_path(1)

    expect(current_path).to eq new_user_session_path 
  end

  it 'if establishment is registered' do
    user = User.create!(name: 'Norma', surname: 'Blum', social_security_number: CPF.generate,
                        email: 'norma@email.com', password: 'password1234')

    login_as(user)
    visit establishment_path(1)
    
    expect(current_path).to eq new_establishment_path
  end

  it 'successfully' do
    user = User.create!(name: 'Norma', surname: 'Blum', social_security_number: CPF.generate,
                        email: 'norma@email.com', password: 'password1234')
    establishment = Establishment.create!(trade_name: 'Forneria Pizzaria', registration_number: CNPJ.generate,
                                    corporate_name: 'Forneria Pizzas & Cia LTDA', city: 'João Pessoa',
                                    state: 'PB', zip: '58045-090', address: 'Av. Cabo Branco, 1706',
                                    phone_number: '64999807654', email: 'contato@forneriapizzas.com.br',
                                    user: user)
    
    login_as user
    visit root_path
    click_on 'Forneria Pizzaria: Detalhes'

    expect(page).to have_content 'Forneria Pizzaria'
    expect(page).to have_content "CNPJ: #{establishment.registration_number}"
    expect(page).to have_content "Razão Social: #{establishment.corporate_name}"
    expect(page).to have_content "Endereço: #{establishment.full_address}"
    expect(page).to have_content "Telefone: (64) 99980-7654"
    expect(page).to have_content "E-mail: contato@forneriapizzas.com.br"
    expect(page).to have_content "Proprietário(a): Norma Blum"
  end

  it 'but only its own establishments' do
    user1 = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                          registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                          address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user1)
    user2 = User.create!(name: 'Norma', surname: 'Blum', social_security_number: CPF.generate,
                        email: 'norma@email.com', password: 'password1234')
    establishment2 = Establishment.create!(trade_name: 'Forneria Pizzaria', registration_number: CNPJ.generate,
                                    corporate_name: 'Forneria Pizzas & Cia LTDA', city: 'João Pessoa',
                                    state: 'PB', zip: '58045-090', address: 'Av. Cabo Branco, 1706',
                                    phone_number: '64999807654', email: 'contato@forneriapizzas.com.br',
                                    user: user2)

    login_as user1
    visit establishment_path(establishment2.id)

    expect(current_path).not_to eq establishment_path(establishment2.id)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Acesso não autorizado'
  end
end
