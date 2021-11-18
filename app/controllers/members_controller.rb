class MembersController < ApplicationController
  # Visitor can view all members but should be logged in to cast a vote
  before_action :authenticate_user!, only: :vote
  before_action :set_member, only: %i[ show edit update vote destroy ]

  # GET /members or /members.json
  def index
    LoadMembersJob.enqueue # Load Members from CORS endpoint
    @members = Member.all
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # POST /members or /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: "Member was successfully created." }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1 or /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: "Member was successfully updated." }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /members/id/vote
  def vote
    vote = Vote.new(member: @member, user: current_user)

    respond_to do |format|
      if vote.save
        format.html { redirect_to root_path, notice: "Your vote has been cast properly." }
        format.js { render layout: false } # Renders template: 'app/views/members/vote.js.erb'
      else
        format.html { redirect_to root_path, alert: "#{vote.errors.messages_for(:member).join(', ')}" }
        format.js { redirect_to root_path, alert: "#{vote.errors.messages_for(:member).join(', ')}" }
      end
    end
  end

  # DELETE /members/1 or /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: "Member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:name, :title, :bio, :image)
    end
end
