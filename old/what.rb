class Integer
  alias to_str to_s
end

begin
  0.eql? '0'
rescue
  exit if $!.message == "0==0\n\n  0 == '0'\n    ^^"
  raise
end
puts "not the same"
