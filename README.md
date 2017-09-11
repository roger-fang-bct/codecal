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
# Return:
#   String(16) -- 16 numbers string
# Raise:
#   pamameters type error
#   currency not found
Codecal.bank_customer_code_generate(account_id, currency)

# Validate customer code
# Parameters:
#   customer_code : String
# Return:
#   boolean
# Return String
Codecal.validate_bank_customer_code(String)

