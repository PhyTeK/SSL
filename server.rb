require 'socket'
require 'openssl'

key_pem = File.read 'private.secure.pem'

pass_phrase = 'my secure pass phrase goes here'
key = OpenSSL::PKey::RSA.new key_pem, pass_phrase
cert = OpenSSL::X509::Certificate.new File.read 'certificate.pem'

context = OpenSSL::SSL::SSLContext.new
context.cert = cert
context.key = key

tcp_server = TCPServer.new 5000

ssl_server = OpenSSL::SSL::SSLServer.new tcp_server, context

loop do

  ssl_connection = ssl_server.accept

  data = connection.gets

  response = "Retrieved Data #{data.dump}"

  puts response

  connection.puts "Data Retrieved: #{data.dump}"

  connection.close

end

ca_name = OpenSSL::X509::Name.parse 'CN=ca/DC=example'

ca_cert = OpenSSL::X509::Certificate.new
ca_cert.serial = 0
ca_cert.version = 2
ca_cert.not_before = Time.now
ca_cert.not_after = Time.now + 86400

ca_cert.public_key = ca_key.public_key
ca_cert.subject = ca_name
ca_cert.issuer = ca_name

extension_factory = OpenSSL::X509::ExtensionFactory.new
extension_factory.subject_certificate = ca_cert
extension_factory.issuer_certificate = ca_cert

ca_cert.add_extension    extension_factory.create_extension('subjectKeyIdentifier', 'hash')
ca_cert.add_extension    extension_factory.create_extension('basicConstraints', 'CA:TRUE', true)
ca_cert.add_extension    extension_factory.create_extension(
    'keyUsage', 'cRLSign,keyCertSign', true)
ca_cert.sign ca_key, OpenSSL::Digest::SHA1.new
open 'ca_cert.pem', 'w' do |io|
  io.write ca_cert.to_pem
end
csr = OpenSSL::X509::Request.new
csr.version = 0
csr.subject = name
csr.public_key = key.public_key
csr.sign key, OpenSSL::Digest::SHA1.new
open 'csr.pem', 'w' do |io|
  io.write csr.to_pem
end