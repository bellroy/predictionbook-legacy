unless ENV['IGNORE_MIGRATION_CHECK'] == 'yes'
  begin
    run_migrations = ActiveRecord::Migrator.get_all_versions

    missing_migrations = []

    Dir["#{Rails.root}/db/migrate/*"].map do |path|
      migration = path.match(%r{migrate/(\d+)})[1].to_i
      missing_migrations << migration unless run_migrations.include?(migration)
    end

    unless missing_migrations.empty?
      abort "Pending migrations: #{missing_migrations.sort.join(', ')}"
    end
  rescue StandardError => e
    puts "Could not check whether migrations are up to date: #{e.to_s}"
  end
end
