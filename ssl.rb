require 'openssl'
include OpenSSL

cipher = OpenSSL::Cipher.new 'AES-128-CBC'
key = OpenSSL::PKey::RSA.new 2048
#csr = OpenSSL::X509::Request.new File.read 'csr.pem'

#Create a key
open 'private_key.pem', 'w' do |io| io.write key.to_pem end
open 'public_key.pem', 'w' do |io| io.write key.public_key.to_pem end

#Encrypt and export
pass_phrase = 'hello word'

key_secure = key.export cipher, pass_phrase

open 'private.secure.pem', 'w' do |io|
  io.write key_secure
end



#Loading
key_pr = OpenSSL::PKey::RSA.new File.read 'private_key.pem'
key_pu = OpenSSL::PKey::RSA.new File.read 'public_key.pem'
key_prs = OpenSSL::PKey::RSA.new File.read 'private.secure.pem'

puts key_pu.public?
puts key_pr.private?

#Encrypt and decrypt

public_encrypted = key_pu.public_encrypt 'top secret document'
private_encrypted = key_prs.private_encrypt 'public release document'

puts key_prs.private_decrypt public_encrypted
puts key_pu.public_decrypt private_encrypted


