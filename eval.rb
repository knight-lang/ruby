alias d define_singleton_method
d(:N){nil};d(:T){true};d(:F){false};d(:'@'){[]}
d(:O){(m=_1.to_s.dup).delete_suffix!('\\') ? print(m) : print(m, "\n")}

def p!
  $src.slice! /\A(\s+|\#.*)*/
  case
  when $src.slice!(/\A\d+/) then $&.to_i
  when $src.slice!(/\A('[^']*'|"[^"]*")/) then $&
  when $src.slice!(/\A[a-z_][a-z_0-9]*/) then "@#$&"
  when $src.slice!(/\A;/) then "#{p!};#{p!}"
  when $src.slice!(/\A=/) then "#{p!}=(#{p!})"
  when $src.slice!(/\A(?:([A-Z])[A-Z_]*|(.))/)
    m = method $+ rescue abort "unknown token start: #$+"
    "send(#{$+.inspect},#{m.arity.times.map{p!}.join','})"
  else raise "unknown token strip: #{$src[0]}"
  end
end

# ## Sets `$Reply` To the amount of arguments the Knight function in `$1` expects.
# arity () case $1 in
#   [PR])                    Reply=0 ;;
#   [][\$OEBCQ\!LD,AV\~])    Reply=1 ;;
#   [-+\*/%^\?\<\>\&\|\;=W]) Reply=2 ;;
#   [GI])                    Reply=3 ;;
#   S)                       Reply=4 ;;
#   *) die 'unknown function: %s' "$1" ;;
# esac
$src = DATA.read
eval p p!
__END__
; = a ;3 @
OUTPUT a
# Recursive naive fibonacci.

# Set the `fibonacci` variable to the given `BLOCK`. This is how Knight programs
# define their own "function"s, which are executed via the `CALL` function.
#
# Unlike functions in other languages, `BLOCK`s in Knight cannot be passed any
# arguments (which makes them dramatically more easy to implement), and Knight
# programs have to rely upon the caller setting variables before `CALL`ing them.
; = fibonacci BLOCK (
  IF (< n 2) (
    : n
  ) (
    ; = n - n 1

    # This uses the fact that Knight evaluates expressions in the order
    # they're encountered, so the `n` in `- n (; ...)` cannot be clobbered
    # by the `fibonacci` call.
    ; = n - n (; (= tmp CALL fibonacci) 1)
    : + tmp CALL fibonacci
  )
)

; = n 10
: OUTPUT CALL fibonacci

