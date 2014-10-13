# Itamae::Plugin::Resource::Mercurial

[itamae](https://github.com/ryotarai/itamae) resource plugin to clone [mercurial](http://mercurial.selenic.com/) repository.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'itamae-plugin-resource-mercurial'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install itamae-plugin-resource-mercurial

## Usage

```ruby
require 'itamae/plugin/resource/mercurial'

mercurial '/usr/local/src/hg' do
  repository 'http://selenic.com/hg'
  revision 'stable'
end
```

## Contributing

1. Fork it ( https://github.com/eagletmt/itamae-plugin-resource-mercurial/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
