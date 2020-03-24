class Users::PreferencesController < Users::BaseController
  def edit
  end

  def update
    if current_user.update(permitted_user_params)
      redirect_to edit_user_preferences_path, notice: 'Your details have been updated with us'
    else
      render :edit, alert: current_user.errors.full_messages.to_sentence
    end
  end

  private
    def permitted_user_params
      params.require(:user).permit(permitted_user_attributes)
    end
end
