(* registry-sig.sml
 *
 * COPYRIGHT (c) 2002 Bell Labs, Lucent Technologies
 *
 * A registry collects together string controls; it supports generation
 * of help messages and initialization from the environment.
 *)

signature CONTROL_REGISTRY =
  sig

    type registry

    val new : {
	    help : string	(* registry's description *)
	  } -> registry

  (* register a control *)
    val register : registry -> {
	    ctl : string Controls.control,
	    envName : string option
	  } -> unit

  (* register a set of controls *)
    val registerSet : registry -> {
	    ctls : (string, 'a) ControlSet.control_set,
	    mkEnvName : string -> string option
	  } -> unit

  (* nest a registry inside another registry *)
    val nest : registry -> {
	    prefix : string option,
	    pri : Controls.priority,	(* registry's priority *)
            obscurity : int,		(* registry's detail level; higher means *)
					(* more obscure *)
	    reg : registry
	  } -> unit

  (* find a control *)
    val control : registry -> string list -> string Controls.control option

  (* initialize the controls in the registry from the environment *)
    val init : registry -> unit

    datatype registry_tree = RTree of {
	path : string list,
	help : string,
	ctls : string Controls.control list,
	subregs : registry_tree list
      }

    val controls : (registry * int option) -> registry_tree

  end
