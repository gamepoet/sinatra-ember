require './lib/sinatra/ember'
Gem::Specification.new do |s|
  s.name        = 'sinatra-ember'
  s.version     = Sinatra::Ember.version
  s.summary     = 'Helpers for serving an Ember.js app from Sinatra.'
  s.description = 'Serves Ember Handlebars pages.'
  s.authors     = ['Ben Scott']
  s.email       = ['gamepoet@gmail.com']
  s.homepage    = 'http://github.com/gamepoet/sinatra-ember'
  s.files       = `git ls-files`.strip.split("\n")
  s.executables = Dir['bin/*'].map { |f| File.basename(f) }

  s.add_dependency 'sinatra'
end
