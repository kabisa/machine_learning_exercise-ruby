require 'active_record'

namespace :db do
  task :establish_connection do
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'machine_learning.sqlite3'
  end

  desc 'Migrate the database'
  task :migrate => :establish_connection do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate 'lib/migrations', ENV['VERSION'] ? ENV['VERSION'].to_i : nil
  end

  desc 'Roll the schema back to the previous version.'
  task :rollback => :establish_connection do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback 'lib/migrations', step
  end
end
