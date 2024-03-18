class Api::V1::StepsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_checklist_template

  def create
    @step = @checklist_template.steps.build(step_params)
    if @step.save
      render json: @step, status: :created
    else
      render json: @step.errors, status: :unprocessable_entity
    end
  end

  def index
    @steps = @checklist_template.steps
    render json: @steps
  end

  def show
    @step = @checklist_template.steps.find(params[:id])
    render json: @step
  end

  def update
    @step = @checklist_template.steps.find(params[:id])
    if @step.update(step_params)
      render json: @step
    else
      render json: @step.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @step = @checklist_template.steps.find(params[:id])
    @step.destroy
    head :no_content
  end

  private

  def set_checklist_template
    @checklist_template = current_user.checklist_templates.find(params[:checklist_template_id])
  end

  def step_params
    params.require(:step).permit(:description, :completed)
  end
end
