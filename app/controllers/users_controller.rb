class UsersController < ApplicationController
#  before_action :logged_in_user
#, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  
  def new
    @user = User.new
  end


  # GET /users/new
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      #flash[:info] = "На Ваш почтовый ящик отправлено письмо со ссылки на активацию аккаунта."
      redirect_to users_url
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Профиль обновлен"
      redirect_to users_url
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Пользователь удален"
    redirect_to users_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def user_params
      params.require(:user).permit(:name,:date_birth, :email, :password,
                                   :password_confirmation)
    end
    
    # Before filters
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
#      redirect_to(root_url) unless current_user?(@user)
       redirect_to(root_url) unless current_user.admin?
    end
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
