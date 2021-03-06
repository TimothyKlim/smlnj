(*
 * Copyright 1998 by Bell Laboratories
 *  generic-vc.sml -- machine independent part of viscomp
 *
 * by Matthias Blume (10/1998)
 *)

structure GenericVC : GENERIC_VC = struct
    structure Stats = Stats
    structure Control = Control
    structure Source = Source
    structure SourceMap = SourceMap
    structure ErrorMsg = ErrorMsg
    structure Symbol = Symbol
    structure SymPath = SymPath
    structure StaticEnv = StaticEnv
    structure DynamicEnv = DynamicEnv
    structure BareEnvironment = Environment
    structure Environment = CMEnv.Env
    structure CoerceEnv = CoerceEnv
    structure EnvRef = EnvRef
    structure ModuleId = ModuleId
    structure CMStaticEnv = CMStaticEnv
    structure PersStamps = PersStamps
    structure PrettyPrint = PrettyPrint
    structure PPTable =	struct
	val install_pp 
            : string list -> (PrettyPrint.ppstream -> 'a -> unit) -> unit
	    = Unsafe.cast PPTable.install_pp
    end (* PPTable *)
    structure Ast = Ast
    structure SmlFile = SmlFile
    structure Rehash = struct
	val rehash = PickMod.repickleEnvHash
    end

    structure PrintHooks : PRINTHOOKS = struct
	fun prAbsyn env d  = 
	       PrettyPrint.with_pp (ErrorMsg.defaultConsumer())
	                 (fn ppstrm => PPAbsyn.ppDec(env,NONE) ppstrm (d,200))
    end
(*
  structure AllocProf =
    struct
      val reset = AllocProf.reset
      val print = AllocProf.print_profile_info
    end
*)
    val version = Version.version
    val banner = Version.banner
end

