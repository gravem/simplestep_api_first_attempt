class ChecklistTemplatesController < ApplicationController
  # GET / checklist_templates
  def index
    @checklist_templates = ChecklistTemplate.all
    render json: @checklist_templates
  end

  # GET / chechlist_templates/:id
  def show
    @checklist_template = ChecklistTemplate.find(params[:id])
    render json: @checklist_template
  end

  # PATCH/PUT / checklist_templates/:id
  def update
    @checklist_template = ChecklistTemplate.find(params[:id])
      if @checklist_template.update(checklist_template_params)
        render json: @checklist_template
      else
        render json: @checklist_template.errors, status: :unprocessable_entity
      end
  end

  # POST / checklist_template
  def create
    @checklist_template = ChecklistTemplate.new(checklist_template_params)
    if @checklist_template.save
      render json: @checklist_template, status: :created
    else
      render json: @checklist_template.errors, status: :unprocessable_entity
    end
  end

  # DELETE / checklist_template/:id
  def destroy
    @checklist_template = ChecklistTemplate.find(params[:id])
    @checklist_template.destroy
    head :no_content
  end

  private

  def checklist_template_params
    params.require(:checklist_template).permit(:title, :description)
  end
end