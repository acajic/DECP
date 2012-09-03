class Admin::ModuleWeathersController < ApplicationController
  # GET /admin/module_weathers
  # GET /admin/module_weathers.json
  def index
    @admin_module_weathers = Admin::ModuleWeather.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_module_weathers }
    end
  end

  # GET /admin/module_weathers/1
  # GET /admin/module_weathers/1.json
  def show
    @admin_module_weather = Admin::ModuleWeather.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_module_weather }
    end
  end

  # GET /admin/module_weathers/new
  # GET /admin/module_weathers/new.json
  def new
    @admin_module_weather = Admin::ModuleWeather.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_module_weather }
    end
  end

  # GET /admin/module_weathers/1/edit
  def edit
    @admin_module_weather = Admin::ModuleWeather.find(params[:id])
  end

  # POST /admin/module_weathers
  # POST /admin/module_weathers.json
  def create
    @admin_module_weather = Admin::ModuleWeather.new(params[:admin_module_weather])

    respond_to do |format|
      if @admin_module_weather.save
        format.html { redirect_to @admin_module_weather, notice: 'Module weather was successfully created.' }
        format.json { render json: @admin_module_weather, status: :created, location: @admin_module_weather }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_module_weather.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/module_weathers/1
  # PUT /admin/module_weathers/1.json
  def update
    @admin_module_weather = Admin::ModuleWeather.find(params[:id])

    respond_to do |format|
      if @admin_module_weather.update_attributes(params[:admin_module_weather])
        format.html { redirect_to @admin_module_weather, notice: 'Module weather was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_module_weather.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/module_weathers/1
  # DELETE /admin/module_weathers/1.json
  def destroy
    @admin_module_weather = Admin::ModuleWeather.find(params[:id])
    @admin_module_weather.destroy

    respond_to do |format|
      format.html { redirect_to admin_module_weathers_url }
      format.json { head :no_content }
    end
  end
end
