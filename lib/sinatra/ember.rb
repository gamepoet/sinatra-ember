module Sinatra
  module Ember
    def self.version
      "0.0.2"
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
        ember.template_packages.each do |route, spec|
          get route do
            mtime, output = @template_cache.fetch(route) do
              # find all the template files
              paths = spec.globs.map do |glob|
                glob = File.expand_path(File.join(settings.root, glob))
                Dir[glob].map { |x| x.squeeze('/') }
              end

              # define the portion of the path to remove
              remove = settings.root
              if spec.opts[:relative_to].empty?
                remove = settings.root
              else
                remove = File.join(remove, spec.opts[:relative_to])
              end
              remove = File.expand_path(remove)

              # build up the javascript
              templates = paths.map do |files|
                files.map do |file|
                  # derive the template name
                  tmpl_name = file.sub(/\.(handlebars|hbs|hjs)$/, '')
                  if settings.ember.template_name_style == :path
                    tmpl_name.sub!(/^#{Regexp.quote(remove)}\//, '')
                  else
                    tmpl_name = File.basename(tmpl_name)
                  end

                  # add the template content
                  content = File.read(file)
                  "Ember.TEMPLATES[#{tmpl_name.inspect}] = Ember.Handlebars.compile(#{content.inspect});"
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
              mtime = paths.flatten.map do |path|
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
    end

    class Options
      attr_reader :template_packages

      def initialize(app, &block)
        @app = app
        @template_name_style = :path
        @template_packages = {}

        instance_eval(&block)
      end

      def templates(route, files=[], opts={})
        opts_defaults = {
          :relative_to => '',
        }
        opts = opts_defaults.merge(opts)
        @template_packages[route] = TemplateSpec.new(route, files, opts)
      end

      def template_name_style(*args)
        val = args.first
        if not val.nil?
          @template_name_style = val
        end
        return @template_name_style
      end
      alias :template_name_style= :template_name_style
    end

    class TemplateSpec
      attr_accessor :route, :globs, :opts

      def initialize(route, globs, opts)
        @route = route
        @globs = globs
        @opts = opts
      end
    end
  end
end
