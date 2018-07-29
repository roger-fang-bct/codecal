module Codecal
  module Mask
    def mask_code(offset, code)
      code_arr = code.size > 5 ? code.split("") : ("%06d" % code).split("")
      masked_code = code_arr.each_with_index.inject([]) do |codes, (c, i)|
        codes.push(mask_char(c, offset[ i % offset.size ]))
      end
      start_code = masked_code.pop
      masked_code.unshift(start_code).join
    end

    def unmask_code(offset, masked_code)
      masked_code = masked_code[1..-1] + masked_code[0]
      masked_code.downcase.split("").each_with_index.inject([]) do |code, (c, i)|
        code.push(un_mask_char(c, offset[ i % offset.size ]))
      end.join
    end

    def get_mask_offset(mask)
      mask.split("").inject([]) do |offset,c|
        [[*'a'..'z'], [*'A'..'Z'], [*'0'..'9']].each do |m|
          if m.include?(c)
            offset.push(m.find_index(c))
            break
          end
        end
        offset
      end
    end

    def mask_alphabet_include?(code)
      code.split('').each do |c|
        return false unless @mask_alphabet.include?(c)
      end
      true
    end

    def mask_char(char, offset)
      if all_digits?(char) && char.size == 1
        @mask_alphabet[(@mask_alphabet.find_index(@mask_alphabet[char.to_i]) + offset) % @mask_alphabet.size]
      end
    end

    def un_mask_char(char, offset)
      if mask_alphabet_include?(char)
        (@mask_alphabet.find_index(char) - offset) % @mask_alphabet.size
      end
    end

    # not used
    def convert_masked_code_typo(masked_code)
      masked_code.gsub('1', 'l')
    end
  end
end