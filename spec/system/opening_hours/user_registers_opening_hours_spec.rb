require 'rails_helper'

describe 'User registers opening hours' do
  it 'coming from the homepage' do
    user = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                          registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                          address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user)
    
    login_as user
    visit root_path
    click_on 'Horários de Funcionamento'
    click_on 'Cadastrar Horários de Funcionamento'

    expect(current_path).to eq new_opening_hour_path
    expect(page).to have_select 'Dia'
    expect(page).to have_field 'Abre às'
    expect(page).to have_field 'Fecha às'
    expect(page).to have_field 'Fechado'
    expect(page).to have_button 'Salvar'
  end

  it 'successfully' do
    user = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                          registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                          address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user)
    
    login_as user
    visit root_path
    click_on 'Horários de Funcionamento'
    click_on 'Cadastrar Horários de Funcionamento'
    select 'Segunda-feira', from: 'Dia'
    fill_in 'Abre às', with: '18:00'
    fill_in 'Fecha às', with: '23:30'
    click_on 'Salvar'

    expect(page).to have_content 'Horário cadastrado com sucesso'
    expect(page).to have_content 'Segunda-feira: 18:00 - 23:30'
  end

  it 'with blank fields' do
    user = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                          registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                          address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user)
    
    login_as user
    visit root_path
    click_on 'Horários de Funcionamento'
    click_on 'Cadastrar Horários de Funcionamento'
    fill_in 'Abre às', with: ''
    fill_in 'Fecha às', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível cadastrar o horário'
    expect(page).to have_content 'Dia deve ser selecionado'
    expect(page).to have_content 'Abre às não pode ficar em branco'
    expect(page).to have_content 'Fecha às não pode ficar em branco'
  end

  context "and 'closed' is selected" do
    it 'then open and close time must be blank' do
      user = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
      Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                            registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                            address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user)
      
      login_as user
      visit root_path
      click_on 'Horários de Funcionamento'
      click_on 'Cadastrar Horários de Funcionamento'
      select 'Sábado', from: 'Dia'
      fill_in 'Abre às', with: '12:00'
      fill_in 'Fecha às', with: '22:00'
      check 'Fechado'
      click_on 'Salvar'

      expect(page).to have_content 'Não foi possível cadastrar o horário'
      expect(page).to have_content "Abre às deve ficar em branco se 'Fechado' for marcado"
      expect(page).to have_content "Fecha às deve ficar em branco se 'Fechado' for marcado"
    end
  end
  
end