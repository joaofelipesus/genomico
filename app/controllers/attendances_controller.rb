class AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]

  # GET /attendances
  # GET /attendances.json
  def index
    @attendances = Attendance.all
  end

  # GET /attendances/1
  # GET /attendances/1.json
  def show
  end

  # GET /attendances/new
  def new
    @attendance = Attendance.new
    @attendance.patient = Patient.find params[:id]
    @desease_stages = DeseaseStage.all.order :name
    @health_ensurances = HealthEnsurance.all.order :name
    @fields = Field.all.order :name
    @sample_kinds = SampleKind.all.order :name
  end

  # GET /attendances/1/edit
  def edit
  end

  # POST /attendances
  # POST /attendances.json
  def create
    @attendance = Attendance.new attendance_params
    if @attendance.save
      flash[:success] = 'Atendimento cadastrado com sucesso.'
      redirect_to json: {}, status: :created
    else
      render json: @attendance.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /attendances/1
  # PATCH/PUT /attendances/1.json
  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { redirect_to @attendance, notice: 'Attendance was successfully updated.' }
        format.json { render :show, status: :ok, location: @attendance }
      else
        @desease_stages = DeseaseStage.all.order :name
        @health_ensurances = HealthEnsurance.all.order :name
        format.html { render :workflow }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendances/1
  # DELETE /attendances/1.json
  def destroy
    @attendance.destroy
    respond_to do |format|
      format.html { redirect_to attendances_url, notice: 'Attendance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #GET attendances/1
  def workflow
    @attendance = Attendance.find params[:id]
    @desease_stages = DeseaseStage.all.order :name
    @health_ensurances = HealthEnsurance.all.order :name
  end

  def attendances_from_patient
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendance_params
      params.require(:attendance).permit(
        :desease_stage_id, 
        :cid_code, 
        :lis_code, 
        :start_date, 
        :finish_date, 
        :patient_id, 
        :attendance_status_kind_id, 
        :doctor_name, 
        :doctor_crm, 
        :observations, 
        :health_ensurance_id, 
        samples_attributes: [:sample_kind_id, :collection_date, :bottles_number, :storage_location], 
        exams_attributes: [:offered_exam_id],
      )
    end
end
