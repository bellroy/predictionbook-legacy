# NOTE: http://www.dcmanges.com/blog/modifying-rake-tasks would be much better
# if the code didn't have to run before :environment
Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end
 
def remove_task(task_name)
  Rake.application.remove_task(task_name)
end

namespace :db do
  def dbconf
    @conf ||= Rails::Configuration.new.database_configuration[RAILS_ENV]
  end
  
  desc "Delete all private predictions from database"
  task :drop_private_predictions => :environment do
    abort "Won't drop prediction if not in development environment! Currently '#{Rails.env}'" unless Rails.env.development?
    Prediction.all.select(&:private?).each(&:destroy)
  end
  
  def task_ignoring_migration_check(name)
    migrate_task = Rake::Task[name] 
    remove_task name
    task_basename = name[/:([^:]+$)/,1]
    desc migrate_task.comment
    task task_basename.to_sym do
      
      migrate_task.invoke
    end
  end

  %w(db:drop db:create db:migrate).each(&method(:task_ignoring_migration_check))
  namespace :migrate do
    %w[db:migrate:down db:migrate:up db:migrate:redo db:migrate:reset].each(&method(:task_ignoring_migration_check))
  end
  namespace :test do
    %w[db:test:clone db:test:prepare].each(&method(:task_ignoring_migration_check))
  end
end
