# Belafonte #

This library is all about making command-line applications. It's a lot like GLI, methadone, Main, and the other options. This is just my take.

My goals in this:

* Make a system that suits my tastes
* Avoid magic
* Make apps easier to test (specifically with aruba in-process)

## Installation ##

Add this line to your application's Gemfile:

```ruby
gem 'belafonte'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install belafonte

## Usage ##

```ruby
require 'belafonte'

class MyApp < Belafonte::App

  # Every Belafonte application must have a title.
  title "myapp"
  summary "A short description"
  description <<-DESCRIPTION
  This is a much longer description of the app, command, or what have you.
  DESCRIPTION

  # Switches are boolean flags that can be passed on the command line.
  # At least one short or long flag is required, but you can pass multiple
  # flags (without hyphens) for each if you like.

  switch :switch_name,              # name the switch
    short: 's',                     # short flags for the switch (array for 2+)
    long: 'switch',                 # long flag for the switch (array for 2+)
    description: 'This is a switch' # describe the switch (default '')

  # Options are flags that take an argument. The basic setup for this is the
  # same as that for switches, but with the additional requirement of a display
  # name for the option's argument.

  option :option_name,                # name the option
    short: 'o',                       # short flags (array for 2+)
    long: 'option',                   # long flags (array for 2+)
    description: 'This is an option', # describe the option (default: '')
    argument: 'option name'           # display name (required)

  # Args are actual arguments to the command. These require a name, and by
  # default are expected 1 time. You can specify any number of explicit
  # occurrences that are greater-than 0, and you can also make them unlimited,
  # but you're not allowed to add any further args after adding an unlimited
  # arg.

  arg :argument_name,
    times: 1

  arg :unlimited_argument,
    times: :unlimited

  # The `handle` method that you define for your app is the hook that Belafonte
  # uses to run your code. If you don't define this, your app won't actually
  # do much of anything.

  def handle

    # Do something if the :switch_name switch is active

    if switch_active(:switch_name)
      stdout.puts "Switch is active!"
    else
      stdout.puts "Switch is not active :/"
    end

    # Do something based on the options that came in
    stdout.puts "We got this option: #{option[:option]}"

    # Do something with the first argument we defined
    stdout.puts arg[:argument_name].first

    # Do something with the unlimited argument we defined
    arg[:unlimited_argument].each do |unlimited|
      stdout.puts "unlimited == '#{unlimited}'"
    end
  end
end

# Actually run the application. In addition to ARGV, the following .new args
# are defaulted:
#
# * stdin (default: STDIN)
# * stdout (default: STDOUT)
# * stderr (default: STDERR)
# * kernel (default: Kernel)
#
# Unfortunately, order matters, and you can't specify (say) kernel without
# first specifying the items that come before it.
#
# In a more perfect world, your executable file is basically just a require to
# pull in your app, then this line.

exit MyApp.new(ARGV).execute!
```

## Upcoming Features ##

So as to allow for "command suite" utilities, I'm planning to allow for the mounting of one application into another, a-la Rack, Sinatra, Grape, etc.

The API for this is unstable, and I need to figure out some business logic, but it should look something like this:

```ruby
require 'belafonte'

class InnerApp < Belafonte::App
  title "inner"

  def handle
    stdout.puts "This is the inner app"
  end
end

class OuterApp < Belafonte::App
  title "outer"

  mount InnerApp

  def handle
    stdout.puts "This is the outer app"
  end
end

exit OuterApp.new(ARGV).execute!
```

## Development ##

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing ##

1. Fork it ( https://github.com/[my-github-username]/belafonte/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
