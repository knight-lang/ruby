require_relative 'stream'
stream = Kn::Stream.new(<<EOS)
OUTPUT 34
EOS

p stream.parse!
