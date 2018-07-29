# this is a modulo 17 Galois field

module Codecal
  module Modulo
    ## module 7
    @@MODULO_NUMBER = 7
    @@MODULO_WEIGHT = [5,4,6,2,3,1,5,4,6,2,3,1]
    ## module 17
    # @@MODULO_NUMBER = 17
    # @@MODULO_WEIGHT = %w[01 06 02 12 04 07 08 14 16 11 15 05 13 10 09 03 01]
    ## module 11
    # @@MODULO_NUMBER = 11
    # @@MODULO_WEIGHT = %w[07 09 10 05 08 04 02 01 06 03 07 09 10 05 08 04 02 01]
    ## module 13
    # @@MODULO_NUMBER = 13
    # @@MODULO_WEIGHT = %w[3 8 4 2 1 7 10 5 9 11 12 6 3 8 4 2 1]
    @@SEVENTEEN_SYMBOL = '0123456789abcdefg'

    def simple_code_calculate(int_array)
      code = int_array.reverse.each_with_index.inject(0) do |count, (i, index)| 
        count += i * ( index < @@MODULO_WEIGHT.size ? 
                        @@MODULO_WEIGHT.reverse[index + 1].to_i : 
                        ( index + 1 ).times.inject(1) { |c| c *= 3 } % @@MODULO_NUMBER
                      )
      end
      symbol = convert_to_symbol(code % @@MODULO_NUMBER)
      (int_array.join + symbol).to_i.to_s
    end

    # def simple_code_calculate(array)
    #   code = array.reverse.each_with_index.inject(0){|count, (i, index)| count += i*( index < 11 ? @@MODULO_WEIGHT.reverse[index + 1] : (index+1).times.inject(1) {|c| c *= 3} % 7 ) }
    #   return (array.join + ( code % 7 ).to_s).to_i.to_s
    # end

    private

    def convert_to_symbol(number)
      @@SEVENTEEN_SYMBOL[number]
    end

    def convert_to_number(symbol)
      @@SEVENTEEN_SYMBOL.find_index(symbol)
    end

  end
end