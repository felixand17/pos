class OptionsController < ApplicationController
  before_action :prepare_option, only: [:edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @options = Option.all
  end

  def new
    @option = Option.new
  end

  def create
    @option = Option.new(option_params)
    if @option.save
      flash.keep[:notice] = "option is created successfully."
      redirect_to options_path
    else
      flash.keep[:alert] = "Failed to create option."
      redirect_to options_path
    end
  end

  def edit
    render 'options/edit'
  end

  def update
    @option.update(option_params)
    redirect_to options_path
  end

  def destroy
    @option.destroy
    redirect_to options_path
  end

  private

  def option_params
    params.require(:option).permit(
      :option_name,
      :option_value
    )
  end

  def prepare_option
    @option = Option.where(id: params[:id]).first
  end
end
