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

A CLI is yet to be written. But you may run the tool from inside your code or an interactive session.

### Inferring information from data

Run code like the following:

```ruby
require "infer_model"

# Just display the results in a human readable format
InferModel.from(:csv, "path/to/file.csv").to(:text).call

# Create a rails migration for me with the inferred information
InferModel.from(:csv, "path/to/file.csv", csv_options: { col_sep: ";", encoding: "csp1252" }).to(:migration, rails_version: "6.0", table_name: "csv_contents").call
```

More "Adapters" that can be used as `from` source or `to` target may be added in the future. If you have ideas or needs please contribute by creating an issue or pr.

### Importing data

After generating a database table fitting to your data, you might want to fill them. You can use `InferModel`s parsers to do so. For example in your rails app, in an import service or seeds:

```ruby
now = Time.current
column_types = MyModel.columns.to_h { |column| [column.name, column.type] }

data = ::CSV.foreach("my_model_data.csv", col_sep: ";", encoding: "utf-8", headers: true, header_converters: :symbol).map do |row|
    parsed_attributes = row.to_h.to_h do |column_name, value| # note the `to_h.to_h`: The first one turns the row into a hash, the second one allows building a new hash with the block. CSV::Row's #to_h method does not process the block properly.
        column_type = column_types.fetch(column_name.to_s)
        parser = InferModel::Parsers::BY_TYPE.fetch(column_type)
        [column_name, parser.call(value)]
    end
    { created_at: now, updated_at: now }.merge(parsed_attributes)
end

MyModel.upsert_all(data) if data.present? # rubocop:disable Rails/SkipsModelValidations
```

That way you profit from the parsers logic that already generated your tables. For example the `Boolean` parser acknowledges `"Y"` as a _truthy_ value compared to `"N"` which is considered _falsey_. When you use a different parser or just attempt to insert the string value into your database, they will most likely all have `true` as value in the corresponding column just because `"N"` is considered truthy.

For more information on how different parsers work, have a look inside their definition, e.g. the constants `InferModel::Parsers::Boolean::TRUTHY_VALUES_LOWERCASE` and `FALSEY_VALUES_LOWERCASE`. There might be the option to configure those values in the future.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Jay-Schneider/infer_model. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Jay-Schneider/infer_model/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the InferModel project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Jay-Schneider/infer_model/blob/main/CODE_OF_CONDUCT.md).
