class ApplicationController < ActionController::Base
  after_action :track_action

  helper_method :current_user, :page_css, :power_user?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def power_user?
    current_user && current_user.auth_level >1
  end


  def page_css(controller_name,action_name)


    if controller_name == "main" && (action_name == "register" || action_name == "new_user")
      return "login-page"
    end

    if controller_name == "main" && action_name == "attempt_login"
      return "login-page"
    end

    if controller_name == "main" && action_name == "login"
      return "login-page"
    end

    if controller_name == "main" && action_name == "index"
      return "index-page"
    end

    return "landing-page"

  end

  private

    def is_admin
      redirect_to(root_path) if !current_user || (current_user && current_user.auth_level != 9)
    end

  protected

  def track_action
    ahoy.track "Action", request.path_parameters
  end

end
