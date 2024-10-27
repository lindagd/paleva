class MenuItemsController < ApplicationController
  def index; end

  def dishes
    @menu_items = MenuItem.dishes
  end
end