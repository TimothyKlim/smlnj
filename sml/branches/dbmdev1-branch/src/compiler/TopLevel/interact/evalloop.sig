(* Copyright 1996 by Bell Laboratories *)
(* evalloop.sig *)
 
signature EVALLOOP =
sig
  exception Interrupt 

  val interact    : unit -> unit
  val evalStream  : string * TextIO.instream -> unit

  val installCompManagers:
      { manageImport : Ast.dec * EnvRef.envref -> unit,
	managePrint : Symbol.symbol * EnvRef.envref -> unit,
	getPending : unit -> Symbol.symbol list } -> unit

end (* signature EVALLOOP *)
