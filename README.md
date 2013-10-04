<p align="center">
  <a href="https://github.com/mirego/gaffe">
    <img src="http://i.imgur.com/k9Vo08q.png" alt="gaffe" />
  </a>
  <br />
  Gaffe makes having customized error pages in Rails applications an easy thing.<br /> It takes advantage of a feature present in Rails 3.2+ called <code>exceptions_app</code>.
  <br /><br />
  <a href="https://rubygems.org/gems/gaffe"><img src="https://badge.fury.io/rb/gaffe.png" /></a>
  <a href="https://codeclimate.com/github/mirego/gaffe"><img src="https://codeclimate.com/github/mirego/gaffe.png" /></a>
  <a href='https://coveralls.io/r/mirego/gaffe?branch=master'><img src='https://coveralls.io/repos/mirego/gaffe/badge.png?branch=master' /></a>
  <a href='https://gemnasium.com/mirego/gaffe'><img src="https://gemnasium.com/mirego/gaffe.png" /></a>
  <a href="https://travis-ci.org/mirego/gaffe"><img src="https://travis-ci.org/mirego/gaffe.png?branch=master" /></a>
</p>

---

It comes with default error pages but makes it very easy to override them (which you should do). The default error pages look like this:

![](http://i.imgur.com/9gPfCOm.png)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'gaffe'
```

## Usage

The easiest way to use Gaffe is with an initializer:

```ruby
# config/initializers/gaffe.rb
Gaffe.enable!
```

### Custom controller

However, if you want to use your own controller:

```ruby
# config/initializers/gaffe.rb
Gaffe.configure do |config|
  config.errors_controller = ErrorsController
end

Gaffe.enable!
```

It’s also possible to use a custom controller based on the URL in which the error has occured. This is especially
useful if you have an application that also serves API requests via JSON. You would probably want to serve API errors
through JSON and regular errors through HTML pages.

```ruby
# config/initializers/gaffe.rb
Gaffe.configure do |config|
  config.errors_controller = {
    %r[^/api/] => Api::ErrorsController,
    %r[^/] => ErrorsController
  }
end

Gaffe.enable!
```

The only required thing to do in your custom controller is to include the `Gaffe::Errors` module.

Only `show` will be called so you might want to override it. If you don’t override it, Gaffe will
try to render the view `"errors/#{@rescue_response}"` within your application (or use its default
error page if the view doesn’t exist).

You might also want to get rid of filters and other stuff to make sure that error pages are always accessible.

```ruby
class ErrorsController < ApplicationController
  include Gaffe::Errors
  skip_before_filter :ensure_current_user

  def show
    # The following variables are available:
    @exception # The encountered exception (Eg. `#<ActiveRecord::NotFound …>`)
    @status_code # The status code we should return (Eg. `404`)
    @rescue_response # The "standard" name for the status code (Eg. `:not_found`)
  end
end
```

For example, you might want your `Api::ErrorsController` to return a standard JSON response:

```ruby
class Api::ErrorsController < Api::ApplicationController
  include Gaffe::Errors
  skip_before_filter :ensure_current_user

  def show
    render json: { error: @rescue_response }, status: @status_code
  end
end
```

### Custom views

You can (and should!) also use your own views. You just have to create a layout:

```erb
<!-- app/views/layouts/error.html.erb -->
<h1>Error!</h1>
<%= yield %>
```

And create a different view for [each possible error rescue response](https://github.com/mirego/gaffe/tree/master/app/views/errors) ([rails reference](https://github.com/rails/rails/blob/f9ceefd3b9c3cea2460a89799156f2c532c4491c/actionpack/lib/action_dispatch/middleware/exception_wrapper.rb)). For example, for `404` errors:

```erb
<!-- app/views/errors/not_found.html.erb -->
<p>This page does not exist.</p>
```

### Custom exceptions

If your application is raising custom exceptions (through gems or your code)
and you want to render specific views when it happens, you can map them to
specific rescue responses.

```ruby
# config/application.rb
config.action_dispatch.rescue_responses.merge! 'CanCan::AccessDenied' => :forbidden
config.action_dispatch.rescue_responses.merge! 'MyCustomException' => :not_acceptable
```

### Rails development mode

Rails prefers to render its own debug-friendly errors in the `development` environment,
which is totally understandable. However, if you want to test Gaffe’s behavior in development
you’ll have to edit the `config/environments/development.rb` file.

```ruby
# Make Rails use `exceptions_app` in development
config.consider_all_requests_local = false
```

## License

`Gaffe` is © 2013 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/gaffe/blob/master/LICENSE.md) file.

The mushroom cloud logo is based on [this lovely icon](http://thenounproject.com/noun/mushroom-cloud/#icon-No18596) by [Gokce Ozan](http://thenounproject.com/occultsearcher), from The Noun Project. Used under a [Creative Commons BY 3.0](http://creativecommons.org/licenses/by/3.0/) license.

## About Mirego

Mirego is a team of passionate people who believe that work is a place where you can innovate and have fun. We proudly build mobile applications for [iPhone](http://mirego.com/en/iphone-app-development/ "iPhone application development"), [iPad](http://mirego.com/en/ipad-app-development/ "iPad application development"), [Android](http://mirego.com/en/android-app-development/ "Android application development"), [Blackberry](http://mirego.com/en/blackberry-app-development/ "Blackberry application development"), [Windows Phone](http://mirego.com/en/windows-phone-app-development/ "Windows Phone application development") and [Windows 8](http://mirego.com/en/windows-8-app-development/ "Windows 8 application development") in beautiful Quebec City.

We also love [open-source software](http://open.mirego.com/) and we try to extract as much code as possible from our projects to give back to the community.
