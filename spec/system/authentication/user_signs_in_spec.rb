require 'rails_helper'

describe 'User signs in' do
  it 'successfully' do
    User.create!(name: 'Norma', surname: 'Blum', social_security_number: '70615592090',
                        email: 'norma@email.com', password: 'dummy-password')

    visit root_path
    within('form') do
      fill_in 'E-mail', with: 'norma@email.com'
      fill_in 'Senha', with: 'dummy-password'
      click_on 'Entrar'
    end

    expect(page).to have_content 'Login efetuado com sucesso.'
    within('nav') do
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'Norma Blum'  
    end
  end

  it 'and logs out' do
    User.create!(name: 'Norma', surname: 'Blum', social_security_number: '70615592090',
                        email: 'norma@email.com', password: 'dummy-password')

    visit root_path
    within('form') do
      fill_in 'E-mail', with: 'norma@email.com'
      fill_in 'Senha', with: 'dummy-password'
      click_on 'Entrar'
    end
    within('nav') do
      click_on 'Sair'
    end

    expect(page).to have_content 'Entrar'
    expect(page).not_to have_content 'Norma Blum'
    expect(page).not_to have_button 'Sair'
  end
end