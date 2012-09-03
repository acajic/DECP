class Admin::DecpModule < ActiveRecord::Base
  has_many :logs

  def self.refresh_migration_versions
    migrations = Dir.glob Rails.root.join("db", "migrate", "*")

    model_version = Hash.new

    migrations.each do |migration|
      migration = File.basename(migration, ".rb")

      parts = migration.split("_")
      migration_version = parts.shift

      create = parts.shift
      admin = parts.shift
      modul = parts.shift

      if create == "create" and admin == "admin" and modul == "module"
        module_name = parts.join("_")
        model_version[module_name] = migration_version
      end
    end

    ActiveRecord::Base.transaction do
      model_version.each_pair do |module_name, version|
        ActiveRecord::Base.connection.execute("UPDATE admin_decp_modules SET migration_version = '" + version + "' WHERE name = '" + module_name + "'")
      end
    end
  end

  def set_migration_version(module_name)
    migrations = Dir.glob Rails.root.join("db", "migrate", "*")
    migrations.sort

    migration = migrations.last
    migration = File.basename(migration, ".rb")

    parts = migration.split("_")
    migration_version = parts.shift

    ActiveRecord::Base.connection.execute("UPDATE admin_decp_modules SET migration_version = '" + migration_version + "' WHERE name = '" + module_name + "'")
  end

  def self.get_last_migration_version
    migrations = Dir.glob Rails.root.join("db", "migrate", "*")
    migrations.sort

    migration = migrations.last
    migration = File.basename(migration, ".rb")

    parts = migration.split("_")
    migration_version = parts.shift
  end

  def self.create_full(decp_module_model)
    %x[rake db:migrate]
    migration_version = get_last_migration_version
    decp_module_model.migration_version = migration_version
    decp_module_model.save
  end

  def destroy_full
    require "rails/generators/base"
    rake_result = %x[rake db:migrate:down VERSION=#{migration_version}]
    destroy
    gen = Rails::Generators::Base.new
    gen.run("rails destroy scaffold Admin::Module" + name.camelcase)
  end

  def self.fetch
    # modules = Dir.glob Rails.root.join("app", "models", "admin", "*")
    modules = Admin::DecpModule.where("active = true")

    decp_models = Hash.new
    module_models = Hash.new
    module_args = Hash.new
    ActiveRecord::Base.transaction do
      modules.each do |modul|
        module_name = "module_" + modul.name
        module_model = Admin.const_get(module_name.singularize.camelcase)
        module_models[module_name] = module_model
        decp_models[module_name] = modul
        module_args[module_name] = module_model.respond_to?("get_args") ? module_model.get_args : Hash.new
      end
    end


    threads = Hash.new
    module_models.each_pair do |module_name, module_model|
      response = Hash.new
      threads[module_name] = Thread.new do
        success = true
        details = ""
        begin
          response = module_model.fetch(module_args[module_name])
        rescue Exception => e
          success = false
          details = e
        ensure
          response[:success] = success
          response[:details] = details
        end

        response
      end
    end

    responses = Hash.new
    threads.each_pair do |module_name, thread|
      responses[module_name] = thread.value
    end

    ActiveRecord::Base.transaction do
      responses.each_pair do |module_name, response|
        records = response[:records]
        records.each do |record|
          record.save
        end
        Log.create(:admin_decp_module => decp_models[module_name], :success => response[:success], :details => response[:details])
      end
    end
  end

  def fetch
    modul_name = "module_" + name
    module_model = Admin.const_get(modul_name.singularize.camelcase)

    args = Hash.new
    if  module_model.respond_to?("get_args")
      ActiveRecord::Base.transaction do
        args = module_model.get_args
      end
    end

    response = module_model.fetch(args)

    records = response[:records]
    ActiveRecord::Base.transaction do
      records.each do |record|
        record.save
      end
      Log.create(:admin_decp_module => self, :success => response[:success], :details => response[:details])
    end

  end
end
