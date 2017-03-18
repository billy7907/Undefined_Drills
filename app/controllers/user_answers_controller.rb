class UserAnswersController < ApplicationController

  def create
    @drill = Drill.find params[:drill_id]
    drill_answers = @drill.answers
    render json: @drill.answers

  end
end
