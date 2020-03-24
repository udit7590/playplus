module UsersHelper
  def in_admin_context(&block)
    if current_user && current_user.admin?
      yield.html_safe
    end
  end

  def in_member_context(&block)
    if current_user && current_user.member?
      yield.html_safe
    end
  end

  def in_any_user_context(&block)
    if current_user.present?
      yield.html_safe
    end
  end
end
