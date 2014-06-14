class GameOwnersController < ApplicationController
  before_action :set_game_owner, only: [:show, :edit, :update, :destroy]

  # GET /game_owners
  # GET /game_owners.json
  def index
    @game_owners = GameOwner.all
    @gamers = current_game_owner.game.users
    @gamers = User.all      # Remove when whorking.
    @last_achievements = Achievement.where(:game => current_game_owner.game).all

  end

  # GET /game_owners/1
  # GET /game_owners/1.json
  def show
  end

  # GET /game_owners/new
  def new
    @game_owner = GameOwner.new
  end

  # GET /game_owners/1/edit
  def edit
  end

  # POST /game_owners
  # POST /game_owners.json
  def create
    @game_owner = GameOwner.new(game_owner_params)

    respond_to do |format|
      if @game_owner.save
        format.html { redirect_to @game_owner, notice: 'Usuario creado exitosamente' }
        format.json { render :show, status: :created, location: @game_owner }
      else
        format.html { render :new }
        format.json { render json: @game_owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_owners/1
  # PATCH/PUT /game_owners/1.json
  def update
    respond_to do |format|
      if @game_owner.update(game_owner_params)
        format.html { redirect_to root_path, notice: 'Tus datos fueron actualizados!' }
        format.json { render :show, status: :ok, location: @game_owner }
      else
        format.html { render :edit }
        format.json { render json: @game_owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_owners/1
  # DELETE /game_owners/1.json
  def destroy
    @game_owner.destroy
    respond_to do |format|
      format.html { redirect_to game_owners_url, notice: 'Game owner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_owner
      @game_owner = GameOwner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_owner_params
      params.require(:game_owner).permit(:email, :password, :game_id)
    end
end
