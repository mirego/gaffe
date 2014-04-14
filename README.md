<p align="center">
  <a href="https://github.com/mirego/gaffe">
    <img src="http://i.imgur.com/k9Vo08q.png" alt="gaffe" />
  </a>
  <br />
  Gaffe makes having customized error pages in Rails applications an easy thing.<br /> It takes advantage of a feature present in Rails 3.2 (and 4.0, obviously) called <code>exceptions_app</code>.
  <br /><br />
  <a href="https://rubygems.org/gems/gaffe"><img src="https://badge.fury.io/rb/gaffe.png" /></a>
  <a href="https://codeclimate.com/github/mirego/gaffe"><img src="https://codeclimate.com/github/mirego/gaffe.png" /></a>
  <a href='https://coveralls.io/r/mirego/gaffe?branch=master'><img src='https://coveralls.io/repos/mirego/gaffe/badge.png?branch=master' /></a>
  <a href='https://gemnasium.com/mirego/gaffe'><img src="https://gemnasium.com/mirego/gaffe.png" /></a>
  <a href="https://travis-ci.org/mirego/gaffe"><img src="https://travis-ci.org/mirego/gaffe.png?branch=master" /></a>
</p>

---

It comes with default error pages but makes it very easy to override them (which you should do). The default error pages look like this:

![](http://i.imgur.com/nz5nWXn.png)

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

  # Make sure anonymous users can see the page
  skip_before_filter :authenticate_user!

  # Override 'error' layout
  layout 'application'

  # Render the correct template based on the exception “standard” code.
  # Eg. For a 404 error, the `errors/not_found` template will be rendered.
  def show
    # Here, the `@exception` variable contains the original raised error
    render "errors/#{@rescue_response}", status: @status_code
  end
end
```

For example, you might want your `API::ErrorsController` to return a standard JSON response:

```ruby
class API::ErrorsController < API::ApplicationController
  include Gaffe::Errors

  # Make sure anonymous users can see the page
  skip_before_filter :authenticate_user!

  # Disable layout (your `API::ApplicationController` probably does this already)
  layout false

  # Render a simple JSON response containing the error “standard” code
  # plus the exception name and backtrace if we’re in development.
  def show
    output = { error: @rescue_response }
    output.merge! exception: @exception.inspect, backtrace: @exception.backtrace.first(10) if Rails.env.development?
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

## Contributors

* [@remiprev](https://github.com/remiprev)
* [@simonprev](https://github.com/simonprev)
* [@jmuheim](https://github.com/jmuheim)

## License

`Gaffe` is © 2013 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/gaffe/blob/master/LICENSE.md) file.

The mushroom cloud logo is based on [this lovely icon](http://thenounproject.com/noun/mushroom-cloud/#icon-No18596) by [Gokce Ozan](http://thenounproject.com/occultsearcher), from The Noun Project. Used under a [Creative Commons BY 3.0](http://creativecommons.org/licenses/by/3.0/) license.

## About Mirego

[Mirego](http://mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We're a team of [talented people](http://life.mirego.com) who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](http://mirego.org).

We also [love open-source software](http://open.mirego.com) and we try to give back to the community as much as we can.
