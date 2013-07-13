# Gaffe

Gaffe handles Rails error pages in a clean, simple way.

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

### Custom views

You can (and should!) also use your own views. You just have to create a layout:

```
<!-- app/views/layouts/error.html.erb -->
<h1>Error!</h1>
<%= yield %>
```

And create a different view for [each possible error rescue response](https://github.com/rails/rails/blob/f9ceefd3b9c3cea2460a89799156f2c532c4491c/actionpack/lib/action_dispatch/middleware/exception_wrapper.rb). For example, for `404` errors:

```
<!-- app/views/errors/not_found.html.erb -->
<p>This page does not exist.</p>
```

### Custom exceptions

If your application is raising custom exceptions (through gems or your code)
and you want to render specific views when it happens, you can map them to
specific rescue responses.

```ruby
# config/application.rb
config.action_dispatch.rescue_responses.merge!('CanCan::AccessDenied' => :forbidden)
config.action_dispatch.rescue_responses.merge!('MyCustomException' => :not_acceptable)
```

## License

`Gaffe` is © 2013 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/gaffe/blob/master/LICENSE.md) file.

## About Mirego

Mirego is a team of passionate people who believe that work is a place where you can innovate and have fun. We proudly built mobile applications for [iPhone](http://mirego.com/en/iphone-app-development/ "iPhone application development"), [iPad](http://mirego.com/en/ipad-app-development/ "iPad application development"), [Android](http://mirego.com/en/android-app-development/ "Android application development"), [Blackberry](http://mirego.com/en/blackberry-app-development/ "Blackberry application development"), [Windows Phone](http://mirego.com/en/windows-phone-app-development/ "Windows Phone application development") and [Windows 8](http://mirego.com/en/windows-8-app-development/ "Windows 8 application development").
