# frozen_string_literal: true

require 'test_helper'
require 'rake'
require 'fileutils'

describe 'bsb tasks rake task', type: :task do
  before(:all) do
    Rake.application.rake_require('../lib/tasks/bsb_tasks')
    Rake::Task.define_task(:environment)
  end

  describe 'fetch_key_file' do
    let(:task_name) { 'bsb:fetch_key_file' }
    let(:task) { Rake::Task[task_name] }
    let(:output_path) { 'tmp/test_key.csv' }

    before do
      FileUtils.rm_f(output_path)
      task.reenable # so it can be invoked multiple times
    end

    after { FileUtils.rm_f(output_path) }

    describe 'when fetching the CSV', :vcr do
      it 'downloads and saves the file successfully' do
        VCR.use_cassette('fetch_key_file') do
          assert(!File.exist?(output_path))

          output = capture_stdout { task.invoke(output_path) }

          assert(output.include?('Fetching CSV'))
          assert(File.exist?(output_path))

          content = File.read(output_path)
          assert(content.include?('BSB'))
          assert(!content.empty?)
        end
      end
    end
  end

  # Helper to capture puts output
  def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end
end
