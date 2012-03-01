module Sinatra
  module Ember
    def self.version
      "0.0.1"
    end

    def self.registered(app)
      app.extend ClassMethods
    end

    module ClassMethods
      # serves ember handlebars templates at the given path
      def serve_templates(path)
        get path do
          content_type :js

          # find all the template files
          template_files = {}
          Dir.chdir(settings.views) do
            Dir['**/*.hbs'].map do |filename|
              filename =~ /^(.*)\.hbs$/
              name = $1
              template_files[name] = File.join(settings.views, filename)
            end
          end

          # build up the javascript
          templates = template_files.map do |(name, file)|
            content = File.read(file)
            "Ember.TEMPLATES[#{name.inspect}] = Ember.Handlebars.compile(#{content.inspect});"
          end

          # wrap it up in a closure
          output = %{
            (function() {
              #{templates.join("\n")}
            })();
          }
          output.strip.gsub(/^ {12}/, '')
        end
      end
    end
  end
end
