class RestController < ActionController::Base



  def persist_achievement
    game = Game.find_by game_key: params['game_id'].to_i
    user = User.find_by uid: params['user_id'].to_i
    achievement = Achievement.find(params['achievement_id'].to_i)
    signature = request.fullpath.split("/").last
    path_to_encode = request.fullpath[0..(signature.length+1)*-1]+game.secret_key+"/"

    respond_to do |format|

      if signature == createsig(path_to_encode)
        if user.nil?
          user = User.new
          user.uid = params['user_id'].to_i
          user.provider = "facebook"
          user.save!
        end
        if !(user.achievements.include? achievement)
          user.achievements << achievement
          user.save!
          msg = { :status => "10", :message => "Success!", :html => "<b>Success!</b>" }
          format.json  { render :json => msg }
        else
        msg = { :status => "30", :message => "Already added achievement!", :html => "<b>Already added achievement!</b>" }
        format.json  { render :json => msg }
        format.html { redirect_to user_path(user)}
        end
      else
      msg = { :status => "20", :message => "Incorrect signature!", :html => "<b>Incorrect signature!</b>" }
      format.json  { render :json => msg }
      format.html { redirect_to root_path}
        end
    end


  end

  def user_achievements
    game = Game.find_by game_key: params['game_id'].to_i
    user = User.find_by uid: params['user_id'].to_i
    signature = request.fullpath.split("/").last
    path_to_encode = request.fullpath[0..(signature.length+1)*-1]+game.secret_key+"/"
    achievements = user.achievements.where(:game => game);
    user.achievements = achievements

    respond_to do |format|
      if signature == createsig(path_to_encode)

        format.json  { render :json => {:user =>user.to_json(:include => [:achievements]), :status=> "40" }}
        format.html { redirect_to user_path(user)} #this should showonly the achievements for the specific game.
      else
        msg = { :status => "20", :message => "Incorrect signature!", :html => "<b>Incorrect signature!</b>" }
        format.json  { render :json => msg }
        format.html { redirect_to root_path}
      end
    end
  end


  def createsig(o)
    Digest::MD5.hexdigest(o)
  end


end
