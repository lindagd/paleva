require 'rails_helper'

describe 'User signs up' do
  it 'successfully' do
    visit root_path
    click_on 'Criar conta'
    within('form') do
      fill_in 'Nome', with: 'Norma'
      fill_in 'Sobrenome', with: 'Blum'
      fill_in 'CPF', with: '70615592090'
      fill_in 'E-mail', with: 'norma@email.com'
      fill_in 'Senha', with: 'password1234'
      fill_in 'Confirme sua senha', with: 'password1234'
      click_on 'Criar conta'
    end

    expect(page).to have_content 'Boas vindas! Cadastre seu estabelecimento antes de continuar.'
    within('nav') do
      expect(page).to have_button 'Sair'
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_content 'Norma Blum' 
    end 
  end

  it 'with blank fields' do
    visit root_path
    click_on 'Criar conta'
    within('form') do
      fill_in 'Nome', with: ''
      fill_in 'Sobrenome', with: ''
      click_on 'Criar conta'
    end

    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Sobrenome não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
  end

  it 'with already registered social security number (CPF)' do
    User.create!(name: 'Norma', surname: 'Blum', social_security_number: '70615592090',
                 email: 'norma@email.com', password: 'password1234')

    visit root_path
    click_on 'Criar conta'
    within('form') do
      fill_in 'Nome', with: 'Adriana'
      fill_in 'Sobrenome', with: 'Esteves'
      fill_in 'CPF', with: '70615592090'
      fill_in 'E-mail', with: 'adriana_esteves@email.com'
      fill_in 'Senha', with: 'password1234'
      fill_in 'Confirme sua senha', with: 'password1234'
      click_on 'Criar conta'
    end

    expect(page).to have_content 'Não foi possível salvar usuário'
    expect(page).to have_content 'CPF já está em uso'
    expect(current_path).to eq user_registration_path
  end

  it 'with a too short password' do
    visit root_path
    click_on 'Criar conta'
    within('form') do
      fill_in 'Nome', with: 'Norma'
      fill_in 'Sobrenome', with: 'Blum'
      fill_in 'CPF', with: CPF.generate
      fill_in 'E-mail', with: 'norma@mail.com'
      fill_in 'Senha', with: '123'
      fill_in 'Confirme sua senha', with: '123'
      click_button 'Criar conta'
    end

    expect(page).to have_content 'Senha é muito curto (mínimo: 12 caracteres)'
  end

  it 'and is redirected to establishment registration page' do
    visit root_path
    click_on 'Criar conta'
    within('form') do
      fill_in 'Nome', with: 'Norma'
      fill_in 'Sobrenome', with: 'Blum'
      fill_in 'CPF', with: '70615592090'
      fill_in 'E-mail', with: 'norma@email.com'
      fill_in 'Senha', with: 'password1234'
      fill_in 'Confirme sua senha', with: 'password1234'
      click_on 'Criar conta'
    end

    expect(page).to have_content 'Boas vindas! Cadastre seu estabelecimento antes de continuar.'
    expect(current_path).to eq new_establishment_path
  end
end