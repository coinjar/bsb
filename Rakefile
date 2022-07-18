# frozen_string_literal: true

require 'bundler/gem_tasks'
load 'lib/tasks/bsb_tasks.rake'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new

desc 'Run tests'
task default: :'rubocop:auto_correct'
task default: :test
