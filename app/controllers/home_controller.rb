class HomeController < ApplicationController
  def index
    @establishment = Establishment.find_by(user: current_user) 
  end
end