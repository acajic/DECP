class Admin::ModuleRatesController < ApplicationController
  # GET /admin/module_rates
  # GET /admin/module_rates.json
  def index
    @admin_module_rates = Admin::ModuleRate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_module_rates }
    end
  end

  # GET /admin/module_rates/1
  # GET /admin/module_rates/1.json
  def show
    @admin_module_rate = Admin::ModuleRate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_module_rate }
    end
  end

  # GET /admin/module_rates/new
  # GET /admin/module_rates/new.json
  def new
    @admin_module_rate = Admin::ModuleRate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_module_rate }
    end
  end

  # GET /admin/module_rates/1/edit
  def edit
    @admin_module_rate = Admin::ModuleRate.find(params[:id])
  end

  # POST /admin/module_rates
  # POST /admin/module_rates.json
  def create
    @admin_module_rate = Admin::ModuleRate.new(params[:admin_module_rate])

    respond_to do |format|
      if @admin_module_rate.save
        format.html { redirect_to @admin_module_rate, notice: 'Module rate was successfully created.' }
        format.json { render json: @admin_module_rate, status: :created, location: @admin_module_rate }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_module_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/module_rates/1
  # PUT /admin/module_rates/1.json
  def update
    @admin_module_rate = Admin::ModuleRate.find(params[:id])

    respond_to do |format|
      if @admin_module_rate.update_attributes(params[:admin_module_rate])
        format.html { redirect_to @admin_module_rate, notice: 'Module rate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_module_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/module_rates/1
  # DELETE /admin/module_rates/1.json
  def destroy
    @admin_module_rate = Admin::ModuleRate.find(params[:id])
    @admin_module_rate.destroy

    respond_to do |format|
      format.html { redirect_to admin_module_rates_url }
      format.json { head :no_content }
    end
  end
end
