(*
 * This just provide a very simple pretty printing function.
 * It is used for visualization.
 *
 * -- Allen 
 * 
 *)

signature FORMAT_INSTRUCTION =
sig
   structure I  : INSTRUCTIONS

   val toString : Annotations.annotations -> (I.C.cell -> I.C.cell) -> 
                    I.instruction -> string

end

functor FormatInstruction(Asm : INSTRUCTION_EMITTER) : FORMAT_INSTRUCTION =
struct
   structure I = Asm.I

   fun toString an regmap insn =
   let val buffer = StringOutStream.mkStreamBuf()
       val S      = StringOutStream.openStringOut buffer
       val ()     = AsmStream.withStream S 
                     (fn insn => 
                      let val Asm.S.STREAM{emit,...} = Asm.makeStream an
                      in emit regmap insn
                      end) insn
       val text   = StringOutStream.getString buffer
       fun isSpace #" "  = true
         | isSpace #"\t" = true
         | isSpace _     = false
       val text   = foldr (fn (x,"") => x | (x,y) => x^" "^y) ""
                          (String.tokens isSpace text)
       fun stripNL "" = ""
         | stripNL s =
       let fun f(0) = ""
             | f(i) = if String.sub(s,i) = #"\n" then f(i-1)
                      else String.extract(s,0,SOME(i+1))
       in  f(size s - 1) end  
   in  stripNL text end

end

