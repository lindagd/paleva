require 'rails_helper'

describe 'User edits opening hour' do
  it 'from opening hours index page' do
    user = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                          registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                          address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user)
    OpeningHour.create!(week_day: 'sunday', open_time: '16:00', close_time: '23:30', establishment: Establishment.last)

    login_as user
    visit root_path
    click_on 'Horários de Funcionamento'
    within('#sunday') do
      click_on 'Editar'
    end

    expect(page).to have_select('Dia', selected: 'Domingo')
    expect(page).to have_field('Abre às', with: '16:00:00.000')
    expect(page).to have_field('Fecha às', with: '23:30:00.000')
    expect(page).to have_field('Fechado')
    expect(page).to have_button('Salvar')
  end

  it 'successfully' do
    user = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                          registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                          address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user)
    OpeningHour.create!(week_day: 'sunday', status: 'closed', establishment: Establishment.last)

    login_as user
    visit root_path
    click_on 'Horários de Funcionamento'
    within('#sunday') do
      click_on 'Editar'
    end
    uncheck 'Fechado'
    fill_in 'Abre às', with: '16:00'
    fill_in 'Fecha às', with: '23:30'
    click_on 'Salvar'

    expect(page).to have_content 'Horário alterado com sucesso'
    expect(page).to have_content 'Domingo: 16:00 - 23:30'
    expect(page).not_to have_content 'Domingo: Fechado'
  end

  it "if it references user's establishment" do
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
    opening_hour = OpeningHour.create!(week_day: 'sunday', status: 'closed', establishment: establishment)

    login_as user2
    visit edit_opening_hour_path(opening_hour.id)

    expect(current_path).not_to eq edit_opening_hour_path(opening_hour.id)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Ação não autorizada'
  end
end