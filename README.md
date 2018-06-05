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

codecal = Codecal::Calc.new()

# or initialize with mask_alphabet string which should only contain unique letter and number and length over 26

codecal = Codecal::Calc.new('fdsa32jkh89704lncmxzvrueopwytq')

# Generate customer code for user account
# Parameters:
#   number     : Integer(<=9) -- code to be calculated and masked
#   currency   : String       --currency name
# Return: Hash
#   success       : boolean -- generate customer code success
#   customer code : String  -- 16 numbers string when success == true
#   error         : String  -- error message of parameters when success == false
codecal.bank_customer_code_generate(number, currency)

# Generate simple code for account
# Parameters:
#   number  : Integer(<=9)  -- code to be calculated and masked
# Return: Hash
#   success       : boolean -- generate customer code success
#   customer code : String  -- numbers(number.length + 1) string when success == true
#   error         : String  -- error message of parameters when success == false
codecal.simple_code_generate(number)

# Generate masked code for account
# Parameters:
#   mask    : String(>=6)   -- mask of letter or number
#   number  : Integer(<=9)  -- code to be calculated and masked
# Return: Hash
#   success       : boolean -- generate customer code success
#   customer code : String  -- combination of letter and number(number.length + 1) string when success == true
#   error         : String  -- error message of parameters when success == false
codecal.code_generate_with_mask(mask, number)

# Validate customer code
# Parameters:
#   customer_code : String
# Return:
#   valid : boolean
codecal.validate_bank_customer_code(String)

# Validate simple code
# Parameters:
#   simple_code : String
# Return:
#   valid : boolean
codecal.validate_simple_code(String)

# Validate masked code
# Parameters:
#   mask        : String(>=6)   -- mask of letter or number
#   masked_code : String(>=6)
# Return:
#   valid : boolean
codecal.validate_masked_code(String)

# Get unmasked code
# Parameters:
#   mask        : String(>=6)   -- mask of letter or number
#   masked_code : String(>=6)
# Return:
#   code  : String(>=6) ||  false : boolean
codecal.get_unmasked_code(String)

# Get currency name
# Parameters:
#   currency_code : String(4)
# Return:
#   currency name : String -- nil if not found
codecal.get_currency_name(String)