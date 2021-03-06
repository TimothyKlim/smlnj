(* COPYRIGHT (c) 1997 Bell Labs, Lucent Technologies *)
(* binfile.sig *)

signature BINFILE = sig

    exception FormatError

    exception Compile of string
    exception TopLevelException of exn
    exception SilentException

    type bfContent

    type pid = PersStamps.persstamp
    type senv = StaticEnv.staticEnv
    type symenv = SymbolicEnv.symenv
    type denv = DynamicEnv.dynenv
    type env = Environment.environment

    val staticPidOf: bfContent -> pid
    val exportPidOf: bfContent -> pid option
    val lambdaPidOf: bfContent -> pid
    val cmDataOf: bfContent -> pid list
    val senvOf: bfContent -> senv
    val symenvOf: bfContent -> symenv

    val size: { content: bfContent, nopickle: bool } -> int

    val create: { splitting: Control.LambdaSplitting.localsetting,
		  cmData: pid list,
		  ast: Ast.dec,
		  source: Source.inputSource,
		  senv:  senv,
		  symenv: symenv }
	-> bfContent

    type stats = { env: int, inlinfo: int, data: int, code: int }

    val read:
	{ name: string, stream: BinIO.instream, modmap: ModuleId.tmap } ->
	{ content: bfContent, stats: stats }

    val write:
	{ stream: BinIO.outstream, content: bfContent, nopickle: bool } ->
	stats

    val exec: bfContent * denv -> denv
end (* signature BINFILE *)

