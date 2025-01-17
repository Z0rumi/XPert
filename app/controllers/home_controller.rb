class HomeController < ApplicationController
    before_action :authenticate_user!

    # GET /home/index
    def index
      @user = current_user
    end
end
