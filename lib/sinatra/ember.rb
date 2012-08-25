module Sinatra
  module Ember
    def self.version
      "0.0.1"
    end

    def self.registered(app)
      app.extend ClassMethods
    end

    module ClassMethods
      # set ember options
      def ember(&block)
        @ember_options ||= Options.new(self, &block)
        self.ember_init! if block_given?
        @ember_options
      end

      def ember_init!
        ember.template_packages.each do |route, globs|
          get route do
            mtime, output = @template_cache.fetch(route) do
              # find all the template files
              paths = globs.map do |glob|
                files = Dir[glob+"/**/*.{handlebars,hbs,hjs}"].map { |x| x.squeeze('/') }
                [glob, files.flatten]
              end

              # build up template hash
              #template_paths = {}
              #paths.each do |path|
              #  template_paths[File.basename(path, '.hbs')] = path
              #end

              # build up the javascript
              templates = paths.map do |path, files|
                files.map do |file|
                  content = File.read(file)
                  "Ember.TEMPLATES[#{template_path(path,file)}] = Ember.Handlebars.compile(#{content.inspect});"
                end
              end

              # wrap it up in a closure
              output = %{
                (function() {
                  #{templates.join("\n")}
                })();
              }
              output = output.strip.gsub(/^ {16}/, '')

              # compute the maximum mtime for all paths
              mtime = paths.map do |path|
                if File.file?(path)
                  File.mtime(path).to_i
                end
              end.compact.max

              [mtime, output]
            end

            content_type :js
            last_modified mtime
            output
          end
        end
      end
      def template_path(path, file)

        unless root.blank?
          file.gsub!(/^#{Regexp.quote(path)}\/?/, '')
        end

        file
      end
    end

    class Options
      attr_reader :template_packages

      def initialize(app, &block)
        @app = app
        @template_packages = {}

        instance_eval(&block)
      end

      def templates(route, files=[])
        @template_packages[route] = files
      end
    end
  end
end
