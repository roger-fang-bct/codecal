require "codecal/version"
require_relative "./code"

module Codecal
  @@generate_seed = [2,7,5,3,8,9,5,9,1,6,7,3,5]
  class<<self
    def bank_customer_code_generate(account_id, currency)
      raise "parameter 1 type should be Integer and length not longer than 9" unless account_id.is_a?(Integer) && account_id.to_s.size <= 9
      raise "parameter 2 type should be String" unless currency.is_a?(String)
      currency_code = Code.new[currency]
      raise "currency not found" unless currency_code
      cal_array = ("%09d" % account_id + "%04d" % currency_code.to_i).split("").map! {|i| i.to_i}
      return code_calculate(cal_array, @@generate_seed)
    end

    def validate_bank_customer_code(customer_code)
      return false unless customer_code.is_a?(String) && customer_code.size == 16
      calcode = code_calculate(customer_code[0..12].split("").map! {|i| i.to_i}, @@generate_seed)
      return customer_code == calcode
    end

    private
    def code_calculate(array, seed)
      code = array.each_with_index.inject(0){|count, (i, index)| count += i*seed[index]}
      return array.join + ("%03d" % code).to_s
    end
  end
end

