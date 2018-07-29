require "codecal/version"
require_relative "./lib/modulo"
require_relative "./lib/mask"
require_relative "./lib/validation"

module Codecal

  class Calc
    include Validation
    include Modulo
    include Mask

    @@MASK_ALPHABET = ['a','4','p','9','h','r','7','q','c','3','b','2','j','s','6','d','t','8','k','u','e','v','f','w','x','5','m','y','g','z','n']    

    def initialize(mask_alphabet = nil)
      if mask_alphabet.is_a?(String) && 
          mask_alphabet.size > 26 &&
          all_letters_or_digits?(mask_alphabet) &&
          mask_alphabet.size == mask_alphabet.split('').uniq.size
        @mask_alphabet = mask_alphabet.split('')
      else
        @mask_alphabet = @@MASK_ALPHABET  
      end
    end

    def simple_code_generate(number)
      errormsg = ""
      if number == nil
        errormsg += "parameter is nil. "
        return {success:false, error: errormsg}
      end
      errormsg += "the type of the code to be encrypted should be Integer. " unless all_digits?(number.to_s)
      if errormsg.size == 0
        cal_array = (number.to_i.to_s).split("").map! {|i| i.to_i}
        {success:true, customer_code: simple_code_calculate(cal_array) }
      else
        {success:false, error: errormsg}
      end
    end

    def code_generate_with_mask(mask, number)
      errormsg = "mark should be string of letter or number and length should >= 5" unless is_legal_mask?(mask)
      return {success:false, error: errormsg} if errormsg
      result = simple_code_generate(number)
      return result unless result[:success]
      offset = get_mask_offset(mask)
      # puts "masked code: #{result[:customer_code]}"
      {success:true, customer_code: mask_code(offset, result[:customer_code])}
    end

    def validate_simple_code(simple_code)
      return false unless simple_code && simple_code.to_i > 0 && simple_code.size > 1
      calcode = simple_code_calculate(simple_code[0..-2].split("").map! {|i| i.to_i})
      return simple_code == calcode
    end

    def validate_masked_code(mask, masked_code)
      return false unless is_legal_masked_code?(masked_code)
      return false unless is_legal_mask?(mask)
      masked_code = convert_masked_code_typo(masked_code)

      offset = get_mask_offset(mask)
      result = simple_code_generate(unmask_code(offset, masked_code)[0..-2].to_i)

      return false unless result[:success]
      return masked_code == mask_code(offset, result[:customer_code])
    end

    def get_unmasked_code(mask, masked_code)
      return false unless is_legal_masked_code?(masked_code)
      return false unless is_legal_mask?(mask)
      masked_code = convert_masked_code_typo(masked_code)

      offset = get_mask_offset(mask)
      code = unmask_code(offset, masked_code)
      masked_code.size == code.size ? code : false
    end

  end
end