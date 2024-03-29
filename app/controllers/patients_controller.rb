class PatientsController < ApplicationController
  include InstanceVariableSetter
  before_action :set_patient, only: [:show, :edit, :update]
  before_action :user_filter
  before_action :set_hospitals, only: [:new, :edit]
  before_action :set_sample_kinds, only: [:samples_from_patient]
  before_action :set_subsample_kinds, only: [:samples_from_patient]

  # GET /patients
  # GET /patients.json
  def index
    name = params[:name_search]
    medical_record = params[:medical_record]
    if name.present?
      patients = Patient.where("name ILIKE ?", "%#{name}%")
    elsif medical_record.present?
      patients = Patient.where(medical_record: medical_record)
    else
      patients = Patient.all
    end
    @patients = patients.order(:name).page params[:page]
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
    redirect_to patient_path(@patient, patient: true) unless params[:samples].present? or params[:patient].present? or params[:attendance].present? or params[:exams].present?
    samples_from_patient if params[:samples].present?
  end

  # GET /patients/new
  def new
    @patient = Patient.new
  end

  # GET /patients/1/edit
  def edit
  end

  # POST /patients
  # POST /patients.json
  def create
    @patient = Patient.new(patient_params)
      if @patient.save
        flash[:success] = I18n.t :new_patient_success
        redirect_to new_attendance_path(patient: @patient)
      else
        set_hospitals
        render :new
    end
  end

  # PATCH/PUT /patients/1
  # PATCH/PUT /patients/1.json
  def update
    if @patient.update(patient_params)
      flash[:success] = I18n.t :edit_patient_success
      redirect_after_update
    else
      set_hospitals
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.includes(:samples, :subsamples, :attendances).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(:name, :birth_date, :mother_name, :medical_record, :hospital_id, :observations)
    end

    def redirect_after_update
      attendance_id = params[:attendance]
      if attendance_id.present?
        attendance = Attendance.find attendance_id
        redirect_to attendance_path(attendance)
      else
        redirect_to home_path
      end
    end

    def samples_from_patient
      search_by_sample_kind = params[:sample_kind]
      search_by_subsample_kind = params[:subsample_kind]
      if search_by_sample_kind.present?
        @samples = @patient.samples.where(sample_kind_id: search_by_sample_kind).order(:created_at)
        @display = 'SAMPLE'
      elsif search_by_subsample_kind.present?
        @subsamples = @patient.subsamples.where(subsample_kind_id: search_by_subsample_kind).order(:created_at)
        @display = 'SUBSAMPLE'
      else
        @samples = @patient.samples.order(:created_at)
        @display = 'ALL'
      end
    end
end
