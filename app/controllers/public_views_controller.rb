class PublicViewsController < ApplicationController

  # GET /public_views
  # GET /public_views.json
  def index
    game = Game.find_by game_key: params['game_id']
    user = User.find_by uid: params['user_id']
    if game.nil?
      redirect_to app_error_path
    else
      if user.nil?
        redirect_to app_no_gamer_path
      else
      signature = request.fullpath.split("/").last
      path_to_encode = request.fullpath[0..(signature.length+1)*-1]+Date.current().strftime("%d-%m-%y")+"/"+game.secret_key+"/"
      if signature == createsig(path_to_encode)
          @game = game
          @position = 1
          @gamers = []
          User.all.each do |friend|
            if friend.games.include? @game and (friend != user)
              @gamers << friend
              unless friend.nil?
                if friend.game_points(game) > user.game_points(game)
                @position = @position + 1
                end

              end
            end
          end
          @gamers << user
          @gamers = @gamers.sort_by! {|u| u.game_points(game)}
          @gamers = @gamers.reverse
          @last_achievements = user.achievements.where(:game_id => @game.id).all
          @game_points = user.game_points(game)
          @user = user
        else
          redirect_to app_error_path
        end
    end
      end

  end

  # GET /public_views
  # GET /public_views.json
  def index_friends
    game = Game.find_by game_key: params['game_id']
    friends = params['friends'].split(",")
    if game.nil?
      redirect_to app_error_path
    else
      user = User.find_by uid: params['user_id']
      if user.nil?
        redirect_to app_no_gamer_path
      else
      signature = request.fullpath.split("/").last
      path_to_encode = request.fullpath[0..(signature.length+1)*-1]+Date.current().strftime("%d-%m-%y")+"/"+game.secret_key+"/"
      if signature == createsig(path_to_encode)
        @game = game
        @position = 1
        @all_position = 1
        @gamers = []
        User.all.each do |friend|
          unless friend.nil?
            if(friend.games.include? @game) and (friends.include? friend.uid)
              @gamers << friend
              if friend.game_points(game) > user.game_points(game)
                @position = @position + 1
              end
            end
          end
        end
        @gamers << user
        @gamers = @gamers.sort_by! {|u| u.game_points(game)}
        @gamers = @gamers.reverse
        @all_gamers = []
        User.all.each do |friend|
          if friend.games.include? @game and (friend != user)
            @all_gamers << friend
            unless friend.nil?
              if friend.game_points(game) > user.game_points(game)
                @all_position = @all_position + 1
              end

            end
          end
        end
        @all_gamers << user
        @all_gamers = @all_gamers.sort_by! {|u| u.game_points(game)}
        @all_gamers = @all_gamers.reverse
        @last_achievements = user.achievements.where(:game_id => @game.id).all
        @game_points = user.game_points(game)
        @user = user
      else
        redirect_to app_error_path
      end
    end
  end

  end

  def createsig(o)
    Digest::MD5.hexdigest(o)
  end


end
