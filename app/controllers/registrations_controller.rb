# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  require 'securerandom'
  def new

    super
  end

  def create
    game = Game.new
    game.name= params[:game_owner][:email]
    game.description= "No hay info para este juego"
    require 'securerandom'
    game.game_key=SecureRandom.hex
    game.secret_key=SecureRandom.hex
    game.save!
    game_owner=GameOwner.new
    game_owner.email = params[:game_owner][:email]
    game_owner.password =params[:game_owner][:password]
    game_owner.password_confirmation = params[:game_owner][:password_confirmation]
    game_owner.game = game

    if game_owner.save
      if game_owner.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, game_owner)
        respond_with game_owner, location: after_sign_up_path_for(game_owner)
      else
        set_flash_message :notice, :"signed_up_but_#{game_owner.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with game_owner, location: after_inactive_sign_up_path_for(game_owner)
      end
    else
      clean_up_passwords resource
      redirect_to :back
    end

  end

  def update
    super
  end
end