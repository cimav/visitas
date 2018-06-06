class VisitsController < ApplicationController
  before_action :set_visit, only: [:show, :edit, :update, :destroy, :create_room_visit, :upload_file]

  # GET /visits
  # GET /visits.json
  def index
    @visits = Visit.all
  end

  # GET /visits/1
  # GET /visits/1.json
  def show
    @room_visits = @visit.room_visits
  end

  def load_visits
    ###################### Se reciben los parámetros
    visits_loaded = params[:visits_loaded].to_i
    department_id = params[:search_object][:department]
    institution = params[:search_object][:institution]
    date = params[:search_object][:date]
    resp = params[:search_object][:resp]
    status = params[:search_object][:status]
    @visits = Visit.where.not(status: Visit::DELETED)

    #filtro por departamento
    @visits = @visits.where(department_id:department_id) unless department_id.blank?

    #filtro por institución
    @visits = @visits.where("institution LIKE '%#{institution}%'") unless institution.blank?

    #filtro por fecha
    @visits = @visits.where("date LIKE '#{date}%'") unless date.blank?

    #filtro por fecha
    @visits = @visits.where("resp_name LIKE '%#{resp}%'") unless resp.blank?

    #filtro por fecha
    @visits = @visits.where(status:status) unless status.blank?

    respond_to do |format|
      format.html do
        @visits = @visits.offset(visits_loaded).limit(50)
        render layout:false
      end
    end

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
    @visit = Visit.new(visit_params)

    respond_to do |format|
      if @visit.save
        format.html { redirect_to @visit, notice: 'Visit was successfully created.' }
        format.json { render :show, status: :created, location: @visit }
      else
        format.html {
          flash[:alert] = @visit.errors.full_messages
          redirect_to root_path}
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visits/1
  # PATCH/PUT /visits/1.json
  def update
    respond_to do |format|
      if @visit.update(visit_params)
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

  def create_room_visit
    room_visit = @visit.room_visits.new(
      persona_id: params[:room_visit][:persona_id],
      room_id: params[:room_visit][:room_id],
      date: "01-01-2000 #{params[:room_visit][:time]}", #todos los room_visit tienen la misma fecha ya que sólo importa la hora
      status: RoomVisit::SCHEDULED
    )
    respond_to do |format|
      if room_visit.save
        format.html { redirect_to @visit, notice: 'Visita a laboratorio agendada' }
        format.json { render :show, status: :created, location: @visit }
      else
        format.html {
          flash[:alert] = room_visit.errors.full_messages
          render :new }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_room_visit
    room_visit = RoomVisit.find(params[:room_visit_id])
    room_visit_params = {
        persona_id: params[:room_visit][:persona_id],
        room_id: params[:room_visit][:room_id],
        date: "01-01-2000 #{params[:room_visit][:time]}", #todos los room_visit tienen la misma fecha ya que sólo importa la hora
        status: RoomVisit::SCHEDULED
    }
    puts '---------------'
    puts params[:room_visit][:time]
    puts '---------------'
    respond_to do |format|
      if room_visit.update(room_visit_params)
        format.html { redirect_to room_visit.visit, notice: 'Visita a laboratorio agendada' }
        format.json { render :show, status: :created, location: @visit }
      else
        format.html {
          flash[:alert] = room_visit.errors.full_messages
          render :new }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit_room_visit
    @room_visit = RoomVisit.find(params[:room_visit_id])
    @visit = @room_visit.visit
    render layout: false
  end

  def upload_file
    file = VisitFile.new
    file.visit_id = @visit.id
    file.file_type = params[:visit_file]['file_type']
    file.file = params[:visit_file]['file']
    file.name = params[:visit_file]['file'].original_filename rescue 'Sin nombre'
    respond_to do |format|
      if file.save
        format.html {redirect_to @visit, notice: 'Se subió el documento'}
        format.json {head :no_content}
      else
        format.html {redirect_to @visit, notice: 'Error al subir documento'}
        format.json {head :no_content}
      end
    end
  end

  def upload_file_with_token
    @visit = Visit.find_by_token(params[:token])
    file = VisitFile.new
    file.visit_id = @visit.id
    file.file_type = params[:visit_file]['file_type']
    file.file = params[:visit_file]['file']
    file.name = params[:visit_file]['file'].original_filename rescue 'Sin nombre'
    respond_to do |format|
      if file.save
        format.html {redirect_to @visit, notice: 'Se subió el documento'}
        format.json {head :no_content}
      else
        format.html {redirect_to @visit, notice: 'Error al subir documento'}
        format.json {head :no_content}
      end
    end
  end

  def access_with_token
    @visit = Visit.find_by_token(params[:token])
    render layout: 'empty_layout'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visit
      @visit = Visit.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def visit_params
      params.require(:visit).permit(:department_id, :institution, :resp_name, :resp_phone, :resp_email, :requested_date, :transport_type, :status, :date)
    end
end
