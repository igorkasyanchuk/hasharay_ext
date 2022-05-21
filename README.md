# Hash/Array Extenstion

[![RailsJazz](https://github.com/igorkasyanchuk/rails_time_travel/blob/main/docs/my_other.svg?raw=true)](https://www.railsjazz.com)
[![https://www.patreon.com/igorkasyanchuk](https://github.com/igorkasyanchuk/rails_time_travel/blob/main/docs/patron.svg?raw=true)](https://www.patreon.com/igorkasyanchuk)

The idea of this gem is to simplify fetching records from the Hash/Array.
I had a need to read values from the complex hashes, and I was tired of doing lots of "dig/fetch". Code was just ugly.

So, initial idea was to create a way to "query" Hash/Array similiar how we are querying CSS, but later idea was changed a little.

Right now I've extracted my code into this gem and now can do the following:

Instead of:
```ruby
h.fetch(:projects, []).map{|e| e[:name]}
```
I can just write:
```ruby
h.fpath('projects.name')
```

Even with a such simple example you can see that the code is much readable.
It was a nice win for my project and at least I'm very happy with it :)

Check more examples below to see if it can be useful for you too.

## More Complex Example

```ruby
    # -----
    # INITIAL DATA (see usage below)
    # -----
    hash = {
      name: "john",
      dob: Date.today,
      projects: [ {name: "A", locations: ["Kyiv"]}, {name: "B", locations: ["Paris", "Berlin"]} ],
      position: {
        company: {
          team: "position1",
          office: "position2",
          other: {
            status: "unknown",
            notes: ["note a", "note b"],
            summaries: [
              {worker: "John", level: "middle"},
              {worker: "Bob", level: "senior"}
            ]
          }
        }
      },
      locations: [ { city: "Kyiv", country: "Ukraine" }, { city: "Odessa", country: "Ukraine"}]
    }

    # -----
    # USAGE with HASH
    # -----
    hash.fpath("name") # =>  "john"
    hash.fetch_path("projects.name") # =>  ["A", "B"]
    hash.fpath("projects.locations") # => [["Kyiv"], ["Paris", "Berlin"]]
    hash.fpath!("position.company.other.summaries") # =>  [{"level" => "middle", "worker" => "John"}, {"level" => "senior", "worker" => "Bob"}]
    hash.fetch_path!("position.company.other.status") # =>  "unknown"
    hash.fpath("position.company.team+office") # =>  {"team" => "position1", "office" => "position2"}
    hash.fpath("not_exising_name") # => nil
    hash.fpath("not_exising_projects.not_exising_name") # => nil
    hash.fpath("not_exising_projects.not_exising_name", default: 42) # => 42

    # USAGE with ARRAY
    array = [{name: "igor"}, {name: "john"}]
    array.fpath("name") # => ["igor", "john"]

    array = [{user: {first_name: "john"}}, {user: {first_name: "bob"}}]
    array.fpath("user.first_name") # => ["john", "bob"]
```

### Methods & Options

`fpath` or `fetch_path` will return vakue based on path to the value. If nothing - nil.
`fpath!` or `fetch_path!` working same way as `fpath` but raise error is some key is not available.

Available options: `def fpath(key, strict: false, separator: ".", default: nil)`.

Pay attention that if you have in your keys dots, you need to change separator. On my project I've only one work textual keys.

You can also return multiple values, pay attention to the `hash.fpath("position.company.team+office")`. Note that "+" works only for the last key in the queried "path".

Note that keys in the returned hash are stringified.

More examples available in the specs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hasharay_ext'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hasharay_ext

## Ideas

- Add support for "*" operator to search in hash/array for needed values.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/igorkasyanchuk/hasharay_ext.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[<img src="https://github.com/igorkasyanchuk/rails_time_travel/blob/main/docs/more_gems.png?raw=true"
/>](https://www.railsjazz.com/?utm_source=github&utm_medium=bottom&utm_campaign=hasharay_ext)
