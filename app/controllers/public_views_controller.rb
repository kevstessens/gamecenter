class PublicViewsController < ApplicationController

  # GET /public_views
  # GET /public_views.json
  def index
    game = Game.find_by game_key: params['game_id']
    if game.nil?
        redirect_to app_error_path
    else
      user = User.find_by uid: params['user_id']
      signature = request.fullpath.split("/").last
      path_to_encode = request.fullpath[0..(signature.length+1)*-1]+game.secret_key+"/"
      if signature == createsig(path_to_encode)
          @game = game
          @position = 1
          @gamers = []
          User.all.each do |friend|
            if friend.games.include? @game
              @gamers << friend
              if friend.game_points(game) > user.game_points(game)
                @position = @position + 1
              end
            end
          end
          @gamers << user
          @last_achievements = user.achievements.where(:game_id => @game.id).all
          @game_points = user.game_points(game)
        else
          redirect_to app_error_path
        end
      end

  end

  def createsig(o)
    Digest::MD5.hexdigest(o)
  end


end
