class DrillsController < ApplicationController
  def index
    @drills = Drill.where(group: params[:group_id]).order(created_at: :desc)
  end

  def new
    @drill = Drill.new
  end

  def create
    @drill  = Drill.new(drill_params)
    @drill.user = current_user
    if @drill.save
      flash[:notice] = 'Drill created successfully'
      redirect_to drill_path(@drill)
    else
      flash.now[:alert] = 'Please fix errors below'
      render :new
    end
  end

  def show
    @drill = Drill.find params[:id]
    @user_answer ||= ""
  end

  def edit
  end

  def update
  end

  def destroy
    @drill.destroy
    redirect_to drills_index_path, notice: 'Drill Deleted'
  end

  private

  def drill_params
    params.require(:drill).permit([:title, :description])
  end
end
