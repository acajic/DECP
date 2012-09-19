class Admin::DecpModule < ActiveRecord::Base
  has_many :logs


  def set_migration_version(module_name)
    migrations = Dir.glob Rails.root.join("db", "migrate", "*")
    migrations.sort

    migration = migrations.last
    migration = File.basename(migration, ".rb")

    parts = migration.split("_")
    migration_version = parts.shift

    ActiveRecord::Base.connection.execute("UPDATE admin_decp_modules SET migration_version = '" + migration_version + "' WHERE name = '" + module_name + "'")
  end

  def self.get_migration_version_of_model(decp_model)
    # prema nazivu modula, traži koji je njegov migration_version broj

    migrations = Dir.glob Rails.root.join("db", "migrate", "*")

    migration_version = ""
    migrations.each do |migration|
      # od stringa odbaci nastavak .rb
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
    # migraciju koja je stvorena u db/migrate folderu treba izvršiti da se baza ažurira
    %x[rake db:migrate]
    # nakon što je migracija izvršena, treba zapisati njen broj kako bi se mogla poništiti ako se modul briše
    migration_version = get_migration_version_of_model(decp_module_model)
    decp_module_model.migration_version = migration_version

    decp_module_model.save
  end

  def destroy_full
    require "rails/generators/base"

    begin
      # poništavaju se efekti koje je modul napravio na bazu kad je bio stvoren
      rake_result = %x[rake db:migrate:down VERSION=#{self.migration_version}]
        #ActiveRecord::Base.transaction do
        #  ActiveRecord::Base.connection.execute("DROP TABLE admin_module_"+name.pluralize.downcase)
        #  ActiveRecord::Base.connection.execute("DELETE FROM schema_migrations WHERE version = "+self.migration_version)
        #end
    rescue Exception => e
      return
      # do nothing
    end

    # briše se zapis iz glavne tablice
    destroy

    # objekt za izvršavanje Rails skripti
    gen = Rails::Generators::Base.new

    # brišu se pomoćni fajlovi, controller i html-ovi
    gen.run("rails destroy scaffold Admin::Module" + name.camelcase)
  end

  # statička metoda, za upošljavanje svih aktivnih modula
  def self.fetch(params)


    # dohvaća module koji su aktivni
    modules = Admin::DecpModule.where("active = true")

    decp_models = Hash.new
    module_models = Hash.new
    module_args = Hash.new


    # u jednoj transakciji obavljaju se get_args metode svih modula i pospremaju u module_args
    ActiveRecord::Base.transaction do
      modules.each do |modul|
        module_name = "module_" + modul.name
        # dinamičko određivanje razreda modula
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

        if params.is_a?(Hash)
          module_args[module_name].merge!(params.symbolize_keys)
        end
      end
    end


    threads = Hash.new
    module_models.each_pair do |module_name, module_model|
      # za svaki prisutni modul, pokreni dretvu
      threads[module_name] = Thread.new do

        response = Hash.new
        response[:details] = ""
        response[:success] = true
        begin
          # pokreni fetch metodu pripadnog modula
          response = module_model.fetch(module_args[module_name])
        rescue Exception => e
          response[:success] = false
          response[:details] << "Modul nema ispravno implementiranu metodu za dohvat podataka -- " << module_model.name << ".fetch(). "
        end

        # rezultantna vrijednost izvođenja dretve
        response
      end
    end

    responses = Hash.new
    # pokupi rezultate svih dretvi
    threads.each_pair do |module_name, thread|
      # thread.value čeka izvršenje dretve i vraća njezinu rezultantnu vrijednost
      responses[module_name] = thread.value
    end

    ActiveRecord::Base.transaction do
      # svaki modul vratio je jednu rezultantnu vrijednost
      responses.each_pair do |module_name, response|
        # rezultantne vrijednosti potrebno je pohraniti u bazu
        # pohrana se obavlja unutar iste transakcije
        records = response[:records]
        begin
          if records.respond_to?(:each)
            # ako rezultantna vrijednost sadrži više zapisa
            records.each do |record|
              record.save
            end
          else
            # rezultantna vrijednost sadrži jedan zapis
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

  # metoda instance, za upošljavanje samo jednog od modula
  def fetch(params)
    modul_name = "module_" + name
    # dinamičko određivanje razreda modula
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

    if params.is_a?(Hash)
      # argumenti proslijeđeni kroz url imaju veći prioritet od argumenata koje priskrbljuje get_args metoda
      # merge će spojiti dva Hash-a, a ako postoje isti ključevi uzet će se ona vrijednost iz drugog Hash-a
      args.merge!(params.symbolize_keys)
    end


    response = Hash.new
    response[:success] = false
    response[:details] = ""
    begin
      response = module_model.fetch(args)
    rescue Exception => e
      response[:details] << "Modul nema implementiranu metodu za dohvat podataka -- " << module_model.name << ".fetch(): " << e.to_s << ". "
    end


    records = response[:records]

    ActiveRecord::Base.transaction do
      begin
        if records.respond_to?(:each)
          # ako rezultantna vrijednost sadrži više zapisa
          records.each do |record|
            record.save
          end
        else
          # rezultantna vrijednost sadrži jedan zapis
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
