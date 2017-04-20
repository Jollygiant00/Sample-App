module SessionsHelper
  
  # Method to log user in
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # Creates permanent cookie to remember user account
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def current_user?(user)
    user == current_user
  end
  
  # checks for permanent and temporary cookie to find user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # checks for current user
  def logged_in?
    !current_user.nil?
  end
  
  # deletes permanent and temporary cookies
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # deletes session cookies and destroys login path for user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # Redirects to stored location ( or to the defualt )
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  # Stores the URL to be deleted
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end