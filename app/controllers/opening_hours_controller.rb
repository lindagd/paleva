class OpeningHoursController < ApplicationController
  before_action :set_opening_hour_and_check_user_permission, only: [:edit, :update]
  def index
    @opening_hours = current_user.establishment.opening_hours
  end

  def new
    @opening_hour = OpeningHour.new
  end

  def create
    @opening_hour = OpeningHour.new(opening_hour_params)
    @opening_hour.establishment = current_user.establishment

    if @opening_hour.save
      return redirect_to opening_hours_path, notice: 'Horário cadastrado com sucesso'
    end

    flash.now[:alert] = 'Não foi possível cadastrar o horário'
    render 'new', status: :unprocessable_entity
  end

  def edit;  end

  def update
    if @opening_hour.update(opening_hour_params)
      return redirect_to opening_hours_path, notice: 'Horário alterado com sucesso'
    end

    flash.now[:alert] = 'Não foi possível atualizar o horário'
    render 'edit', status: :unprocessable_entity
  end

  private
  def opening_hour_params
    opening_hour_params = params.require(:opening_hour).permit(:week_day,
                                  :open_time, :close_time, :status)
  end

  def set_opening_hour_and_check_user_permission
    @opening_hour = OpeningHour.find(params[:id])
    if @opening_hour.establishment.user != current_user
      return redirect_to root_path, alert: 'Ação não autorizada'
    end
  end
end