require 'rails_helper'

describe 'User registers establishment' do
  it 'only if authenticated' do
    visit new_establishment_path

    expect(current_path).to eq new_user_session_path
  end

  it 'after authentication' do
    user = User.create!(name: 'Norma', surname: 'Blum', social_security_number: CPF.generate,
                        email: 'norma@email.com', password: 'password1234')

    login_as(user)
    visit root_path

    expect(current_path).to eq new_establishment_path
    expect(page).to have_content 'Cadastrar Estabelecimento'
    expect(page).to have_field('Nome Fantasia')
    expect(page).to have_field('Razão Social')
    expect(page).to have_field('CNPJ')
    expect(page).to have_field('Cidade')
    expect(page).to have_field('Estado')
    expect(page).to have_field('CEP')
    expect(page).to have_field('Endereço')
    expect(page).to have_field('Telefone')
    expect(page).to have_field('E-mail')
    expect(page).to have_button('Cadastrar')
  end

  it 'successfully' do
    user = User.create!(name: 'Norma', surname: 'Blum', social_security_number: CPF.generate,
                        email: 'norma@email.com', password: 'password1234')

    login_as(user)
    visit root_path
    fill_in 'Nome Fantasia',	with: 'Café Passado Bistrô' 
    fill_in 'Razão Social',	with: 'Café Passado & Cia LTDA' 
    fill_in 'CNPJ',	with: '05244627000101'
    fill_in 'Cidade', with: 'Salvador'
    fill_in 'Estado', with: 'BA'
    fill_in 'CEP', with: '49505-433'
    fill_in 'Endereço', with: 'Rua Laranjeiras, 415'
    fill_in 'Telefone', with: '73999854320'
    fill_in 'E-mail', with: 'adm@cafepassado.com.br'
    click_on 'Cadastrar'

    expect(page).to have_content 'Estabelecimento registrado com sucesso'
    expect(page).to have_content 'Café Passado Bistrô'
  end

  it 'with blank fields' do
    user = User.create!(name: 'Norma', surname: 'Blum', social_security_number: CPF.generate,
                        email: 'norma@email.com', password: 'password1234')

    login_as(user)
    visit root_path
    fill_in 'Nome Fantasia',	with: '' 
    fill_in 'Razão Social',	with: '' 
    fill_in 'CNPJ',	with: ''
    click_on 'Cadastrar'

    expect(page).to have_content 'Não foi possível cadastrar o estabelecimento'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'CEP não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
  end

  it 'with invalid fields' do
    user = User.create!(name: 'Norma', surname: 'Blum', social_security_number: CPF.generate,
                        email: 'norma@email.com', password: 'password1234')

    login_as user
    visit root_path
    fill_in 'Nome Fantasia',	with: 'Café Passado Bistrô' 
    fill_in 'Razão Social',	with: 'Café Passado & Cia LTDA' 
    fill_in 'CNPJ',	with: '1928bb'
    fill_in 'Cidade', with: 'Salvador'
    fill_in 'Estado', with: 'Bahia'
    fill_in 'CEP', with: '49505-433'
    fill_in 'Endereço', with: 'Rua Laranjeiras, 415'
    fill_in 'Telefone', with: '3675-1819'
    fill_in 'E-mail', with: 'adm.@cafepassado.com.br'
    click_on 'Cadastrar'

    expect(page).to have_content 'Não foi possível cadastrar o estabelecimento'
    expect(page).to have_content 'CNPJ não é válido'
    expect(page).to have_content 'CNPJ deve conter apenas números'
    expect(page).to have_content 'Estado não possui o tamanho esperado (2 caracteres)'
    expect(page).to have_content 'Telefone deve conter apenas números'
    expect(page).to have_content 'Telefone é muito curto (mínimo: 10 caracteres)'
    expect(page).to have_content 'E-mail não é válido'
  end

  it 'only if it wasn`t registered already' do
    user = User.create!(name: 'Norma', surname: 'Blum', social_security_number: CPF.generate,
                        email: 'norma@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'Forneria Pizzaria', registration_number: CNPJ.generate,
                          corporate_name: 'Forneria Pizzas & Cia LTDA', city: 'João Pessoa',
                          state: 'PB', zip: '58045-090', address: 'Av. Cabo Branco, 1706',
                          phone_number: '64999807654', email: 'contato@forneriapizzas.com.br',
                          user: user)

    login_as user
    visit root_path
    visit new_establishment_path

    expect(page).to have_content 'Usuário já possui um estabelecimento cadastrado'
    expect(page).to have_content 'Ver estabelecimento cadastrado: Forneria Pizzaria'
    expect(page).not_to have_field 'Nome Fantasia'
    expect(page).not_to have_field 'Razão Social'
    expect(page).not_to have_field 'CNPJ'
    expect(page).not_to have_button 'Cadastrar'
  end
end