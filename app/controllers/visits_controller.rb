class VisitsController < ApplicationController
  before_action :set_visit, only: [:show, :edit, :update, :destroy]

  # GET /visits
  # GET /visits.json
  def index
    @visits = Visit.all
  end

  # GET /visits/1
  # GET /visits/1.json
  def show
  end

  # GET /visits/new
  def new
    @visit = Visit.new
  end

  # GET /visits/1/edit
  def edit
    datetime = @visit.date.to_s()
    @date = datetime.split(" ")[0].to_date.strftime("%d %B, %Y")
    @time = datetime.split(" ")[1].to_time.strftime('%l:%M%P') rescue "" #hora con formato 12H
  end

  # POST /visits
  # POST /visits.json
  def create
    data = {}
    data = visit_params
    data[:date] = get_datetime(params)
    @visit = Visit.new(data)

    respond_to do |format|
      if @visit.save
        format.html { redirect_to @visit, notice: 'Visit was successfully created.' }
        format.json { render :show, status: :created, location: @visit }
      else
        format.html {
          flash[:alert] = @visit.errors.full_messages
          render :new }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visits/1
  # PATCH/PUT /visits/1.json
  def update
    data = {}
    data = visit_params
    data[:date] = get_datetime(params)
    respond_to do |format|
      if @visit.update(data)
        format.html { redirect_to @visit, notice: 'Visit was successfully updated.' }
        format.json { render :show, status: :ok, location: @visit }
      else
        format.html {
          flash[:alert] = @visit.errors.full_messages
          render :edit }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visits/1
  # DELETE /visits/1.json
  def destroy
    @visit.destroy
    respond_to do |format|
      format.html { redirect_to visits_url, notice: 'Visit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def get_institutions
    institutions = {}
    Institution.all.each do |institution|
      institutions[institution.name] = institution.image.blank? ? nil : "http://posgrado.cimav.edu.mx/images/institution/image/#{institution.id}/#{institution.image}"
    end
    render json: institutions
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visit
      @visit = Visit.find(params[:id])
    end


    def get_datetime(params)
      date    = params[:date]
      time    = params[:time]
      return "#{date} #{time}"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visit_params
      params.require(:visit).permit(:department_id, :institution, :resp_name, :resp_phone, :resp_email, :requested_date, :transport_type)
    end
end
