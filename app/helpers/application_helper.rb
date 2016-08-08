module ApplicationHelper

  def is_admin?
    return user_signed_in? && current_user.admin?
  end
  
end
