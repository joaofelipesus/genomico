class HospitalsController < ApplicationController
  before_action :set_hospital, only: [:show, :edit, :update, :destroy]
  before_action :user_filter


  # GET /hospitals
  # GET /hospitals.json
  def index
    @hospitals = Hospital.all.order :name
  end

  # GET /hospitals/1
  # GET /hospitals/1.json
  def show
  end

  # GET /hospitals/new
  def new
    @hospital = Hospital.new
  end

  # GET /hospitals/1/edit
  def edit
  end

  # POST /hospitals
  # POST /hospitals.json
  def create
    @hospital = Hospital.new(hospital_params)
    if @hospital.save
      flash[:success] = 'Hospital cadastrado com sucesso.'
      redirect_to hospitals_path
    else
      render :new
    end
  end

  # PATCH/PUT /hospitals/1
  # PATCH/PUT /hospitals/1.json
  def update
    if @hospital.update(hospital_params)
      flash[:success] = 'Hospital editado com sucesso.'
      redirect_to hospitals_path
    else
      render :new
    end
  end

  # DELETE /hospitals/1
  # DELETE /hospitals/1.json
  def destroy
    redirect_to hospitals_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hospital
      @hospital = Hospital.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hospital_params
      params.require(:hospital).permit(:name)
    end
end
