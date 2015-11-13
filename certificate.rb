require 'openssl'

key_pr = OpenSSL::PKey::RSA.new File.read 'private_key.pem'
key_pu = OpenSSL::PKey::RSA.new File.read 'public_key.pem'
key_prs = OpenSSL::PKey::RSA.new File.read 'private.secure.pem'

name = OpenSSL::X509::Name.parse 'CN=nobody/DC=example'

cert = OpenSSL::X509::Certificate.new
cert.version = 2
cert.serial = 0
cert.not_before = Time.now
cert.not_after = Time.now + 3600

cert.public_key = key_pu.public_key
cert.subject = name

cert.issuer = name
cert.sign key_prs, OpenSSL::Digest::SHA1.new

open 'certificate.pem', 'w' do |io| io.write cert.to_pem end

#Load
cert2 = OpenSSL::X509::Certificate.new File.read 'certificate.pem'
puts cert2
#Verifying
raise 'certificate can not be verified' unless cert2.verify key_pu

#CA Certificate
ca_key = OpenSSL::PKey::RSA.new 2048

cipher = OpenSSL::Cipher::Cipher.new 'AES-128-CBC'

open 'ca_key.pem', 'w' do |io|
  io.write key.export(cipher, pass_phrase)
end

#File.chmod(0400, 'ca_key.pem')


