class ReagentsController < ApplicationController
  before_action :set_reagent, only: [:show, :edit, :update, :destroy]
  before_action :user_filter

  # GET /reagents
  # GET /reagents.json
  def index
    @reagents = Reagent.all
  end

  # GET /reagents/1
  # GET /reagents/1.json
  def show
  end

  # GET /reagents/new
  def new
    @reagent = Reagent.new
    @brands = Brand.all.order name: :asc
  end

  # GET /reagents/1/edit
  def edit
  end

  # POST /reagents
  # POST /reagents.json
  def create
    @reagent = Reagent.new(reagent_params)
    if params[:reagent][:belong_to_field] == "true"
      @reagent.field = User.includes(:fields).find(session[:user_id]).fields.first
    end
    if @reagent.save
      redirect_to @reagent
    else
      @brands = Brand.all.order name: :asc
      render :new
    end
  end

  # PATCH/PUT /reagents/1
  # PATCH/PUT /reagents/1.json
  def update
    respond_to do |format|
      if @reagent.update(reagent_params)
        format.html { redirect_to @reagent, notice: 'Reagent was successfully updated.' }
        format.json { render :show, status: :ok, location: @reagent }
      else
        format.html { render :edit }
        format.json { render json: @reagent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reagents/1
  # DELETE /reagents/1.json
  def destroy
    @reagent.destroy
    respond_to do |format|
      format.html { redirect_to reagents_url, notice: 'Reagent was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reagent
      @reagent = Reagent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reagent_params
      params.require(:reagent).permit(
        :product_description,
        :name,
        :stock_itens,
        :usage_per_test,
        :brand,
        :total_aviable,
        :field_id,
        :first_warn_at,
        :danger_warn_at,
        :mv_code,
        :product_code,
      )
    end
end
