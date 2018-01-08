require "codecal/version"
require_relative "./code"

module Codecal
  @@BASE_ALPHABET = ['o','a','3','p','9','h','b','2','q','i','1','c','4','r','7','j','s','5','d','t','8','k','u','e','v','l','w','f','x','6','m','y','0','g','z','n']
  @@generate_seed = [2,7,5,3,8,9,5,9,1,6,7,3,5]
  @@simple_seed = [5,4,6,2,3,1,5,4,6,2,3,1]
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

    def simple_code_generate(account_id)
      errormsg = ""
      if account_id == nil
        errormsg += "parameter is nil. "
        return {success:false, error: errormsg}
      end
      errormsg += "the type of the code to be encrypted should be Integer. " unless all_digits?(account_id.to_s)
      if errormsg.size == 0
        cal_array = (account_id.to_i.to_s).split("").map! {|i| i.to_i}
        {success:true,customer_code: simple_code_calculate(cal_array, @@simple_seed) }
      else
        {success:false, error: errormsg}
      end
    end

    def code_generate_with_mask(mask, account_id)
      errormsg = "mark should be string of letter or number and length should >= 5" unless is_legal_mask?(mask)
      return {success:false, error: errormsg} if errormsg
      result = simple_code_generate(account_id)
      return result unless result[:success]
      offset = get_mask_offset(mask)
      {success:true, customer_code: mask_code(offset, result[:customer_code])}
    end

    def validate_bank_customer_code(customer_code)
      return false unless customer_code && customer_code.is_a?(String) && customer_code.size == 16
      calcode = code_calculate(customer_code[0..12].split("").map! {|i| i.to_i}, @@generate_seed)
      return customer_code == calcode
    end

    def validate_simple_code(simple_code)
      return false unless simple_code && simple_code.to_i > 0 && simple_code.size > 1
      calcode = simple_code_calculate(simple_code[0..-2].split("").map! {|i| i.to_i}, @@simple_seed)
      return simple_code == calcode
    end

    def validate_masked_code(mask, masked_code)
      return false unless is_legal_masked_code?(masked_code)
      return false unless is_legal_mask?(mask) 
      offset = get_mask_offset(mask)
      result = simple_code_generate(unmask_code(offset, masked_code)[1..-1].to_i)
      return false unless result[:success]
      return masked_code == mask_code(offset, result[:customer_code])
    end

    def get_unmasked_code(mask, masked_code)
      return false unless is_legal_masked_code?(masked_code)
      return false unless is_legal_mask?(mask) 
      offset = get_mask_offset(mask)
      code = unmask_code(offset, masked_code)
      all_digits?(code) ? code : false
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

    def simple_code_calculate(array, seed)
      code = array.reverse.each_with_index.inject(0){|count, (i, index)| count += i*( index < 11 ? seed.reverse[index + 1] : (index+1).times.inject(1) {|c| c *= 3} % 7 ) }
      return (array.join + ( code % 7 ).to_s).to_i.to_s
    end

    def mask_code(offset, code)
      code_arr = code.size > 5 ? code.split("") : ("%06d" % code).split("")
      start_code = code_arr.pop
      masked_code = code_arr.each_with_index.inject([]) do |code, (c, i)|
        code.push(@@BASE_ALPHABET[(@@BASE_ALPHABET.find_index(c) + offset[ i % offset.size ]) % @@BASE_ALPHABET.size])
      end
      masked_code.unshift(start_code).join
    end

    def unmask_code(offset, masked_code)
      start_code = masked_code[0]
      code = masked_code[1..-1].downcase.split("").each_with_index.inject([]) do |code, (c, i)|
        code.push(@@BASE_ALPHABET[(@@BASE_ALPHABET.find_index(c) - offset[ i % offset.size ]) % @@BASE_ALPHABET.size])
      end
      code.unshift(start_code).join
    end

    def get_mask_offset(mask)
      mask.split("").inject([]) do |offset,c|
        [[*'a'..'z', *'0'..'9'], [*'A'..'Z', *'0'..'9']].each do |m|
          if m.include?(c)
            offset.push(m.find_index(c))
            break
          end
        end
        offset
      end
    end

    def all_letters_or_digits?(str)
      str[/[a-zA-Z0-9]+/]  == str
    end

    def all_digits?(str)
      str[/[0-9]+/]  == str
    end

    def is_legal_mask?(mask)
      return false if !mask.is_a?(String) || mask.size < 6 || !all_letters_or_digits?(mask) 
      return true
    end

    def is_legal_masked_code?(masked_code)
      return false unless masked_code.is_a?(String) && masked_code.size > 5
      return true
    end

  end
end