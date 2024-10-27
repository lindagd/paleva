require 'rails_helper'

describe 'User edits opening hour' do
  it 'and does not own the opening hour record' do
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
    patch(opening_hour_path(opening_hour.id), params: { opening_hour: {week_day: 'sunday'}})

    expect(response).to redirect_to root_path
  end
end
