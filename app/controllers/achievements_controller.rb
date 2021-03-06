class AchievementsController < ApplicationController
  before_action :set_achievement, only: [:show, :edit, :update, :destroy, :activate]
  before_action :check_permissions, only: [:show, :edit, :update, :destroy, :index]
  before_filter :authenticate_game_owner!, :unless => :skip_filter?

  def skip_filter?
    return !current_user.nil?
  end

  def check_permissions
    unless current_user.nil? and current_game_owner.nil?

      unless current_user.nil? and !current_game_owner.nil?
      redirect_to users_path, alert: 'No tiene permiso para acceder'
    end
    end
  end

  # GET /achievements
  # GET /achievements.json
  def index
    @achievements = Achievement.all
  end

  def activate
    @achievement.active = true
    respond_to do |format|
      if @achievement.save
        format.html { redirect_to :back, notice: 'se ha activado su logro correctamente.' }
        format.json { render :show, status: :ok, location: @achievement }
      else
        format.html { redirect_to :back, alert: 'No pudo activarse su logro, intente nuevamente.' }
        format.json { render json: @achievement.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /achievements/1
  # GET /achievements/1.json
  def show
  end

  # GET /achievements/new
  def new
    @achievement = Achievement.new
    @remaining_points = 2000
    current_game_owner.game.achievements.each do |achievement|
      @remaining_points = @remaining_points - achievement.points
    end

  end

  # GET /achievements/1/edit
  def edit
    @remaining_points = 2000
    current_game_owner.game.achievements.each do |achievement|
      @remaining_points = @remaining_points - achievement.points
    end
  end

  # POST /achievements
  # POST /achievements.json
  def create
    @achievement = Achievement.new(achievement_params)
    @remaining_points = 2000
    current_game_owner.game.achievements.each do |achievement|
      @remaining_points = @remaining_points - achievement.points
    end

    respond_to do |format|
      if @achievement.points.nil?
        points = @remaining_points
      else
        points =@remaining_points - @achievement.points
      end

      if points > 0
        if @achievement.save
          format.html { redirect_to edit_game_path(current_game_owner.game), notice: 'Se ha guardado el logro correctamente.' }
          format.json { render :show, status: :created, location: @achievement }
        else
          format.html { render :new }
          format.json { render json: @achievement.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new, alert: "No te quedan suficientes puntos disponibles." }
        format.json { render json: "not enough points", status: :unprocessable_entity }
      end


    end
  end

  # PATCH/PUT /achievements/1
  # PATCH/PUT /achievements/1.json
  def update
    respond_to do |format|
      if @achievement.update(achievement_params)
        format.html { redirect_to edit_game_path(@achievement.game), notice: 'Se ha actualizado su logro' }
        format.json { render :show, status: :ok, location: @achievement }
      else
        format.html { render :edit }
        format.json { render json: @achievement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /achievements/1
  # DELETE /achievements/1.json
  def destroy
    @achievement.destroy
    respond_to do |format|
      format.html { redirect_to achievements_url, notice: 'Achievement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_achievement
      @achievement = Achievement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def achievement_params
      params.require(:achievement).permit(:game_id, :points, :image, :name, :description, :active)
    end
end
