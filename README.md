# Visma

This is a Ruby on Rails [Engine](http://guides.rubyonrails.org/engines.html) for integrating with [Visma Global](https://www.visma.no/programvare/okonomi/visma-global/overview/)

## Usage

Use Ubuntu. :) To be able to install the tiny_tds gem, you need:

    apt install freetds-dev

In your Gemfile:

    gem 'visma', '~> 0.6', git: "https://github.com/voitcode/visma"

Set up the database connection in `config/database.yml`

    development:
      visma:
        adapter: sqlserver
        host: sqlserver.your.domain
        database: YourBusinessASGlobalData
        username: sa
        password: YourSuperSecret
        timeout: 15000

Then in `config/visma.yml`, define required variables:

    # Visma table prefix
    table_name_prefix: YourBusiness.
    # The Customer number employees are Chain members of
    employee_chain_number: 49999
    # The CustomerProfileNo used for factoring
    factoring_customer_profile_number: 101
    # The FormProfileNo used for factoring
    factoring_form_profile_number: 506
    # The RemittanceProfileNo used for factoring
    factoring_remittance_profile_number: 6

## Dependencies

The v0.6 series of this gem depends on rails 6 and activerecord-sqlserver-adapter 6 series.

We are only supporting Microsoft SQL Server 2012 and newer.

If you want SQL Server 2008 support, you need an older version of this gem.

# License

See MIT-LICENSE
