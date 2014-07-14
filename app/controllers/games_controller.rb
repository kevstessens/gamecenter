class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:show, :edit, :update, :destroy, :index]
  before_filter :authenticate_game_owner!, :unless => :skip_filter?

  def skip_filter?
    !current_user.nil?
  end

  UserAchievement = Struct.new(:user, :achievement)

  def check_permissions
    #unless current_user.nil? and current_game_owner.nil?
    #  unless current_user.nil? and !current_game_owner.nil?
    #    redirect_to users_path, alert: 'No tiene permiso para acceder'
    #  end
    #end
  end

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    graph = Koala::Facebook::API.new(current_user.oauth_token)
    friends = graph.get_connections("me", "friends")
    @friends_count = 0
    @gamers = []
    @ranking = []
    friends.each do |friend|
      unless (User.find_by uid: friend["id"]).nil?
        friend = User.find_by uid: friend["id"]
        if friend.games.include? @game
          @gamers << friend
          @ranking << friend
        end
        @friends_count = @friends_count + 1
      end
    end

    @last_achievements = current_user.achievements.where(:game_id => @game.id).all

    @user_achievements =[]
    unless @gamers.nil?
      @gamers.each do |gamer|
        gamer.achievements.each do |ach|
          if ach.game_id == @game.id
            user_achievement_new = UserAchievement.new
            user_achievement_new.user = gamer
            user_achievement_new.achievement = ach
            @user_achievements << user_achievement_new
          end
        end
      end

      @ranking << current_user
      @ranking = @ranking.sort_by! {|u| u.game_points(@game)}
      @ranking = @ranking.reverse

      @gamers = @gamers.sort_by! {|u| u.game_points(@game)}
      @gamers = @gamers.reverse
    end

    @game_points = 0
    @last_achievements.each do |ac|
      @game_points = @game_points + ac.points
    end

  end

  def game_info
    @game=current_game_owner.game
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
    @game=current_game_owner.game
    @achievements = Achievement.where(:game => current_game_owner.game).all
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'El juego se ha creado!.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to root_path, notice: 'Los datos de tu juego se han actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'El juego ha sido correctamente eliminado.' }
      format.json { head :no_content }
    end
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
      if current_user.nil?
        if @game != current_game_owner.game
          redirect_to root_path, alert: 'No tiene permiso para acceder a este juego'
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:game_key, :secret_key, :name, :image, :description)
    end
end
