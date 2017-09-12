require "codecal/version"
require_relative "./code"

module Codecal
  @@generate_seed = [2,7,5,3,8,9,5,9,1,6,7,3,5]
  class<<self
    def bank_customer_code_generate(account_id, currency)
      errormsg = ""
      if account_id == nil || currency == nil
        errormsg += "parameter is nil. " 
        return {success:false, error: errormsg}
      end
      errormsg += "parameter 1 type should be Integer and length not longer than 9. " unless account_id.is_a?(Integer) && account_id.to_s.size <= 9
      currency.is_a?(String) ? currency.upcase! : errormsg += "parameter 2 type should be String. "
      currency_code = Code.new[currency]
      errormsg += "currency not found. " unless currency_code
      if errormsg.size == 0
        cal_array = ("%09d" % account_id + "%04d" % currency_code.to_i).split("").map! {|i| i.to_i}
        {success:true,customer_code: code_calculate(cal_array, @@generate_seed) }
      else
        {success:false, error: errormsg}
      end
    end

    def validate_bank_customer_code(customer_code)
      return false unless customer_code && customer_code.is_a?(String) && customer_code.size == 16
      calcode = code_calculate(customer_code[0..12].split("").map! {|i| i.to_i}, @@generate_seed)
      return customer_code == calcode
    end

    def get_currency_name(currency_code)
      return nil if !currency_code || currency_code.size !=4 || !currency_code.is_a?(String)
      return Code.new.get_name(currency_code)
    end

    private
    def code_calculate(array, seed)
      code = array.each_with_index.inject(0){|count, (i, index)| count += i*seed[index]}
      return array.join + ("%03d" % code).to_s
    end
  end
end