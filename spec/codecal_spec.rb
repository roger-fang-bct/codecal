require "spec_helper"

RSpec.describe Codecal do
  it "has a version number" do
    expect(Codecal::VERSION).not_to be nil
  end

  describe "generate correct code" do
    it "return correct code with correct params" do
      customer_code = Codecal.bank_customer_code_generate(1230,"HSR")
      expect(customer_code.length).to eq(16)
      expect(customer_code).to eq("0000012300020052")
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
      expect(Codecal.validate_bank_customer_code(4234)).to eq(false)
      expect(Codecal.validate_bank_customer_code("432432jhk4h3214h321h4321")).to eq(false)
    end
  end
  
  describe "generate with wrong params" do

    it "raise error with wrong parameters type" do
      expect { Codecal.bank_customer_code_generate(1230,1234) }.to raise_error(/type should be String/)
    end

    it "raise error with wrong parameters type" do
      expect { Codecal.bank_customer_code_generate("fda",1234) }.to raise_error(/type should be Integer and length not longer than/)
    end

    it "raise error with wrong parameters length" do
      expect { Codecal.bank_customer_code_generate(5354233243241321,"fsda") }.to raise_error(/type should be Integer and length not longer than/)
    end
    
  end

  describe "generate with currency code not exist" do

    it "raise error with wrong currency name" do
      expect { Codecal.bank_customer_code_generate(1230,"1234") }.to raise_error(/currency not found/)
    end
  end
end
