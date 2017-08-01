class Iam::RolesController < Iam::IamController
  before_action :prepare_role, only: [:edit, :update]
  before_action :prepare_permission, only: [:edit, :new]

  def index
    @roles = Role.all
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      flash.keep[:notice] = "role is created successfully."
    else
      flash.keep[:alert] = @role.errors.full_message.to_sentences
    end

    redirect_to iam_roles_path
  end

  def edit;end

  def update
    if @role.update_attributes(role_params)
      @role.update_permissions(params[:role][:permissions])
      flash.keep[:notice] = "role is updated successfully."
    else
      flash.keep[:alert] = @role.errors.full_message.to_sentences
    end
    redirect_to iam_roles_path
  end

  def destroy
    @role.destroy
    redirect_to iam_roles_path
  end

  private

  def role_params
    params.require(:role).permit(:name, :description, :permissions)
  end

  def prepare_role
    @role = Role.where(id: params[:id]).first
  end

  def prepare_permission
    @permissions = Permission.all
  end
end
