module SessionsHelper
  def current_user
    @current_user || User.find_by_session_token(session[:session_token])
  end
  
  def login!(user)
    # user is already authenticated by now
    user.reset_session_token!
    @current_user = user
    session[:session_token] = user.session_token
  end
  
  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end
  
  def current_user_id
    current_user ? current_user.id : nil
  end
  
  def current_user_name
    current_user ? current_user.username : nil    
  end
  
  # before filters
  
  def require_current_user!
    redirect_to new_user_url unless current_user
  end
  
  def require_no_current_user!
    redirect_to root_url if current_user
  end
  
end
