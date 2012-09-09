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


    migration = migrations.last
    migration = File.basename(migration, ".rb")

    parts = migration.split("_")
    migration_version = parts.shift
  end

  def self.get_migration_version_of_model(decp_model)
    migrations = Dir.glob Rails.root.join("db", "migrate", "*")

    migration_version = ""
    migrations.each do |migration|
      migration = File.basename(migration, ".rb")

      unless migration.include?("create_admin_module_"+decp_model.name.downcase)
        next
      end

      migration_version = migration.split("_").first
      break
    end

    migration_version
  end

  def self.create_full(decp_module_model)
    %x[rake db:migrate]
    migration_version = get_migration_version_of_model decp_module_model
    decp_module_model.migration_version = migration_version

    decp_module_model.save
  end

  def destroy_full
    require "rails/generators/base"

    begin
      rake_result = %x[rake db:migrate:down VERSION=#{self.migration_version}]
        #ActiveRecord::Base.transaction do
        #  ActiveRecord::Base.connection.execute("DROP TABLE admin_module_"+name.pluralize.downcase)
        #  ActiveRecord::Base.connection.execute("DELETE FROM schema_migrations WHERE version = "+self.migration_version)
        #end
    rescue Exception => e
      return
      # do nothing
    end
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

        module_args[module_name] = Hash.new
        if module_model.respond_to?("get_args")
          args = module_model.get_args
          if args.respond_to?("has_key?")
            module_args[module_name] = args
          end
        end
      end
    end


    threads = Hash.new
    module_models.each_pair do |module_name, module_model|
      threads[module_name] = Thread.new do

        response = Hash.new
        response[:details] = ""
        response[:success] = true
        begin
          response = module_model.fetch(module_args[module_name])
        rescue Exception => e
          response[:success] = false
          response[:details] << "Modul nema ispravno implementiranu metodu za dohvat podataka -- " << module_model.name << ".fetch(). "
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
        begin
          if records.respond_to?(:each)
            records.each do |record|
              record.save
            end
          else
            records.save
          end
        rescue Exception => e
          response[:success] = false
          response[:details] << module_models[module_name].name << ".fetch() vraca neispravno strukturirane podatke. "
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
        new_args = module_model.get_args
        if new_args.respond_to?("has_key?")
          args = new_args
        end
      end
    end

    success = true
    response = Hash.new
    response[:success] = true
    response[:details] = ""
    begin
      response = module_model.fetch(args)
    rescue Exception => e
      success = false
      response[:details] << "Modul nema implementiranu metodu za dohvat podataka -- " << module_model.name << ".fetch(): " << e.to_s << ". "
    end


    records = response[:records]

    ActiveRecord::Base.transaction do
      begin
        if records.respond_to?(:each)
          records.each do |record|
            record.save
          end
        else
          records.save
        end
      rescue Exception => e
        success = false
        response[:details] << module_model.name << ".fetch() vraca neispravno strukturirane podatke. "
      end
      Log.create(:admin_decp_module => self, :success => response[:success], :details => response[:details])
    end


  end
end
