#!/usr/bin/env ruby
class Class alias d define_method;alias a alias_method end;class Object;;a:call,
:itself;d(:coerce){[_1,to_int]};d(S=:to_str){to_s rescue call.to_str};d(:falsey?
){to_ary.empty?};d(I=:to_int){to_i rescue call.to_int};;d(A=:to_ary){to_a rescue
call.to_ary}end;class String;a:o,:to_i;d(:to_i){sub(/0d.+/,'').o};a:s,:slice!;a\
A,:chars;a:ascii,:ord;d(:P){s /\A([\s():]|\#.*)+/;s(/\A\d+/)?$&.to_i: s(/\A@/)?[
]:s(/\A[a-z\d_]+/)?:"#$&":s(/\A(['"])(.*?)\1/m)?$2:s(/\A(([TF])|N)[A-Z_]*/)?$2&&
$2==?T:N.new((f=F[s(/\A([A-Z_]+|.)/)[0].intern]),(0...f.arity).map{self.P})}end;
class Integer;a:falsey?,:zero?;a:ascii,:chr;d(A){abs.digits.reverse}end;class<<p
d(:inspect){'null'}end;class Array;d(:*){cycle(_1.to_int).to_a};a I,:size;;a:**,
:join;d(S){join ?\n}end;class<<!p;;d(:<=>){to_int<=>!_1.falsey?};d(A){[self]};d(
I){1}end;class Symbol;$V={};d(:call){$V[self]};undef to_s;end;class<<!0;;d(I){0}
d(A){[]};d(:<=>){to_int<=>!_1.falsey?}end;class N;d(:initialize){@v,@a=_1,_2};d(
:call){@v.(*@a)};undef to_s;end;F={
  P:->{gets&.chomp},
  R:->{rand 0xffffffff},
  B:->{_1},
  C:->{_1.().()},
  Q:->{exit _1.to_int},
  D:->{$><<(q=_1.()).inspect;q},
  O:->{/\K(\\)?\z/=~_1;print$`,$1?"":"\n"}, #"
  L:->{_1.to_ary.size},
  A:->{_1.().ascii},
  '!':->{_1.falsey?},
  '~':->{-_1.to_int},
  ',':->{[_1.()]},
  '[':->{_1.()[0]},
  ']':->{_1.()[1..]},
  '+':->{_1.()+_2.()},
  '-':->{_1.()-_2.()},
  '*':->{_1.()*(_2.()||0)},
  '/':->{_1.().fdiv(_2.()).truncate},
  '%':->{_1.()%_2.()},
  '^':->{_1.()**_2.()},
  '?':->{_1.().eql?_2.()},
  '<':->{(_1.()<=>_2.())<0},
  '>':->{(_1.()<=>_2.())>0},
  '&':->{(t=_1.()).falsey?? t:_2.()},
  '|':->{(t=_1.()).falsey??_2.():t},
  ';':->{_1.();_2.()},
  '=':->{$V[_1]=_2.()},
}

a,b=$*;$*.clear;(a=='-f'?File.read(b):+b).P.()