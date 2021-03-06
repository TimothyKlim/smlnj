(*
 * Emit code and build a CFG
 *
 * -- Allen
 *)

signature CONTROL_FLOW_GRAPH_GEN =
sig

   structure CFG : CONTROL_FLOW_GRAPH
   structure I   : INSTRUCTIONS
   structure S   : INSTRUCTION_STREAM
       sharing CFG.I = I
       sharing S.P   = CFG.P

   (*
    * This creates an emitter which can be used to build a CFG
    *)
   val builder : CFG.cfg -> 
      { stream : (I.instruction -> unit,
                  I.C.regmap,
                  Annotations.annotations,
                  I.C.cellset,
                  I.C.cell * I.C.cell,'e) S.stream,
        next   : CFG.cfg -> unit (* start with a new CFG *)
      }

end
