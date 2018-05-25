class RoomVisitsController < ApplicationController
  before_action :set_room_visit, only: [:show, :edit, :update, :destroy]

  # GET /room_visits
  # GET /room_visits.json
  def index
    @room_visits = RoomVisit.all
  end

  # GET /room_visits/1
  # GET /room_visits/1.json
  def show
  end

  # GET /room_visits/new
  def new
    @room_visit = RoomVisit.new
  end

  # GET /room_visits/1/edit
  def edit
  end

  # POST /room_visits
  # POST /room_visits.json
  def create
    @room_visit = RoomVisit.new(room_visit_params)

    respond_to do |format|
      if @room_visit.save
        format.html { redirect_to @room_visit, notice: 'Room visit was successfully created.' }
        format.json { render :show, status: :created, location: @room_visit }
      else
        format.html { render :new }
        format.json { render json: @room_visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /room_visits/1
  # PATCH/PUT /room_visits/1.json
  def update
    respond_to do |format|
      if @room_visit.update(room_visit_params)
        format.html { redirect_to @room_visit, notice: 'Room visit was successfully updated.' }
        format.json { render :show, status: :ok, location: @room_visit }
      else
        format.html { render :edit }
        format.json { render json: @room_visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /room_visits/1
  # DELETE /room_visits/1.json
  def destroy
    @room_visit.destroy
    respond_to do |format|
      format.html { redirect_to room_visits_url, notice: 'Room visit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room_visit
      @room_visit = RoomVisit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_visit_params
      params.require(:room_visit).permit(:date, :status, :visit_id, :room_id, :persona_id)
    end
end
