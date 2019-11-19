class ReleasesController < ApplicationController
  before_action :set_release, only: [:show, :edit, :update, :destroy]
  before_action :admin_filter, except: [:confirm]

  # GET /releases
  # GET /releases.json
  def index
    @releases = Release.all.order(created_at: :asc)
  end

  # GET /releases/1
  # GET /releases/1.json
  def show
  end

  # GET /releases/new
  def new
    @release = Release.new
  end

  # GET /releases/1/edit
  def edit
  end

  # POST /releases
  # POST /releases.json
  def create
    @release = Release.new(release_params)
    if @release.save
      flash[:success] = I18n.t :new_release_success
      redirect_to releases_path
    else
      render :new
    end
  end

  # PATCH/PUT /releases/1
  # PATCH/PUT /releases/1.json
  def update
    respond_to do |format|
      if @release.update(release_params)
        format.html { redirect_to @release, notice: 'Release was successfully updated.' }
        format.json { render :show, status: :ok, location: @release }
      else
        format.html { render :edit }
        format.json { render json: @release.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /releases/1
  # DELETE /releases/1.json
  def destroy
    @release.release_checks.each { |release_check| release_check.update(has_confirmed: true) }
  end

  def confirm
    release_check = ReleaseCheck.find params[:id]
    release_check.update(has_confirmed: true)
    redirect_to home_user_index_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_release
      @release = Release.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def release_params
      params.require(:release).permit(:name, :tag, :message, :is_active)
    end
end
