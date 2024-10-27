class EstablishmentsController < ApplicationController
  before_action :set_establishment_and_check_permission, only: [:edit, :update, :show]
  def show; end
  def new
    @establishment = Establishment.new
  end

  def create
    @establishment = Establishment.new(establishment_params)
    @establishment.user = current_user

    if @establishment.save
      return redirect_to @establishment, notice: 'Estabelecimento registrado com sucesso'
    end

    flash.now[:alert] = 'Não foi possível cadastrar o estabelecimento'
    render 'new', status: :unprocessable_entity
  end

  def edit; end

  def update
    if @establishment.update(establishment_params)
      return redirect_to @establishment, notice: 'Estabelecimento atualizado com sucesso'
    end
  end

  private
  def establishment_params
    establishment_params = params.require(:establishment).permit(:trade_name, :corporate_name,
                                    :registration_number, :city, :state, :zip, :address,
                                    :phone_number, :email)
  end

  def set_establishment_and_check_permission
    @establishment = Establishment.find(params[:id])
    if @establishment.user != current_user
      return redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end
end