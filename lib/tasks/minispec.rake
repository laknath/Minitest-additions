# Don't load rspec if running "rake gems:*"
unless ARGV.any? {|a| a =~ /^gems/}

Rake.application.instance_variable_get('@tasks').delete('default')

spec_prereq = File.exist?(File.join(RAILS_ROOT, 'config', 'database.yml')) ? "db:test:prepare" : :noop

task :default => :spec
task :stats => "spec:statsetup"

desc "Run all specs in spec directory (excluding plugin specs)"
Rake::TestTask.new(:spec => spec_prereq) do |t|
  #t.options = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
  t.test_files = FileList['spec/**/*_spec.rb']
end

namespace :spec do
  desc "Print Specdoc for all specs (excluding plugin specs)"
  Rake::TestTask.new(:doc) do |t|
    t.options = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
    t.test_files = FileList['spec/**/*_spec.rb']
  end

  desc "Print Specdoc for all plugin examples"
  Rake::TestTask.new(:plugin_doc) do |t|
    t.options = ["--format", "specdoc", "--dry-run"]
    t.test_files = FileList['vendor/plugins/**/spec/**/*_spec.rb']
  end

  [:models, :controllers, :views, :helpers, :lib, :integration].each do |sub|
    desc "Run the code examples in spec/#{sub}"
    Rake::TestTask.new(sub => spec_prereq) do |t|
      #t.options = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
      t.test_files = FileList["spec/#{sub}/**/*_spec.rb"]
    end
  end

  desc "Run the code examples in vendor/plugins"
  Rake::TestTask.new(:plugins => spec_prereq) do |t|
    #t.options = ['--options', "\"#{RAILS_ROOT}/spec/spec.opts\""]
    t.test_files = FileList['vendor/plugins/**/spec/**/*_spec.rb']
  end

  # Setup specs for stats
  task :statsetup do
    require 'code_statistics'
    ::STATS_DIRECTORIES << %w(Model\ specs spec/models) if File.exist?('spec/models')
    ::STATS_DIRECTORIES << %w(View\ specs spec/views) if File.exist?('spec/views')
    ::STATS_DIRECTORIES << %w(Controller\ specs spec/controllers) if File.exist?('spec/controllers')
    ::STATS_DIRECTORIES << %w(Helper\ specs spec/helpers) if File.exist?('spec/helpers')
    ::STATS_DIRECTORIES << %w(Library\ specs spec/lib) if File.exist?('spec/lib')
    ::STATS_DIRECTORIES << %w(Routing\ specs spec/routing) if File.exist?('spec/routing')
    ::STATS_DIRECTORIES << %w(Integration\ specs spec/integration) if File.exist?('spec/integration')
    ::CodeStatistics::TEST_TYPES << "Model specs" if File.exist?('spec/models')
    ::CodeStatistics::TEST_TYPES << "View specs" if File.exist?('spec/views')
    ::CodeStatistics::TEST_TYPES << "Controller specs" if File.exist?('spec/controllers')
    ::CodeStatistics::TEST_TYPES << "Helper specs" if File.exist?('spec/helpers')
    ::CodeStatistics::TEST_TYPES << "Library specs" if File.exist?('spec/lib')
    ::CodeStatistics::TEST_TYPES << "Routing specs" if File.exist?('spec/routing')
    ::CodeStatistics::TEST_TYPES << "Integration specs" if File.exist?('spec/integration')
  end

  namespace :db do
    namespace :fixtures do
      desc "Load fixtures (from spec/fixtures) into the current environment's database.  Load specific fixtures using FIXTURES=x,y. Load from subdirectory in test/fixtures using FIXTURES_DIR=z."
      task :load => :environment do
        ActiveRecord::Base.establish_connection(Rails.env)
        base_dir = File.join(Rails.root, 'spec', 'fixtures')
        fixtures_dir = ENV['FIXTURES_DIR'] ? File.join(base_dir, ENV['FIXTURES_DIR']) : base_dir

        require 'active_record/fixtures'
        (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/).map {|f| File.join(fixtures_dir, f) } : Dir.glob(File.join(fixtures_dir, '*.{yml,csv}'))).each do |fixture_file|
          Fixtures.create_fixtures(File.dirname(fixture_file), File.basename(fixture_file, '.*'))
        end
      end
    end
  end
end
end
