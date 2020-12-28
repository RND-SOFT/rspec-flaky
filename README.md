# RSpecFlaky

TODO: Write a gem description

## Installation

Add this line to test group of your application's Gemfile:

    gem 'rspec-flaky'

Install the gem:

    $ bundle

And then add this line to your spec/spec_helper.rb:

    require 'rspec/flaky'

Select the model whose attributes will be dumped:

    it 'is flaky test', tables: [User, Post] do
        expect([true, false]).to be true
    end

## Usage

Run the command to iteratively run flaky example:

    rspec-flaky path/to/flaky_spec.rb:12 -i 10 -j -d

    -i - iterations number
    -j - save pointed model attributes to tmp/flaky_tests/.:flaky_spec:12 as json
    -d - save database dump after each example to tmp/flaky_tests/database_dumps/.:flaky_spec:12 as sql file

If at least one example is failed you can compare pointed model's attributes dumped to tmp/flaky_test folder.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request