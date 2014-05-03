class GoalsController < ApplicationController
  before_filter :require_current_user!
  
  def new
    @goal = Goal.new
  end
  
  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user_id
    if @goal.save
      flash[:notices] = ["Goal saved!"]
      render :show
    else
      flash[:notices] = @goal.errors.full_messages
      render :new
    end
  end
  
  def edit
    @goal = Goal.find(params[:id])
  end
  
  def update
    @goal = Goal.find(params[:id])
    if @goal.update_attributes(goal_params)
      flash[:notices] = ["Goal updated!"]
      redirect_to(:back)
    else
      flash[:notices] = @goal.errors.full_messages
      render :edit
    end
  end
  
  def show
    @goal = Goal.find(params[:id])
  end
  
  def index
    @goals = current_user.goals
  end
  
  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy
    flash[:notices] = ["Goal deleted!"]
    redirect_to goals_url
  end
  
  

  private
  def goal_params
    params.require(:goal).permit(:title, :details, :private, :completed, :user_id)
  end
end
