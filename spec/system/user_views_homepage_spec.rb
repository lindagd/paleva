require 'rails_helper'

describe 'User visists homepage' do
  it 'and must be authenticated' do
    visit root_path
    
    expect(current_path).to eq new_user_session_path
  end

  it "and sees the system's name" do
    visit root_path

    expect(page).to have_content 'PaLevá' 
    expect(page).to have_link 'PaLevá', href: root_path
  end
end