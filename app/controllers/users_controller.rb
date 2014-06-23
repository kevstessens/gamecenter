class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:show, :edit, :update, :destroy, :index]
  before_filter :authenticate_game_owner!, :unless => :skip_filter?

  def skip_filter?
    return !current_user.nil?
  end

  def check_permissions
    unless current_user.nil? and current_game_owner.nil?

      unless !current_user.nil? and current_game_owner.nil?
      redirect_to users_path, alert: 'No tiene permiso para acceder'
      end
      end
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @games = []
    current_user.achievements.each do |achievement|
      unless @games.include? achievement.game
        @games << achievement.game
      end
    end
    graph = Koala::Facebook::API.new(current_user.oauth_token)
    friends = graph.get_connections("me", "friends")
    @friends_count = 0
    friends.each do |friend|
      unless (User.find_by uid: friend[:id]).nil?
        @friends_count = @friends_count + 1
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      if (!current_user.nil?) and (@user != current_user)
        redirect_to users_path, alert: 'No tiene permiso para acceder'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:provider, :uid, :name, :oauth_token, :oauth_expires_at)
    end
end
