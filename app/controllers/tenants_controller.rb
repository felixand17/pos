class TenantsController < ApplicationController
  before_action :prepare_tenant, only: [:edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @tenants = Tenant.all.order('created_at ASC')
  end

  def new
    @tenant = Tenant.new
    @tenant.build_user
    @role = Role.where(name: 'Tenant').first
  end

  def create
    @tenant = Tenant.new(tenant_params)
    if @tenant.save
      flash.keep[:notice] = "Tenant is created successfully."
      redirect_to tenants_path
    else
      flash.keep[:alert] = "Failed to create tenant."
      redirect_to tenants_path
    end
  end

  def edit
    render 'tenants/edit'
  end

  def update
    @tenant.update(tenant_params)
    redirect_to tenants_path
  end

  def destroy
    @tenant.destroy
    redirect_to tenants_path
  end

  private

  def tenant_params
    params.require(:tenant).permit(
      :id,
      :name,
      :description,
      :user_id,
      :phone_number,
      :identity_number,
      user_attributes: [:id, :email, :name, :password, :password_confirmation, :role_id]
    )
  end

  def prepare_tenant
    @tenant = Tenant.where(id: params[:id]).first
  end
end
