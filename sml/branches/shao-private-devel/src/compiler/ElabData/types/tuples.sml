(* Copyright 1989 by AT&T Bell Laboratories *)
(* tuples.sml *)

(* 
 * TUPLES and Tuples should be called RECORDS and Records, since 
 * records are the primary concept, and tuples are a derived form. 
 *)
signature TUPLES = 
sig

  val numlabel : int -> Types.label
  val mkTUPLEtyc : int -> Types.tycon
  val isTUPLEtyc : Types.tycon -> bool
  val mkRECORDtyc : Types.label list -> Types.tycon

end  (* signature TUPLES *)

structure Tuples : TUPLES = struct

open Types

datatype labelOpt = NOlabel | SOMElabel of label
datatype tyconOpt = NOtycon | SOMEtycon of tycon

structure LabelArray = DynamicArrayFn (
  struct
    open Array
    type array = labelOpt array
    type vector = labelOpt vector
    type elem = labelOpt
  end)

structure TyconArray = DynamicArrayFn (
  struct
    open Array
    type array = tyconOpt array
    type vector = tyconOpt vector
    type elem = tyconOpt
  end)

exception New
val tyconTable = IntStrMap.new(32,New) : tycon IntStrMap.intstrmap
val tyconMap = IntStrMap.map tyconTable
val tyconAdd = IntStrMap.add tyconTable

fun labelsToSymbol(labels: label list) : Symbol.symbol =
    let fun wrap [] = ["}"]
	  | wrap [id] = [Symbol.name id, "}"]
	  | wrap (id::rest) = Symbol.name id :: "," :: wrap rest
     in Symbol.tycSymbol(concat("{" :: wrap labels))
    end

(* this is an optimization to make similar record tycs point to the same thing,
	thus speeding equality testing on them *)
fun mkRECORDtyc labels = 
    let val recordName = labelsToSymbol labels
        val number = Symbol.number recordName
        val name = Symbol.name recordName
     in tyconMap(number,name)
	handle New =>
	  let val tycon = RECORDtyc labels
	   in tyconAdd(number,name,tycon);
	      tycon
	  end
    end

val numericLabels = LabelArray.array(0,NOlabel)
val tupleTycons = TyconArray.array(0,NOtycon)

fun numlabel i =
    case LabelArray.sub(numericLabels,i)
      of NOlabel =>
	   let val newlabel = Symbol.labSymbol(Int.toString i)
	    in LabelArray.update(numericLabels,i,SOMElabel(newlabel));
	       newlabel
	   end
       | SOMElabel(label) => label

fun numlabels n =
    let fun labels (0,acc) = acc
	  | labels (i,acc) = labels (i-1, numlabel i :: acc)
    in labels (n,nil)
    end

fun mkTUPLEtyc n =
    case TyconArray.sub(tupleTycons,n)
      of NOtycon =>
           let val tycon = mkRECORDtyc(numlabels n)
	    in TyconArray.update(tupleTycons,n,SOMEtycon(tycon));
	       tycon
	   end
       | SOMEtycon(tycon) => tycon

fun checklabels (2,nil) = false   (* {1:t} is not a tuple *)
  | checklabels (n,nil) = true
  | checklabels (n, lab::labs) = 
	Symbol.eq(lab, numlabel n) andalso checklabels(n+1,labs)

fun isTUPLEtyc(RECORDtyc labels) = checklabels(1,labels)
  | isTUPLEtyc _ = false
    
end (* structure Tuples *)
