require "spec_helper"

RSpec.describe Codecal do
  it "has a version number" do
    expect(Codecal::VERSION).not_to be nil
  end

  describe "generate correct code" do
    it "return correct code with correct params upcase" do
      result = Codecal.bank_customer_code_generate(1230,"HSR")
      expect(result[:success]).to eq(true)
      expect(result[:customer_code].length).to eq(16)
      expect(result[:customer_code]).to eq("0000012300020052")
    end

    it "return correct code with correct params downcase" do
      result = Codecal.bank_customer_code_generate(1230,"eth")
      expect(result[:success]).to eq(true)
      expect(result[:customer_code].length).to eq(16)
      expect(result[:customer_code]).to eq("0000012300002056")
    end
  end

  describe "generate simple correct code" do
    it "return correct code with correct params upcase" do
      result = Codecal.simple_code_generate("65524")
      expect(result[:success]).to eq(true)
      expect(result[:customer_code].length).to eq(6)
      expect(result[:customer_code]).to eq("655245")
    end

    it "return correct code with correct params upcase" do
      result = Codecal.simple_code_generate("000035465265524")
      expect(result[:success]).to eq(true)
      expect(result[:customer_code].length).to eq(12)
      expect(result[:customer_code]).to eq("354652655242")
    end

  end

  describe "generate masked code" do
    it "return correct code with correct params longer than 6" do
      result = Codecal.code_generate_with_mask("ag2gd8",239851)
      expect(result[:success]).to eq(true)
      expect(result[:customer_code].length).to eq(7)
      expect(result[:customer_code]).to eq("qqci5e2")
    end

    it "return correct code with correct params shorter than 6" do
      result = Codecal.code_generate_with_mask("tu3a2j",2)
      expect(result[:success]).to eq(true)
      expect(result[:customer_code].length).to eq(6)
      expect(result[:customer_code]).to eq("rkuyip")
    end

    it "return correct code with correct params upper case" do
      result = Codecal.code_generate_with_mask("aG2gD8",239851)
      expect(result[:success]).to eq(true)
      expect(result[:customer_code].length).to eq(7)
      expect(result[:customer_code]).to eq("qqci5e2")
    end

    it "return correct code with incorrect params error mask" do
      result = Codecal.code_generate_with_mask(2356,2)
      expect(result[:success]).to eq(false)
      expect(result[:error]).to match(/mark should be string of letter or number and length should >= 5/)
    end

    it "return correct code with incorrect params error code" do
      result = Codecal.code_generate_with_mask("fda3a5s","fdsa")
      expect(result[:success]).to eq(false)
      expect(result[:error]).to match(/the type of the code to be encrypted should be Integer/)
    end
  end

  describe "validate customer code" do
    it "return true when passing correct code" do
      expect(Codecal.validate_bank_customer_code("0000012300020052")).to eq(true)
    end

    it "return false when passing wrong code" do
      expect(Codecal.validate_bank_customer_code("0000012300020012")).to eq(false)
    end

    it "return false when passing error type code" do
      expect(Codecal.validate_bank_customer_code(nil)).to eq(false)
      expect(Codecal.validate_bank_customer_code(4234)).to eq(false)
      expect(Codecal.validate_bank_customer_code("432432jhk4h3214h321h4321")).to eq(false)
    end
  end

  describe "validate simple code" do
    it "return true when passing correct code" do
      expect(Codecal.validate_simple_code("655245")).to eq(true)
    end

    it "return false when passing wrong code" do
      expect(Codecal.validate_simple_code("655255")).to eq(false)
    end

    it "return false when passing error type code" do
      expect(Codecal.validate_simple_code(nil)).to eq(false)
      expect(Codecal.validate_simple_code("3214h32")).to eq(false)
    end
  end

  describe "validate masked code" do
    it "return true when passing correct code" do
      expect(Codecal.validate_masked_code("aG2gD8", "qqci5e2")).to eq(true)
      expect(Codecal.validate_masked_code("tu3a2j", "rkuyip")).to eq(true)
    end

    it "return false when passing wrong code" do
      expect(Codecal.validate_masked_code("aG2gD8", "qqci5E2")).to eq(false)
      expect(Codecal.validate_masked_code("aG2gD8", "qqci5e3")).to eq(false)
      expect(Codecal.validate_masked_code("aG2gD8", "badfdsfd")).to eq(false)
      expect(Codecal.validate_masked_code("aG2gD8", "2fds3r38q")).to eq(false)
      expect(Codecal.validate_masked_code("aG2gD8", "2dsdw8q")).to eq(false)
      expect(Codecal.validate_masked_code("aG2gD8", "w8q")).to eq(false)
    end

    it "return false when passing error type" do
      expect(Codecal.validate_masked_code(325324, "23q0w8q")).to eq(false)
      expect(Codecal.validate_masked_code("aG2gD8", 1654546)).to eq(false)
    end

    it "return false when passing error length" do
      expect(Codecal.validate_masked_code("a", "23q0w8q")).to eq(false)
      expect(Codecal.validate_masked_code("aG2gD8", "234")).to eq(false)
    end
  end

  describe "get unmasked code" do
    it "return code when passing correct masked code" do
      unmasked_code = Codecal.get_unmasked_code("as4kgm3y", "5b8hmeus")
      generated_code = Codecal.simple_code_generate(1025725)
      expect(unmasked_code).to eq(generated_code[:customer_code])
    end

    it "return false when passing wrong masked code" do
      expect(Codecal.get_unmasked_code("as4kgm3y", "3124fds1")).to eq(false)
    end

    it "return false when passing illegal masked code" do
      expect(Codecal.get_unmasked_code("as4kgm3y", "38t1")).to eq(false)
      expect(Codecal.get_unmasked_code("as4", "38tfdsa1")).to eq(false)
    end
  end

  describe "get currency name" do
    it "return true when passing correct code" do
      expect(Codecal.get_currency_name("0001")).to eq("BTC")
    end

    it "return false when passing error type code" do
      expect(Codecal.get_currency_name(nil)).to eq(nil)
      expect(Codecal.get_currency_name(4234)).to eq(nil)
      expect(Codecal.get_currency_name(4234)).to eq(nil)
      expect(Codecal.get_currency_name("432432jhk4h3214h321h4321")).to eq(nil)
    end
  end

  describe "generate with wrong params" do

    it "raise error with nil parameters type" do
      result = Codecal.bank_customer_code_generate(nil,nil)
      expect(result[:success]).to eq(false)
      expect(result[:error]).to match(/parameter is nil./)
    end

    it "raise error with wrong parameters type" do
      result = Codecal.bank_customer_code_generate(1230,1234)
      expect(result[:success]).to eq(false)
      expect(result[:error]).to match(/type should be String/)
    end

    it "raise error with wrong parameters type" do
      result = Codecal.bank_customer_code_generate("fda",1234)
      expect(result[:success]).to eq(false)
      expect(result[:error]).to match(/type should be Integer and length not longer than/)
    end

    it "raise error with wrong parameters length" do
      result = Codecal.bank_customer_code_generate(5354233243241321,"fsda")
      expect(result[:success]).to eq(false)
      expect(result[:error]).to match(/type should be Integer and length not longer than/)
    end
    
  end

  describe "generate with currency code not exist" do

    it "raise error with wrong currency name" do
      result = Codecal.bank_customer_code_generate(1230,"1234")
      expect(result[:success]).to eq(false)
      expect(result[:error]).to match(/currency not found/)
    end
  end
end
