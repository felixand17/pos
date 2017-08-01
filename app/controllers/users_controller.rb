class UsersController < ApplicationController
  before_action :prepare_user, only: [:edit, :update, :destroy, :import_player_id]
  before_action :prepare_roles, only: [:new, :edit]
  load_and_authorize_resource

  def index
    @users = User.joins(:role).management.order('users.id ASC')
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      flash.keep[:notice] = "User is created successfully ."
      redirect_to users_path
    else
      flash.keep[:alert] = "Failed to create user."
      redirect_to users_path
    end
  end

  def edit;end

  def update
    @user.update(user_params)
    redirect_to users_path
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  def import_player_id
    @user.update_attribute(:web_player_id, params[:user][:player_id])
    render json: { message: 'Player ID already updated' }.to_json, status: 200
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :role_id)
  end

  def prepare_user
    @user = User.where(id: params[:id]).first
  end

  def prepare_roles
    @roles = Role.where("name NOT LIKE '%Root%'").distinct.map{|role| [role.name, role.id]}
  end
end
