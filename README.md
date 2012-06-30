# Sinatra Ember

Helpers for serving an [Ember.js][ember] app from [Sinatra][sinatra].

- Pre-compile handlebars templates from separate view files rather than littering them throughout your html.


## Installation

You can install Sinatra Ember as a Ruby gem. You can install it via `gem install`.

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
    templates '/js/templates.js', ['app/templates/*']                                                       
  }
end
```

## Sinatra AssetPack

If you're using the [sinatra-assetpack][assetpack] gem, add your served templates to a package.


[assetpack]: https://github.com/rstacruz/sinatra-assetpack
[ember]: http://emberjs.com
[sinatra]: http://sinatrarb.com
