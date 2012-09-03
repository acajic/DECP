class Admin::DecpModulesController < ApplicationController

  # GET /admin/decp_modules
  # GET /admin/decp_modules.json
  def index
    @admin_decp_modules = Admin::DecpModule.all
    # @kras = params[:admin_decp_module].nil? ? "" : params[:admin_decp_module][:name]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_decp_modules }
    end
  end

  # GET /admin/decp_modules/1
  # GET /admin/decp_modules/1.json
  def show
    @admin_decp_module = Admin::DecpModule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_decp_module }
    end
  end

  # GET /admin/decp_modules/new
  # GET /admin/decp_modules/new.json
  def new
    @admin_decp_module = Admin::DecpModule.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_decp_module }
    end
  end

  # GET /admin/decp_modules/1/edit
  def edit
    @admin_decp_module = Admin::DecpModule.find(params[:id])
  end

  # POST /admin/decp_modules
  # POST /admin/decp_modules.json
  def create
    @admin_decp_module = Admin::DecpModule.new(params[:admin_decp_module])

    @data_types = %w[boolean date datetime decimal integer string time]

    respond_to do |format|
      format.html { render action: "create_form" }
      # format.json { render json: @admin_decp_module.errors, status: :unprocessable_entity }
    end
  end


# PUT /admin/decp_modules/1
# PUT /admin/decp_modules/1.json
  def update
    @admin_decp_module = Admin::DecpModule.find(params[:id])


    respond_to do |format|
      if @admin_decp_module.update_attributes(params[:admin_decp_module])
        format.html { redirect_to @admin_decp_module, notice: 'Decp module was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_decp_module.errors, status: :unprocessable_entity }
      end
    end
  end

# DELETE /admin/decp_modules/1
# DELETE /admin/decp_modules/1.json
  def destroy
    @admin_decp_module = Admin::DecpModule.find(params[:id])
    @admin_decp_module.destroy_full

    respond_to do |format|
      format.html { redirect_to admin_decp_modules_url }
      format.json { head :no_content }
    end
  end

  def create_form
    require "rails/generators/base"

    @data_types = %w[boolean date datetime decimal integer string time]

    @admin_decp_module = Admin::DecpModule.new(params[:admin_decp_module])


    # Rails::Generators.invoke("active_record:model", ["foo"])


    gen = Rails::Generators::Base.new

    #gen.run("rails destroy scaffold Admin::ModuleTemperature")

    command = "rails generate scaffold Admin::Module" + @admin_decp_module.name.camelcase + " "

    field_names = params[:fieldname]
    field_names.delete("1")
    field_names.each_pair do |k, field_name|
      if field_name.empty?
        break
      end
      field_type = params[:fieldtype][k]
      command += field_name + ":" +field_type + " "
    end

    gen.run command

    Admin::DecpModule.create_full(:name => @admin_decp_module.name)

    respond_to do |format|
      format.html { redirect_to action: "index", notice: "Module was successfully created!" }
    end

  end

  def fetch
    unless params[:id].nil?
      return fetch_individual(params[:id])
    end

    Admin::DecpModule.fetch

    redirect_to(url_for(:action => "index"), {:notice => "Data retrieval complete!"})
  end

  def fetch_individual(id)
    # modules = Dir.glob Rails.root.join("app", "models", "admin", "*")
    Admin::DecpModule.find_by_id(id).fetch

    redirect_to(url_for(:action => "index"), {:notice => "Data retrieval complete!"})
    #    redirect_to action: "index", :notice => "Data retrieval complete!"
  end
end