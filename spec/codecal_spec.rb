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
