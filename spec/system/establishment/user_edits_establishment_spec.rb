require 'rails_helper'

describe 'User edits establishment' do
  it 'coming from the homepage' do
    user = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                          registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                          address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user)

    login_as user
    visit root_path
    click_on 'The Bear: Detalhes'
    click_on 'Editar Estabelecimento'
    
    expect(page).to have_content 'Editar informações de The Bear'
    expect(page).to have_field('Nome Fantasia', with: 'The Bear')
    expect(page).to have_field('Razão Social', with: 'The Bear Restaurant LTDA')
    expect(page).to have_field('CNPJ', with: user.establishment.registration_number)
    expect(page).to have_field('Cidade', with: 'São Paulo')
    expect(page).to have_field('Estado', with: 'SP')
    expect(page).to have_field('CEP', with: '01306-001')
    expect(page).to have_field('Endereço', with: 'Rua Avanhandava, 90')
    expect(page).to have_field('Telefone', with: '11989665480')
    expect(page).to have_field('E-mail', with: 'contato@thebear.com.br')
    expect(page).to have_button('Salvar')
  end

  it 'successfully' do
    user = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                          registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                          address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user)

    login_as user
    visit root_path
    click_on 'The Bear: Detalhes'
    click_on 'Editar Estabelecimento'
    fill_in 'Telefone', with: '73999854320'
    click_on 'Salvar'

    expect(page).to have_content 'Estabelecimento atualizado com sucesso'
    expect(page).to have_content 'Telefone: (73) 99985-4320'
    expect(page).not_to have_content 'Telefone: (11) 98966-5480'
  end

  it "but only its own establishment" do
    user1 = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    user2 = User.create!(name: 'Norma', surname: 'Blum', social_security_number: CPF.generate,
                        email: 'norma@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                          registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                          address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user2)
    establishment = Establishment.create!(trade_name: 'Forneria Pizzaria', registration_number: CNPJ.generate,
                                    corporate_name: 'Forneria Pizzas & Cia LTDA', city: 'João Pessoa',
                                    state: 'PB', zip: '58045-090', address: 'Av. Cabo Branco, 1706',
                                    phone_number: '64999807654', email: 'contato@forneriapizzas.com.br',
                                    user: user1)
    
    login_as user2
    visit edit_establishment_path(establishment.id)

    expect(current_path).not_to eq edit_establishment_path(establishment.id)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Acesso não autorizado'
  end
end