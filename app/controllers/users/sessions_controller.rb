# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    @user = current_user
    if @user.expert?
      if @user.initiated
        expert_profile_path(@user.expert_id)
      else
        @expert = Expert.find_by(email: @user.email)
        if @expert
          @user.update(expert_id: @expert.id, initiated: true)
          expert_profile_path(@user.expert_id)
        else
          new_expert_path
        end
      end
    else
      root_path
    end
  end
end
