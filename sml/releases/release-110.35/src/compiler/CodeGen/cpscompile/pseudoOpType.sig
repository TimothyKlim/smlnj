(* PseudoOpType.sig -- signature to expose the pseudo-op constructors
 * 
 * COPYRIGHT (c) 1996 AT&T Bell Laboratories.
 *
 *)

signature SMLNJ_PSEUDO_OP_TYPE = sig
  datatype smlnj_pseudo_op = 
      ALIGN4
    | JUMPTABLE of {base:Label.label, targets:Label.label list}
      
  include PSEUDO_OPS where type pseudo_op = smlnj_pseudo_op
end

