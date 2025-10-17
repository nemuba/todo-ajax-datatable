# frozen_string_literal: true

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = '--format documentation'
  end

  namespace :spec do
    desc 'Run model specs'
    RSpec::Core::RakeTask.new(:models) do |t|
      t.pattern = 'spec/models/**/*_spec.rb'
      t.rspec_opts = '--format documentation'
    end

    desc 'Run controller specs'
    RSpec::Core::RakeTask.new(:controllers) do |t|
      t.pattern = 'spec/controllers/**/*_spec.rb'
      t.rspec_opts = '--format documentation'
    end

    desc 'Run all specs with coverage'
    task :coverage do
      ENV['COVERAGE'] = 'true'
      Rake::Task['spec'].invoke
    end
  end

  task default: :spec
rescue LoadError
  # RSpec not available
end
