require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Crypto Providers wrappers" do

  describe Sorcery::CryptoProviders::MD5 do
    
    after(:each) do
      Sorcery::CryptoProviders::MD5.reset!
    end
    
    it "encrypt works via wrapper like normal lib" do
      Sorcery::CryptoProviders::MD5.encrypt('Noam Ben-Ari').should == Digest::MD5.hexdigest('Noam Ben-Ari')
    end
    
    it "works with multiple stretches" do
      Sorcery::CryptoProviders::MD5.stretches = 3
      Sorcery::CryptoProviders::MD5.encrypt('Noam Ben-Ari').should == Digest::MD5.hexdigest(Digest::MD5.hexdigest(Digest::MD5.hexdigest('Noam Ben-Ari')))
    end
    
    it "matches? returns true when matches" do
      Sorcery::CryptoProviders::MD5.matches?(Digest::MD5.hexdigest('Noam Ben-Ari'), 'Noam Ben-Ari').should be_true
    end
    
    it "matches? returns false when no match" do
      Sorcery::CryptoProviders::MD5.matches?(Digest::MD5.hexdigest('Noam Ben-Ari'), 'Some Dude').should be_false
    end
    
  end
  
  describe Sorcery::CryptoProviders::SHA1 do
    
    before(:all) do
      @digest = 'Noam Ben-Ari'
      10.times {@digest = Digest::SHA1.hexdigest(@digest)}
    end
    
    after(:each) do
      Sorcery::CryptoProviders::SHA1.reset!
    end
    
    it "encrypt works via wrapper like normal lib" do
      Sorcery::CryptoProviders::SHA1.encrypt('Noam Ben-Ari').should == @digest
    end
    
    it "works with multiple stretches" do
      Sorcery::CryptoProviders::SHA1.stretches = 3
      Sorcery::CryptoProviders::SHA1.encrypt('Noam Ben-Ari').should == Digest::SHA1.hexdigest(Digest::SHA1.hexdigest(Digest::SHA1.hexdigest('Noam Ben-Ari')))
    end
    
    it "matches? returns true when matches" do
      Sorcery::CryptoProviders::SHA1.matches?(@digest, 'Noam Ben-Ari').should be_true
    end
    
    it "matches? returns false when no match" do
      Sorcery::CryptoProviders::SHA1.matches?(@digest, 'Some Dude').should be_false
    end
    
  end

  describe Sorcery::CryptoProviders::SHA256 do
    
    before(:all) do
      @digest = 'Noam Ben-Ari'
      20.times {@digest = Digest::SHA256.hexdigest(@digest)}
    end
    
    after(:each) do
      Sorcery::CryptoProviders::SHA256.reset!
    end
    
    it "encrypt works via wrapper like normal lib" do
      Sorcery::CryptoProviders::SHA256.encrypt('Noam Ben-Ari').should == @digest
    end
    
    it "works with multiple stretches" do
      Sorcery::CryptoProviders::SHA256.stretches = 3
      Sorcery::CryptoProviders::SHA256.encrypt('Noam Ben-Ari').should == Digest::SHA256.hexdigest(Digest::SHA256.hexdigest(Digest::SHA256.hexdigest('Noam Ben-Ari')))
    end
    
    it "matches? returns true when matches" do
      Sorcery::CryptoProviders::SHA256.matches?(@digest, 'Noam Ben-Ari').should be_true
    end
    
    it "matches? returns false when no match" do
      Sorcery::CryptoProviders::SHA256.matches?(@digest, 'Some Dude').should be_false
    end
    
  end
  
  describe Sorcery::CryptoProviders::SHA512 do
    
    before(:all) do
      @digest = 'Noam Ben-Ari'
      20.times {@digest = Digest::SHA512.hexdigest(@digest)}
    end
    
    after(:each) do
      Sorcery::CryptoProviders::SHA512.reset!
    end
    
    it "encrypt works via wrapper like normal lib" do
      Sorcery::CryptoProviders::SHA512.encrypt('Noam Ben-Ari').should == @digest
    end
    
    it "works with multiple stretches" do
      Sorcery::CryptoProviders::SHA512.stretches = 3
      Sorcery::CryptoProviders::SHA512.encrypt('Noam Ben-Ari').should == Digest::SHA512.hexdigest(Digest::SHA512.hexdigest(Digest::SHA512.hexdigest('Noam Ben-Ari')))
    end
    
    it "matches? returns true when matches" do
      Sorcery::CryptoProviders::SHA512.matches?(@digest, 'Noam Ben-Ari').should be_true
    end
    
    it "matches? returns false when no match" do
      Sorcery::CryptoProviders::SHA512.matches?(@digest, 'Some Dude').should be_false
    end
    
  end
  
  describe Sorcery::CryptoProviders::AES256 do
    
    before(:all) do
      aes = OpenSSL::Cipher::Cipher.new("AES-256-ECB")
      aes.encrypt
      @key = "asd234dfs423fddsmndsflktsdf32343"
      aes.key = @key
      @digest = 'Noam Ben-Ari'
      @digest = [aes.update(@digest) + aes.final].pack("m").chomp
      Sorcery::CryptoProviders::AES256.key = @key
    end
    
    it "encrypt works via wrapper like normal lib" do
      Sorcery::CryptoProviders::AES256.encrypt('Noam Ben-Ari').should == @digest
    end
    
    it "matches? returns true when matches" do
      Sorcery::CryptoProviders::AES256.matches?(@digest, 'Noam Ben-Ari').should be_true
    end
    
    it "matches? returns false when no match" do
      Sorcery::CryptoProviders::AES256.matches?(@digest, 'Some Dude').should be_false
    end
    
    it "can be decrypted" do
      aes = OpenSSL::Cipher::Cipher.new("AES-256-ECB")
      aes.decrypt
      aes.key = @key
      (aes.update(@digest.unpack("m").first) + aes.final).should == "Noam Ben-Ari"
    end

  end
  
  describe Sorcery::CryptoProviders::BCrypt do
    
    before(:all) do
      @digest = BCrypt::Password.create('Noam Ben-Ari', :cost => 10)
    end
    
    after(:each) do
      Sorcery::CryptoProviders::BCrypt.reset!
    end
    
    it "should be comparable with original secret" do
      BCrypt::Password.new(Sorcery::CryptoProviders::BCrypt.encrypt('Noam Ben-Ari')).should == 'Noam Ben-Ari'
    end
    
    it "works with multiple costs" do
      Sorcery::CryptoProviders::BCrypt.cost = 3
      BCrypt::Password.new(Sorcery::CryptoProviders::BCrypt.encrypt('Noam Ben-Ari')).should == 'Noam Ben-Ari'
    end
    
    it "matches? returns true when matches" do
      Sorcery::CryptoProviders::BCrypt.matches?(@digest, 'Noam Ben-Ari').should be_true
    end
    
    it "matches? returns false when no match" do
      Sorcery::CryptoProviders::BCrypt.matches?(@digest, 'Some Dude').should be_false
    end
    
  end
  
end
