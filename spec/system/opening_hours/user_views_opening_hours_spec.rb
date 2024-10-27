require 'rails_helper'

describe 'User views opening hours' do 
  it 'if authenticated' do
    visit root_path
    
    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_content('Horários de Funcionamento') 
  end

  it 'coming from the homepage' do
    user = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                          registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                          address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user)
    
    login_as user
    visit root_path
    click_on 'Horários de Funcionamento'

    expect(current_path).to eq opening_hours_path
  end

  it 'and there are no opening hours registered' do
    user = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                          registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                          address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user)
    
    login_as user
    visit root_path
    click_on 'Horários de Funcionamento'

    expect(page).to have_content 'Não foram cadastrados horários de funcionamento'
    expect(page).to have_link 'Cadastrar Horários de Funcionamento'
  end

  it 'sucessfully' do
    user = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    establishment = Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                      registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                      address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user)
    OpeningHour.create!(week_day: 'sunday', status: 'closed', establishment: establishment)
    OpeningHour.create!(week_day: 'monday', open_time: '17:00', close_time: '23:00', establishment: establishment)
    OpeningHour.create!(week_day: 'tuesday', open_time: '17:00', close_time: '23:00', establishment: establishment)
    OpeningHour.create!(week_day: 'wednesday', open_time: '17:00', close_time: '23:00', establishment: establishment)
    OpeningHour.create!(week_day: 'friday', open_time: '17:00', close_time: '00:00', establishment: establishment)

    login_as user
    visit root_path
    click_on 'Horários de Funcionamento'

    expect(page).to have_content 'Domingo: Fechado'
    expect(page).to have_content 'Segunda-feira: 17:00 - 23:00'
    expect(page).to have_content 'Terça-feira: 17:00 - 23:00'
    expect(page).to have_content 'Quarta-feira: 17:00 - 23:00'
    expect(page).to have_content 'Quinta-feira: Não há horário cadastrado nesse dia'
    expect(page).to have_content 'Sexta-feira: 17:00 - 00:00'
    expect(page).to have_content 'Sábado: Não há horário cadastrado nesse dia'
  end
end