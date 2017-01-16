require "rake/testtask"

Dir.glob("lib/tasks/*.rake").each { |r| import r }

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test
