require 'rake'
require 'rake/testtask'
require 'rdoc/task'

desc 'Default: run unit tests.'
task :default => :test

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = 'ruby-tmdb3'
    gemspec.summary = 'An ActiveRecord-style API wrapper for TheMovieDB.org'
    gemspec.description = 'An ActiveRecord-style API wrapper for TheMovieDB.org'
    gemspec.email = 'iirineu@gmail.com'
    gemspec.homepage = 'https://github.com/Irio/ruby-tmdb'
    gemspec.authors = ['Irio Irineu Musskopf Junior', 'Aaron Gough']
    gemspec.rdoc_options << '--line-numbers' << '--inline-source'
    gemspec.extra_rdoc_files = %w(README.rdoc MIT-LICENSE)
    gemspec.add_dependency( 'deepopenstruct', '>= 0.1.2')
    gemspec.add_dependency('json')
    gemspec.add_dependency 'addressable'
    gemspec.add_development_dependency 'webmock'
  end
rescue LoadError
  puts 'Jeweler not available. Install it with: gem install jeweler'
end


desc 'Test ruby-tmdb3.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib/*.rb'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end


desc 'Generate documentation for ruby-tmdb3.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ruby-tmdb3'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include('app/**/*.rb')
end
