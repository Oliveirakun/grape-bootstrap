require 'bundler'
require 'active_record'
require 'yaml'

# Temporary switch to blank rake app, extract required tasks and import them to
# current rake task. Skip seed loader here, as we do not need it for tests.
# More info on AR tasks import: @see https://gist.github.com/drogus/6087979

def import_active_record_tasks(default_rake_app)
  Rake.application = Rake::Application.new
  Rake.application.rake_require('active_record/railties/databases')

  # Customize AR database tasks

  include ActiveRecord::Tasks

  db_dir                               = File.expand_path('../../../db', __FILE__)
  db_config_path                       = File.expand_path('config/database.yml')
  migrations_path                      = "#{db_dir}/migrate"
  environment                          = ENV['RACK_ENV'] || 'development'

  # WARNING! This MUST be a String not a Symbol
  DatabaseTasks.env                    = environment
  DatabaseTasks.db_dir                 = db_dir
  DatabaseTasks.database_configuration = YAML.load_file(db_config_path)
  DatabaseTasks.migrations_paths       = [migrations_path]

  # Several AR tasks rely (but do not include) on this task internally (like :create)
  # Here we establish connection. The first line is actually exists in :load_config
  # which is called AFTER :environment. And because we have custom :environment
  # task and want to connect, we copy that first line here.
  # Not the best solution, but don't have time dig deeper
  Rake::Task.define_task(:environment) do
    ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
    # Use Symbol or you'll get deprecation warning
    ActiveRecord::Base.establish_connection(DatabaseTasks.env.to_sym)
  end

  tasks_to_import = %w[db:create db:drop db:purge db:rollback db:migrate
    db:migrate:up db:migrate:down db:migrate:status db:version db:schema:load db:schema:dump]

  imported_tasks   = Rake.application.tasks.select do |task|
    tasks_to_import.include?(task.name)
  end

  # Restore default rake app
  Rake.application = default_rake_app

  # NOTE: didn't found a way to just use something like this tasks.define(task)
  imported_tasks.each do |task|
    # import description
    Rake.application.last_description = task.comment
    # import task
    Rake::Task.define_task(task.name) { task.invoke }
  end
end

import_active_record_tasks(Rake.application)
