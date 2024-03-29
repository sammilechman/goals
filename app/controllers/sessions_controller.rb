class SessionsController < ApplicationController
  before_filter :require_current_user!, :only => [:destroy]
  before_filter :require_no_current_user!, :only => [:new, :create]
  
  def new
    @user = User.new()
  end
  
  def create
    credentials = [params[:user][:username], params[:user][:password]]
    @user = User.find_by_credentials(*credentials)
    if @user
      login!(@user)
      redirect_to user_url(@user)
    else
      flash[:notices] = ["Invalid credentials."]
      @user = User.new
      render :new
    end
  end
  
  def destroy
    logout!
    redirect_to new_session_url
  end
end
