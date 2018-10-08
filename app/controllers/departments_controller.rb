class DepartmentsController < ApplicationController
  def index
    @deparments = Department.all
  end

  def new
    @department = Department.new
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to departments_path, notice: 'Departamento actualizado' }
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @department = Department.new(department_params)
    respond_to do |format|
      if @department.save
        format.html { redirect_to departments_path, notice: 'Departamento actualizado' }
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def department_params
    params.require(:department).permit(:name, :assistant_email)
  end
end
