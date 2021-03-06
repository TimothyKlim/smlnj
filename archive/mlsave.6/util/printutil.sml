(* printutil.sml *)

structure PrintUtil = struct

fun prstr (s:string) : unit = (print s; ())

fun newline () : unit = (print "\n"; ())

fun tab (n: int): unit =
    if n=0
      then ()
      else (prstr " "; tab(n-1))

fun printSequence (separator: string) (pr:'a->unit) (elems: 'a list) : unit =
    let fun prElems [el] = pr el
	  | prElems (el::rest) =
	      (pr el; prstr separator; prElems rest)
	  | prElems [] = ()
     in prElems elems
    end

fun printClosedSequence (front: string, sep: string, back:string) (pr:'a -> unit)
			(elems : 'a list) : unit =
    (prstr front; printSequence sep pr elems; prstr back)

fun printSym(s: Symbol.symbol) = (print(Symbol.name s); ())
    (* fix -- maybe this belongs in Symbol *)

local
fun decimal i = let val m = Integer.makestring
		in  m(i div 100)^m((i div 10)mod 10)^m(i mod 10) end
val ctrl_a = 1
val ctrl_z = 26
val offset = ord "A" - ctrl_a
val smallestprintable = ord " "
val biggestprintable = ord "~"
fun ml_char "\n" = "\\n"
  | ml_char "\t" = "\\t"
  | ml_char "\\" = "\\\\"
  | ml_char "\"" = "\\\""
  | ml_char c =
	let val char = ord c
	in  if char >= ctrl_a andalso char <= ctrl_z
	    then "\\^" ^ chr(char+offset)
	    else if char >= smallestprintable andalso char <= biggestprintable
		 then c
	    else "\\" ^ decimal char
	end
in
    fun ml_string s = "\"" ^ implode(map ml_char (explode s)) ^ "\""
end

end
