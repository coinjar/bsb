# frozen_string_literal: true

require 'bundler/gem_tasks'
load 'lib/tasks/bsb_tasks.rake'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
end

desc 'Run tests'
task default: :test
