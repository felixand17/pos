class Iam::PermissionsController < Iam::IamController
  before_action :prepare_permission, only: [:edit, :update]

  def index
    @permissions = Permission.all
  end

  def new
    @permission = Permission.new
  end

  def create
    @permission = Permission.new(permission_params)
    if @permission.save
      flash.keep[:notice] = "Permission is created successfully."
    else
      flash.keep[:alert] = @permission.errors.full_message.to_sentences
    end

    redirect_to iam_permissions_path
  end

  def edit;end

  def update
    if @permission.update(permission_params)
      flash.keep[:notice] = "Permission is updated successfully."
    else
      flash.keep[:alert] = @permission.errors.full_message.to_sentences
    end
    redirect_to iam_permissions_path
  end

  def destroy
    @permission.destroy
    redirect_to iam_permissions_path
  end

  private

  def permission_params
    params.require(:permission).permit(:name, :subject_class, :action)
  end

  def prepare_permission
    @permission = Permission.where(id: params[:id]).first
  end
end
