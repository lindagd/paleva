require 'rails_helper'

describe 'User views dishes' do
  it 'if authenticated' do
    visit root_path

    expect(page).not_to have_link 'Pratos'
    expect(current_path).to eq new_user_session_path
  end

  it 'from the navbar menu' do
    user = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                          registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                          address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user)

    login_as user
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end

    expect(current_path).to eq dishes_menu_items_path 
  end

  it 'and there are no registered dishes' do
    user = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                          registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                          address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user)

    login_as user
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end

    expect(page).to have_content 'Não há pratos cadastrados'
  end

  it 'successfully' do
    user = User.create!(name: 'Carmy', surname: 'Berzatto', social_security_number: CPF.generate,
                        email: 'berzatto_carmy@email.com', password: 'password1234')
    Establishment.create!(trade_name: 'The Bear', corporate_name: 'The Bear Restaurant LTDA',
                          registration_number: CNPJ.generate, city: 'São Paulo', state: 'SP', zip: '01306-001',
                          address: 'Rua Avanhandava, 90', phone_number: '11989665480', email: 'contato@thebear.com.br', user: user)
    MenuItem.create!(name: 'Classic Burger', description: 'Pão brioche, blend bovino 100g e queijo cheddar',
                 calories: 455, establishment: user.establishment, itemable: Dish.new)
    
    login_as user
    visit root_path
    within('nav') do
      click_on 'Pratos'
    end

    expect(page).to have_content 'Classic Burger'
    expect(page).to have_content 'Pão brioche, blend bovino 100g e queijo cheddar'
    expect(page).to have_content '455 calorias'
  end
end