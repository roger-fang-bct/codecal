## Installation

Calculate parameter and return a code:

```ruby
gem 'codecal'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install codecal

## Usage

```
require 'codecal'

# Generate customer code for user account
# Parameters:
#   account_id : Integer(<=9) --user account_id in acx
#   currency   : String  --currency name
# Return: Hash
#   success       : boolean -- generate customer code success
#   customer code : String  -- 16 numbers string when success == true
#   error         : String  -- error message of parameters when success == false
Codecal.bank_customer_code_generate(account_id, currency)

# Validate customer code
# Parameters:
#   customer_code : String
# Return:
#   valid : boolean
Codecal.validate_bank_customer_code(String)

# Get currency name
# Parameters:
#   currency_code : String(4)
# Return:
#   currency name : String -- nil if not found
Codecal.get_currency_name(String)