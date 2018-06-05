require "spec_helper"

RSpec.describe Codecal do
  let(:codecal) { Codecal::Calc.new() }

  it "has a version number" do
    expect(Codecal::VERSION).not_to be nil
  end

  ## pressure test

  describe "generate codes" do
    let(:mask) { 'maskcode01' }
    let(:aim_number) { 1_000 }
    let(:masked_codes) {
      (1..aim_number).inject([]) do |codes, num|
        codes.push(codecal.code_generate_with_mask(mask, num)[:customer_code])
      end
    }

    it "should have no duplicate codes" do
      expect(masked_codes.uniq.size).to eq aim_number
    end

    it "should all be valid" do
      masked_codes.each do |code|
        expect(codecal.validate_masked_code(mask, code)).to eq true
      end
    end
  end

  describe "generate correct code" do
    it "return correct code with correct params upcase" do
      result = codecal.bank_customer_code_generate(1230,"HSR")
      expect(result[:success]).to eq(true)
      expect(result[:customer_code].length).to eq(16)
      expect(result[:customer_code]).to eq("0000012300020052")
    end

    it "return correct code with correct params downcase" do
      result = codecal.bank_customer_code_generate(1230,"eth")
      expect(result[:success]).to eq(true)
      expect(result[:customer_code].length).to eq(16)
      expect(result[:customer_code]).to eq("0000012300002056")
    end
  end

  describe "generate simple correct code" do
    it "return correct code with correct params upcase" do
      result = codecal.simple_code_generate("65524")
      expect(result[:success]).to eq(true)
      expect(result[:customer_code].length).to eq(6)
      expect(result[:customer_code]).to eq("655245")
    end

    it "return correct code with correct params upcase" do
      result = codecal.simple_code_generate("000035465265524")
      expect(result[:success]).to eq(true)
      expect(result[:customer_code].length).to eq(12)
      expect(result[:customer_code]).to eq("354652655242")
    end

  end

  describe "generate masked code" do
    it "return correct code with correct params longer than 6" do
      result = codecal.code_generate_with_mask("ag2gd8",239851)
      expect(result[:success]).to eq(true)
      expect(result[:customer_code].length).to eq(7)
      expect(result[:customer_code]).to eq("pp326c3")
    end

    it "return correct code with correct params shorter than 6" do
      result = codecal.code_generate_with_mask("tu3a2j",2)
      expect(result[:success]).to eq(true)
      expect(result[:customer_code].length).to eq(6)
      expect(result[:customer_code]).to eq("due9ah")
    end

    it "return correct code with correct params upper case" do
      result = codecal.code_generate_with_mask("aG2gD8",239851)
      expect(result[:success]).to eq(true)
      expect(result[:customer_code].length).to eq(7)
      expect(result[:customer_code]).to eq("pp326c3")
    end

    it "return correct code with incorrect params error mask" do
      result = codecal.code_generate_with_mask(2356,2)
      expect(result[:success]).to eq(false)
      expect(result[:error]).to match(/mark should be string of letter or number and length should >= 5/)
    end

    it "return correct code with incorrect params error code" do
      result = codecal.code_generate_with_mask("fda3a5s","fdsa")
      expect(result[:success]).to eq(false)
      expect(result[:error]).to match(/the type of the code to be encrypted should be Integer/)
    end
  end

  describe "validate customer code" do
    it "return true when passing correct code" do
      expect(codecal.validate_bank_customer_code("0000012300020052")).to eq(true)
    end

    it "return false when passing wrong code" do
      expect(codecal.validate_bank_customer_code("0000012300020012")).to eq(false)
    end

    it "return false when passing error type code" do
      expect(codecal.validate_bank_customer_code(nil)).to eq(false)
      expect(codecal.validate_bank_customer_code(4234)).to eq(false)
      expect(codecal.validate_bank_customer_code("432432jhk4h3214h321h4321")).to eq(false)
    end
  end

  describe "validate simple code" do
    it "return true when passing correct code" do
      expect(codecal.validate_simple_code("655245")).to eq(true)
    end

    it "return false when passing wrong code" do
      expect(codecal.validate_simple_code("655255")).to eq(false)
    end

    it "return false when passing error type code" do
      expect(codecal.validate_simple_code(nil)).to eq(false)
      expect(codecal.validate_simple_code("3214h32")).to eq(false)
    end
  end

  describe "validate masked code" do
    it "return true when passing correct code" do
      expect(codecal.validate_masked_code("aG2gD8", "pp326c3")).to eq(true)
      expect(codecal.validate_masked_code("tu3a2j", "due9ah")).to eq(true)
    end

    it "return false when passing wrong code" do
      expect(codecal.validate_masked_code("aG2gD8", "qqci5E2")).to eq(false)
      expect(codecal.validate_masked_code("aG2gD8", "qqci5e3")).to eq(false)
      expect(codecal.validate_masked_code("aG2gD8", "badfdsfd")).to eq(false)
      expect(codecal.validate_masked_code("aG2gD8", "2fds3r38q")).to eq(false)
      expect(codecal.validate_masked_code("aG2gD8", "2dsdw8q")).to eq(false)
      expect(codecal.validate_masked_code("aG2gD8", "w8q")).to eq(false)
    end

    it "return false when passing error type" do
      expect(codecal.validate_masked_code(325324, "23q0w8q")).to eq(false)
      expect(codecal.validate_masked_code("aG2gD8", 1654546)).to eq(false)
    end

    it "return false when passing error length" do
      expect(codecal.validate_masked_code("a", "23q0w8q")).to eq(false)
      expect(codecal.validate_masked_code("aG2gD8", "234")).to eq(false)
    end
  end

  describe "get unmasked code" do
    it "return code when passing correct masked code" do
      unmasked_code = codecal.get_unmasked_code("as4kgm3y", "y4k7ds6c")
      generated_code = codecal.simple_code_generate(1025725)
      expect(unmasked_code).to eq(generated_code[:customer_code])
    end

    it "return false when passing wrong masked code" do
      expect(codecal.get_unmasked_code("as4kgm3y", "3124fds1")).to eq(false)
    end

    it "return false when passing illegal masked code" do
      expect(codecal.get_unmasked_code("as4kgm3y", "38t1")).to eq(false)
      expect(codecal.get_unmasked_code("as4", "38tfdsa1")).to eq(false)
    end
  end

  describe "get currency name" do
    it "return true when passing correct code" do
      expect(codecal.get_currency_name("0001")).to eq("BTC")
    end

    it "return false when passing error type code" do
      expect(codecal.get_currency_name(nil)).to eq(nil)
      expect(codecal.get_currency_name(4234)).to eq(nil)
      expect(codecal.get_currency_name(4234)).to eq(nil)
      expect(codecal.get_currency_name("432432jhk4h3214h321h4321")).to eq(nil)
    end
  end

  describe "generate with wrong params" do

    it "raise error with nil parameters type" do
      result = codecal.bank_customer_code_generate(nil,nil)
      expect(result[:success]).to eq(false)
      expect(result[:error]).to match(/parameter is nil./)
    end

    it "raise error with wrong parameters type" do
      result = codecal.bank_customer_code_generate(1230,1234)
      expect(result[:success]).to eq(false)
      expect(result[:error]).to match(/type should be String/)
    end

    it "raise error with wrong parameters type" do
      result = codecal.bank_customer_code_generate("fda",1234)
      expect(result[:success]).to eq(false)
      expect(result[:error]).to match(/type should be Integer and length not longer than/)
    end

    it "raise error with wrong parameters length" do
      result = codecal.bank_customer_code_generate(5354233243241321,"fsda")
      expect(result[:success]).to eq(false)
      expect(result[:error]).to match(/type should be Integer and length not longer than/)
    end
    
  end

  describe "generate with currency code not exist" do

    it "raise error with wrong currency name" do
      result = codecal.bank_customer_code_generate(1230,"1234")
      expect(result[:success]).to eq(false)
      expect(result[:error]).to match(/currency not found/)
    end
  end

  ## customerize mask alphabet

  describe "customerize mask_alphabet" do
    let(:custom_calc) { Codecal::Calc.new('fdsa32jkh89704lncmxzvrueopwytq') }

    describe "generate masked code" do
      it "return correct code with correct params longer than 6" do
        result = custom_calc.code_generate_with_mask("ag2gd8",239851)
        expect(result[:success]).to eq(true)
        expect(result[:customer_code].length).to eq(7)
        expect(result[:customer_code]).to eq("ss87lh8")
      end
  
      it "return correct code with correct params shorter than 6" do
        result = custom_calc.code_generate_with_mask("tu3a2j",2)
        expect(result[:success]).to eq(true)
        expect(result[:customer_code].length).to eq(6)
        expect(result[:customer_code]).to eq("nzvaf3")
      end
  
      it "return correct code with correct params upper case" do
        result = custom_calc.code_generate_with_mask("aG2gD8",239851)
        expect(result[:success]).to eq(true)
        expect(result[:customer_code].length).to eq(7)
        expect(result[:customer_code]).to eq("ss87lh8")
      end
  
      it "return correct code with incorrect params error mask" do
        result = custom_calc.code_generate_with_mask(2356,2)
        expect(result[:success]).to eq(false)
        expect(result[:error]).to match(/mark should be string of letter or number and length should >= 5/)
      end
  
      it "return correct code with incorrect params error code" do
        result = custom_calc.code_generate_with_mask("fda3a5s","fdsa")
        expect(result[:success]).to eq(false)
        expect(result[:error]).to match(/the type of the code to be encrypted should be Integer/)
      end
    end

    describe "validate masked code" do
      it "return true correct code, mask and mask alphabet" do
        expect(custom_calc.validate_masked_code("aG2gD8", "ss87lh8")).to eq(true)
        expect(codecal.validate_masked_code("aG2gD8", "ss87lh8")).to eq(false)
      end
    end
  end
end
