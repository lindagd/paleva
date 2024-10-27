require 'rails_helper'

RSpec.describe OpeningHour, type: :model do
  describe '#valid?' do
    it 'must have week day' do
      opening_hour = OpeningHour.new(week_day: '')

      expect(opening_hour.valid?).to be false
      expect(opening_hour.errors.include? :week_day).to be true
      expect(opening_hour.errors[:week_day]).to include 'deve ser selecionado'
    end

    context "'closed' option is selected" do
      it 'and open time must be left blank' do
        opening_hour = OpeningHour.new(status: 'closed', open_time: '17:00')

        opening_hour.valid?
        
        expect(opening_hour.errors.include? :open_time).to be true
        expect(opening_hour.errors[:open_time]).to include "deve ficar em branco se 'Fechado' for marcado"
      end

      it 'and close time must be left blank' do
        opening_hour = OpeningHour.new(status: 'closed', close_time: '21:00')

        opening_hour.valid?
        expect(opening_hour.errors.include? :close_time).to be true
        expect(opening_hour.errors[:close_time]).to include "deve ficar em branco se 'Fechado' for marcado"
      end
    end
    
    context "'closed' is not selected" do
      it 'and open time must be present' do
        opening_hour = OpeningHour.new(open_time: '', status: 'open')

        opening_hour.valid?

        expect(opening_hour.errors.include? :open_time).to be true
        expect(opening_hour.errors[:open_time]).to include 'não pode ficar em branco'
      end

      it 'and close time must be present' do
        opening_hour = OpeningHour.new(close_time: '', status: 'open')

        opening_hour.valid?

        expect(opening_hour.errors.include? :close_time).to be true
        expect(opening_hour.errors[:close_time]).to include 'não pode ficar em branco'
      end
    end
    

    it 'must reference an establishment' do
      opening_hour = OpeningHour.new(week_day: 'sunday', status: 'closed')

      expect(opening_hour.valid?).to eq false
      expect(opening_hour.errors.include? :establishment).to eq true
      expect(opening_hour.errors[:establishment]).to include 'é obrigatório(a)'
    end
  end
end
