[![Continuous Integration](https://github.com/Jay-Schneider/infer_model/actions/workflows/ci.yml/badge.svg)](https://github.com/Jay-Schneider/infer_model/actions/workflows/ci.yml)

# InferModel

Infer a model from data.

This gem transforms data dumps into managable structures.

You can use it to deduce certain properties from a given set of data to use it to build a database around this data.

The main use case is:
Given a csv file that was exported from some tool, you want to manage and process the contained data in a database, say in your rails application.
It would be valid to create a string column for every CSV column and import the data as is but you lose a lot of information by doing so.

Instead what this tool allows you to do is to guess which data type, like integer, decimal, boolean, etc, is the best fit for each column and allows you to create migrations or scripts to do so almost automatically.

Additionally the values may be parsed to deduce further features of your data that may be useful when setting up a database, like uniqueness or non-null constraints.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add infer_model

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install infer_model

## Usage

A CLI is yet to be written. But you may run the tool from inside your code or an interactive session like so:

```ruby
require "infer_model"

# Just display the results in a human readable format
InferModel.from(:csv, "path/to/file.csv").to(:text).call

# Create a rails migration for me with the inferred information
InferModel.from(:csv, "path/to/file.csv", csv_options: { col_sep: ";", encoding: "csp1252" }).to(:migration, rails_version: "6.0", table_name: "csv_contents").call
```

More "Adapters" that can be used as `from` source or `to` target may be added in the future. If you have ideas or needs please contribute by creating an issue or pr.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Jay-Schneider/infer_model. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Jay-Schneider/infer_model/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the InferModel project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Jay-Schneider/infer_model/blob/main/CODE_OF_CONDUCT.md).
