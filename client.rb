require 'socket'
require 'openssl'

tcp_client = TCPSocket.new 'localhost', 5000
ssl_client = OpenSSL::SSL::SSLSocket.new client_socket, context
ssl_client.connect

ssl_client.puts "hello server!"
puts ssl_client.gets