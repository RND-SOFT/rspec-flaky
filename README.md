
[![Gem Version](https://badge.fury.io/rb/rspec-flaky.svg)](https://rubygems.org/gems/rspec-flaky)
[![Gem](https://img.shields.io/gem/dt/rspec-flaky.svg)](https://rubygems.org/gems/rspec-flaky/versions)
[![YARD](https://badgen.net/badge/YARD/doc/blue)](http://www.rubydoc.info/gems/rspec-flaky)

# RSpecFlaky

The most common reason for test flakiness is randomized factories which fill a database before test execution. This small gem is designed to help you find out what exactly attribute values were assigned to an investigated model during a failed and passed execution.

![image](https://user-images.githubusercontent.com/43433100/106516737-8e72a380-64e8-11eb-9758-34e5cb9f278b.png)

Article about gem: [https://blog.rnds.pro/006-rspecflaky](https://blog.rnds.pro/006-rspecflaky?utm_source=github&utm_medium=article) (in russian)

## Installation

Add this line to test group of your application's Gemfile:

```bash
gem 'rspec-flaky'
```

Install the gem:

```bash
bundle
```

That's all. Select the model whose attributes will be dumped:

```ruby
it 'is flaky test', tables: [User, Post] do
    expect([true, false]).to be true
end
```
## Usage

Run the command to iteratively run flaky example (option `-i` specifies the number of iterations):

```bash
rspec-flaky path/to/flaky_spec.rb:12 -i 5 
```

If at least one example is failed gem will generate tables where you are able to investigate source of flakiness by comparing failed and success attribute values. After running your tests, open `tmp/flaky_tests/result.html` in the browser of your choice. For example, in a Mac Terminal, run the following command from your application's root directory:


```bash
open tmp/flaky_tests/result.html
```
   in a debian/ubuntu Terminal,

```bash
xdg-open tmp/flaky_tests/result.html
```

   **Note:** [This guide](https://dwheeler.com/essays/open-files-urls.html) can help if you're unsure which command your particular
   operating system requires.


It's also possible to dump the whole database per each test example if there was a failed result as well as a passed result. For that just add `-d` option (currently only PostresQL is available):
    
```
rspec-flaky path/to/flaky_speЗc.rb:12 -i 10 -d
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
