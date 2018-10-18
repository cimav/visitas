class UsersController < ApplicationController
  before_action :only_super_user
  before_action :set_user, only: [:edit, :delete, :update]

  def index
    @users = User.all
  end

  def edit
  end

  def create
    custom_params = user_params
    # departments llega como un arreglo de strings y siempre con el primer elemento vacío así que se cambia el formato
    custom_params[:departments]= custom_params[:departments].drop(1).map(&:to_i)
    @user = User.new(custom_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'Usuario creado' }
        format.json { render :edit, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      custom_params = user_params
      # departments llega como un arreglo de strings y siempre con el primer elemento vacío así que se cambia el formato
      custom_params[:departments]= custom_params[:departments].drop(1).map(&:to_i)
      if @user.update(custom_params)
        format.html { redirect_to users_path, notice: 'Usuario actualizado' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @user = User.new
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def only_super_user
    redirect_to '/' if !super_user?
  end

  def user_params
    params.require(:user).permit(:name, :email, :user_type, departments:[])
  end

end
