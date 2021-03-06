class CollaborationsController < ApplicationController
  before_action :set_collaboration, only: [:show, :edit, :update, :destroy]

  # GET /collaborations
  # GET /collaborations.json
  def index
    @collaborations = Collaboration.all
  end

  # GET /collaborations/1
  # GET /collaborations/1.json
  def show
  end

  # GET /collaborations/new
  def new
    @collaboration = Collaboration.new
  end

  # GET /collaborations/1/edit
  def edit
  end

  # POST /collaborations
  # POST /collaborations.json
  def create

    @project = Project.find(collaboration_params[:project_id])

    # if(not @project.assignment_id.nil?)
    #   render plain: "Assignments cannot have collaborators. Please contact admin." and return
    # end

    if(@project.author_id!=current_user.id)
      render plain: "Access Restricted " and return
    end

    collaboration_params[:emails].split(',').each do |email|
      email = email.strip
      user = User.find_by(email: email)
      if user.nil?
        # PendingInvitation.where(group_id:@group.id,email:email).first_or_create
      else
        Collaboration.where(project_id:@project.id,user_id:user.id).first_or_create
      end
    end

    respond_to do |format|
      format.html { redirect_to user_project_path(@project.author_id,@project.id), notice: 'Collaborators have been added'}
    end

  end

  # PATCH/PUT /collaborations/1
  # PATCH/PUT /collaborations/1.json
  def update
    respond_to do |format|
      if @collaboration.update(collaboration_params)
        format.html { redirect_to @collaboration, notice: 'Collaboration was successfully updated.' }
        format.json { render :show, status: :ok, location: @collaboration }
      else
        format.html { render :edit }
        format.json { render json: @collaboration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collaborations/1
  # DELETE /collaborations/1.json
  def destroy
    @collaboration.destroy
    respond_to do |format|
      format.html { redirect_to user_project_path(@collaboration.project.author_id,@collaboration.project_id), notice: 'Collaboration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collaboration
      @collaboration = Collaboration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collaboration_params
      params.require(:collaboration).permit(:user_id, :project_id, :emails)
    end
end
