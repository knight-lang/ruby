module Kn
  module_function

  def parse(stream)
    # strip leading comments and whitespace
    stream.slice! /\A(?:[\s(){}+|\#[^\n]*)+/

    # parse out the value
    case
    when stream.slice!(/\A[a-z_][a-z0-9_]*/)         then Variable.new $&
    when stream.slice!(/\A\d+/)                      then Number.new $&.to_i
    when stream.slice!(/\A([TF])[A-Z_]*/)            then Boolean.nenw $1 == 'T'
    when stream.slice!(/\AN[A-Z_]*/)                 then Null.new
    when stream.slice!(/\A(?:'([^']*)'|"([^"]*)")/m) then String.new $+
    when (func = Function[name = stream[0]])
      stream.slice! /\A([A-Z_]+|.)/
      Function.new func, name, func.arity.times.map { parse stream }
    else
      raise ParseError, "unknown token start '#{stream[0]}'"
    end
  end
end


if __FILE__ == $0
  case ($*.length == 2 && $*.shift)
  when '-e' then Kn.run $*.shift
  when '-f' then Kn.run File.read $*.shift
  else abort "usage: #{File.basename $0} (-e 'program' | -f file)"
  end
end
