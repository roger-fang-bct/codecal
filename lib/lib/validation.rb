module Codecal
  module Validation
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
      return false unless mask_alphabet_include?(masked_code)
      return true
    end
  end
end