# Visma

This is a Ruby on Rails [Engine](http://guides.rubyonrails.org/engines.html) for integrating with [Visma Global](https://www.visma.no/programvare/okonomi/visma-global/overview/)

## Usage

In your Gemfile:

    gem 'visma', '~> 0.5', git: "git@git.voit.no:Voit/visma"
    gem 'tiny_tds'
    gem 'activerecord-sqlserver-adapter', github: 'rails-sqlserver/activerecord-sqlserver-adapter'

## Dependencies

The v0.5 series of this gem depends on rails 5 and activerecord-sqlserver-adapter 5 series.

We are only supporting Microsoft SQL Server 2012 and newer.

If you want SQL Server 2008 support, you need an older version of this gem.

To use the gem, you will have to manually specify which activerecord-sqlserver-adapter to use, until a series 5 version is released at rubygems.org.

# License

See MIT-LICENSE
