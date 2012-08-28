# Sinatra Ember

Helpers for serving an [Ember.js][ember] app from [Sinatra][sinatra].

- Pre-compile handlebars templates from separate view files rather than
  littering them throughout your html.


## Installation

You can install Sinatra Ember as a Ruby gem. You can install it via `gem
install`.

``` console
$ gem install sinatra-ember
```

### Bundler users

If you use Bundler, add it to your *Gemfile.*

``` ruby
gem 'sinatra-ember', :require => 'sinatra/ember'
```


## Setup

Install the plugin and add some options.

``` ruby
require 'sinatra/ember'

class App < Sinatra::Base
  register Sinatra::Ember
  ember {
    templates '/js/templates.js', ['app/templates/**/*.hbs'], :relative_to => 'app/templates'

    # optional; defaults to :path
    template_name_style :path
  }
end
```


## API reference

### ember.templates

Combines templates in the given paths into a single asset of those templates in
javascript form.

```ruby
# Usage:
ember {
  templates 'URI', [PATH, PATH, ...], OPTIONS_HASH
}
```

`URI`
> a string defining where the templates will be served.

`PATH`
> a string or glob pattern describing a file or files that should be included

#### Options

`:relative_to`
> a string describing a path relative to the Sinatra root from which the
> template names should be made relative to when using the `:path` template
> name style. For example, if `:relative_to` is `app/templates` and the `PATH`
> `app/templates/views/post.hbs` will be named `views/post`.


### ember.template\_name\_style

Defines the style by which template names will be derived from the paths.

```ruby
# Usage:
ember {
  template_name_style :basename
}
```

Valid options include:

`:path`
> the template will be named as a relative path to the template file

`:basename`
> the template will be named as the basename of the template file


## Sinatra AssetPack

If you're using the [sinatra-assetpack][assetpack] gem, add your served
templates to a package.


[assetpack]: https://github.com/rstacruz/sinatra-assetpack
[ember]: http://emberjs.com
[sinatra]: http://sinatrarb.com
