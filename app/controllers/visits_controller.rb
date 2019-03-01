class VisitsController < ApplicationController
  before_action :set_visit, only: [:show, :edit, :update, :destroy, :create_room_visit, :upload_file, :visit_people, :add_person, :pre_approve]
  skip_before_action :auth_required, only: [:access_with_token, :public_create_visit, :public_new_visit, :get_institutions, :visit_success, :visit_people, :add_person, :edit_visit_person, :update_visit_person, :upload_file_with_token, :delete_visit_person_with_token, :confirm_room_visit, :cancel_room_visit, :confirm_visit]
  before_action :allow_iframe_requests, only: [:public_new_visit, :public_create_visit, :visit_success]

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
    visit_type = params[:search_object][:visit_type]
    @visits = Visit.where.not(status: Visit::DELETED)

    #filtro por departamento
    @visits = @visits.where(department_id: department_id) unless department_id.blank?

    #filtro por institución
    @visits = @visits.where("institution LIKE '%#{institution}%'") unless institution.blank?

    #filtro por fecha
    @visits = @visits.where("date LIKE '#{date}%'") unless date.blank?

    #filtro por nombre del responsable
    @visits = @visits.where("resp_name LIKE '%#{resp}%'") unless resp.blank?

    #filtro por estatus
    @visits = @visits.where(status: status) unless status.blank?

    #filtro por tipo
    @visits = @visits.where(visit_type: visit_type) unless visit_type.blank?

    @visits = @visits.order('created_at desc')
    respond_to do |format|
      format.html do
        @visits = @visits.offset(visits_loaded).limit(50)
        render layout: false
      end
      format.xls do
        rows = Array.new

        @visits.collect do |visit|
          rows << {
              'Departamento' => (visit.department.name rescue 'Sin información'),
              'Institución' => (visit.institution rescue 'Sin información'),
              'Carrera' => (visit.career rescue 'Sin información'),
              'Tipo de visita' => (visit.get_visit_type rescue 'Sin información'),
              'Responsable' => (visit.resp_name rescue 'Sin información'),
              'Teléfono Responsable' => (visit.resp_phone rescue 'Sin información'),
              'Email Responsable' => (visit.resp_email rescue 'Sin información'),
              'Tipo de transporte' => (visit.get_transport_type rescue 'Sin información'),
              'Fecha' => (visit.date rescue 'Sin información'),
              'Estado' => (visit.get_status rescue 'Sin información')
          }
        end
        column_order = ['Departamento', 'Institución', 'Carrera', 'Tipo de visita', 'Responsable', 'Teléfono Responsable', 'Email Responsable', 'Tipo de transporte', 'Fecha', 'Estado']
        to_excel(rows, column_order, "Servicios", "Reporte_Becas")
      end
    end

  end

  # GET /visits/new
  def new
    only_admin
    @visit = Visit.new
  end

  # GET /visits/1/edit
  def edit
    if !@visit.status.in? [Visit::REQUESTED, Visit::PRE_APPROVED]
      only_admin
    end

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
        format.html {redirect_to @visit, notice: 'Visita agendada exitósamente'}
        format.json {render :show, status: :created, location: @visit}
      else
        format.html {
          flash[:alert] = @visit.errors.full_messages
          redirect_to root_path}
        format.json {render json: @visit.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /visits/1
  # PATCH/PUT /visits/1.json
  def update
    respond_to do |format|
      send_approved_email = false
      send_confirm_email = false
      send_pre_approved_email = false


      if (@visit.status != Visit::APPROVED) && (params[:visit][:status].to_i == Visit::APPROVED)
        send_approved_email = true
      end


      if (@visit.status != Visit::PRE_APPROVED) && (params[:visit][:status].to_i == Visit::PRE_APPROVED)
        send_pre_approved_email = true
      end

      if (@visit.status != Visit::CONFIRMED) && (params[:visit][:status].to_i == Visit::CONFIRMED)
        send_confirm_email = true
      end

      if @visit.update(visit_params)
        if send_approved_email
          @visit.send_approved_email
        end

        if send_confirm_email
          @visit.send_confirmed_email
          @visit.send_confirm_email_technician
        end

        if send_pre_approved_email
          @visit.send_pre_approved_email
        end
        format.json {render plain: 'Separar en grupos'}
        format.html {redirect_to @visit, notice: 'Visita actualizada'}
      else
        format.html {
          flash[:alert] = @visit.errors.full_messages
          render :edit}
        format.json {redirect_to '/error'}
      end
    end
  end

  # DELETE /visits/1
  # DELETE /visits/1.json
  def destroy
    only_admin
    @visit.destroy
    respond_to do |format|
      format.html {redirect_to visits_url, notice: 'Visita eliminada'}
      format.json {head :no_content}
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
    room_visit = @visit.room_visits.new
    room_visit_params = {
        persona_id: params[:room_visit][:persona_id],
        room_id: params[:room_visit][:room_id],
        date: "01-01-2000 #{params[:room_visit][:time]}", #todos los room_visit tienen la misma fecha ya que sólo importa la hora
        status: RoomVisit::SCHEDULED
    }
    room_visit_params[:group] = params[:room_visit][:group] if !params[:room_visit][:group].blank?
    respond_to do |format|
      if room_visit.update(room_visit_params)
        format.html {redirect_to @visit, notice: 'Visita a laboratorio agendada'}
        format.json {render :show, status: :created, location: @visit}
      else
        format.html {
          flash[:alert] = room_visit.errors.full_messages
          redirect_to @visit}
        format.json {render json: '/visit_error', status: :unprocessable_entity}
      end
    end
  end

  def update_room_visit
    room_visit = RoomVisit.find(params[:room_visit_id])
    room_visit_params = {
        persona_id: params[:room_visit][:persona_id],
        room_id: params[:room_visit][:room_id],
        date: "01-01-2000 #{params[:room_visit][:time]}", #todos los room_visit tienen la misma fecha ya que sólo importa la hora
    }
    room_visit_params[:group] = params[:room_visit][:group] if !params[:room_visit][:group].blank?
    respond_to do |format|
      if room_visit.update(room_visit_params)
        format.html {redirect_to room_visit.visit, notice: 'Visita a laboratorio actualizada'}
        format.json {render :show, status: :created, location: @visit}
      else
        format.html {
          flash[:alert] = room_visit.errors.full_messages
          redirect_to @visit}
        format.json {render json: @visit.errors, status: :unprocessable_entity}
      end
    end
  end

  def delete_room_visit
    room_visit = RoomVisit.find(params[:room_visit_id])
    respond_to do |format|
      if room_visit.update(status: RoomVisit::CANCELED)
        format.html {redirect_to room_visit.visit, notice: 'Visita a laboratorio cancelada'}
        format.json {render :show, status: :created, location: @visit}
      else
        format.html {
          flash[:alert] = room_visit.errors.full_messages
          render :new}
        format.json {render json: @visit.errors, status: :unprocessable_entity}
      end
    end
  end

  def confirm_room_visit
    room_visit = RoomVisit.find(params[:room_visit_id])
    if room_visit.status == RoomVisit::SCHEDULED
      if room_visit.update(status: RoomVisit::FINISHED)
        render plain: 'Visita a laboratorio confirmada'
      else
        render plain: 'Error inesperado'
      end
    else
      render plain: "Esta visita ya ha sido marcada con estatus: #{room_visit.get_status}"
    end
  end

  def cancel_room_visit
    room_visit = RoomVisit.find(params[:room_visit_id])
    if room_visit.status == RoomVisit::SCHEDULED
      if room_visit.update(status: RoomVisit::CANCELED)
        render plain: 'Visita a laboratorio cancelada'
      else
        render plain: 'Error inesperado'
      end
    else
      render plain: "Esta visita ya ha sido marcada con estatus: #{room_visit.get_status}"
    end
  end

  def new_room_visit
    @room_visit = RoomVisit.new
    @visit = Visit.find(params[:id])
    render layout: false
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
        format.html {redirect_to "/visits/token/#{@visit.token}", notice: 'Se subió el documento'}
        format.json {head :no_content}
      else
        format.html {redirect_to "/visits/token/#{@visit.token}", notice: 'Error al subir documento'}
        format.json {head :no_content}
      end
    end
  end

  def access_with_token
    @visit = Visit.find_by_token(params[:token])
    @visit_people_size = @visit.visit_people.size
    render layout: 'empty_layout'
  end

  def public_new_visit
    @visit = Visit.new
    render layout: 'empty_layout'
  end

  def public_create_visit
    @visit = Visit.new(visit_params)

    respond_to do |format|
      if @visit.save
        format.html {redirect_to 'https://visitas.cimav.edu.mx/visit_success'} # hay que especificar el path con https para que el iframe no bloqueé el contenido
        format.json {render :show, status: :created, location: @visit}
      else
        format.html {
          flash[:alert] = @visit.errors.full_messages
          redirect_to 'https://visitas.cimav.edu.mx/public_new_visit'} # hay que especificar el path con https para que el iframe no bloqueé el contenido
        format.json {render json: @visit.errors, status: :unprocessable_entity}
      end
    end
  end

  def visit_success
    render layout: 'empty_layout'
  end

  def add_person
    response = {}
    person = @visit.visit_people.new(name: params[:visit_person][:name], person_type: params[:visit_person][:person_type])
    if person.save
      response[:message] = 'Persona agregada'
    else
      response[:message] = person.errors.full_messages.first
    end
    respond_to do |format|
      format.json {render json: response}
    end

  end

  def visit_people
    @is_token = params[:is_token] == 'true'
    render layout: false
  end

  def update_visit_person
    person = VisitPerson.find(params[:visit_person_id])
    person.name = params[:visit_person][:name]
    person.person_type = params[:visit_person][:person_type]

    respond_to do |format|
      if person.save
        format.html {
          if params[:is_token] == 'true'
            redirect_to "/visits/token/#{person.visit.token}", notice: 'Persona actualizada'
          else
            redirect_to person.visit, notice: 'Persona actualizada'
          end
        }
        format.json {render :show, status: :created, location: @visit}
      else
        format.html {
          flash[:alert] = person.errors.full_messages
          redirect_to person.visit}
        format.json {render json: person.errors, status: :unprocessable_entity}
      end
    end
  end


  def delete_visit_person
    person = VisitPerson.find(params[:visit_person_id])

    respond_to do |format|
      if person.destroy
        format.html {redirect_to person.visit, notice: 'Persona eliminada de la lista de asistencia'}
        format.json {render :show, status: :created, location: @visit}
      else
        format.html {
          flash[:alert] = person.errors.full_messages
          redirect_to person.visit}
        format.json {render json: person.errors, status: :unprocessable_entity}
      end
    end
  end

  def delete_visit_person_with_token
    person = VisitPerson.find(params[:visit_person_id])

    respond_to do |format|
      if person.destroy
        format.html {redirect_to "/visits/token/#{person.visit.token}", notice: 'Persona eliminada de la lista de asistencia'}
        format.json {render :show, status: :created, location: @visit}
      else
        format.html {
          flash[:alert] = person.errors.full_messages
          redirect_to person.visit}
        format.json {render json: person.errors, status: :unprocessable_entity}
      end
    end
  end

  def confirm_visit
    @visit = Visit.find_by_token(params[:token])
    @visit.status = Visit::CONFIRMED
    respond_to do |format|
      if @visit.save
        @visit.send_confirmed_email
        @visit.send_confirm_email_technician
        format.html {redirect_to "/visits/token/#{params[:token]}", notice: 'Visita confirmada'}
        format.json {head :no_content}
      else
        format.html {
          flash[:alert] = @visit.errors.full_messages
          redirect_to "/visits/token/#{params[:token]}"
        }
        format.json {head :no_content}
      end
    end
  end

  def pre_approve
    @visit.status = Visit::PRE_APPROVED
    respond_to do |format|
      if @visit.save
        @visit.send_pre_approved_email
        format.html {redirect_to @visit, notice: 'Visita lista para aprobar'}
        format.json {head :no_content}
      else
        format.html {
          flash[:alert] = @visit.errors.full_messages
          redirect_to @visit
        }
        format.json {head :no_content}
      end
    end
  end


  def edit_visit_person
    @visit_person = VisitPerson.find(params[:visit_person_id])
    @is_token = params[:is_token] == 'true'
    render layout: false
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_visit
    @visit = Visit.find(params[:id])
  end

  def only_admin
    redirect_to '/visits' if !is_admin?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def visit_params
    params.require(:visit).permit(:department_id, :institution, :notes, :resp_name, :resp_phone, :resp_email, :requested_date, :transport_type, :status, :date, :reason, :career, :visit_type, :people_approx, :split_in_groups)
  end
end
