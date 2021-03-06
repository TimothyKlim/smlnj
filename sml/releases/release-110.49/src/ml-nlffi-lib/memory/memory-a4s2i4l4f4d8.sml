(*
 * Primitives for "raw" memory access.
 *
 * x86/Sparc/PPC version:
 *     addr char short  int  long float double
 *     4    1    2      4    4    4     8       (bytes)
 *
 *   (C) 2001, Lucent Technologies, Bell Laboratories
 *
 * author: Matthias Blume (blume@research.bell-labs.com)
 *)
structure CMemory : CMEMORY = struct
    exception OutOfMemory

    type addr = Word32.word
    val null = 0w0 : addr
    fun isNull a = a = null
    infix ++ --
    (* rely on 2's-complement for the following... *)
    fun (a: addr) ++ i = a + Word32.fromInt i
    val compare = Word32.compare
    fun a1 -- a2 = Word32.toIntX (a1 - a2)

    val addr_size = 0w4
    val char_size = 0w1
    val short_size = 0w2
    val int_size = 0w4
    val long_size = 0w4
    val float_size = 0w4
    val double_size = 0w8

    val load_addr = RawMemInlineT.w32l
    val load_uchar = RawMemInlineT.w8l
    val load_schar = RawMemInlineT.i8l
    val load_ushort = RawMemInlineT.w16l
    val load_sshort = RawMemInlineT.i16l
    val load_uint = RawMemInlineT.w32l
    val load_sint = RawMemInlineT.i32l
    val load_ulong = RawMemInlineT.w32l
    val load_slong = RawMemInlineT.i32l
    val load_float = RawMemInlineT.f32l
    val load_double = RawMemInlineT.f64l

    val store_addr = RawMemInlineT.w32s
    val store_uchar = RawMemInlineT.w8s
    val store_schar = RawMemInlineT.i8s
    val store_ushort = RawMemInlineT.w16s
    val store_sshort = RawMemInlineT.i16s
    val store_uint = RawMemInlineT.w32s
    val store_sint = RawMemInlineT.i32s
    val store_ulong = RawMemInlineT.w32s
    val store_slong = RawMemInlineT.i32s
    val store_float = RawMemInlineT.f32s
    val store_double = RawMemInlineT.f64s

    val int_bits = Word.fromInt Word32.wordSize

    (* this needs to be severely optimized... *)
    fun bcopy { from: addr, to: addr, bytes: word } =
	if bytes > 0w0 then
	    (store_uchar (to, load_uchar from);
	     bcopy { from = from + 0w1, to = to + 0w1, bytes = bytes - 0w1 })
	else ()

    local
	structure DL = DynLinkage
	fun main's s = DL.lib_symbol (DL.main_lib, s)
	val malloc_h = main's "malloc"
	val free_h = main's "free"
	fun sys_malloc (n : Word32.word) = let
	    val w_p = RawMemInlineT.rawccall :
		      Word32.word * Word32.word * (unit * word -> string) list
		      -> Word32.word
	    val a = w_p (DL.addr malloc_h, n, [])
	in
	    if a = 0w0 then raise OutOfMemory else a
	end
	fun sys_free (a : Word32.word) = let
	    val p_u = RawMemInlineT.rawccall :
		      Word32.word * Word32.word * (unit * string -> unit) list
		      -> unit
	in
	    p_u (DL.addr free_h, a, [])
	end
    in
        fun alloc bytes = sys_malloc (Word.toLargeWord bytes)
	fun free a = sys_free a
    end

    (* types used in C calling convention *)
    type cc_addr = Word32.word
    type cc_schar = Int32.int
    type cc_uchar = Word32.word
    type cc_sint = Int32.int
    type cc_uint = Word32.word
    type cc_sshort = Int32.int
    type cc_ushort = Word32.word
    type cc_slong = Int32.int
    type cc_ulong = Word32.word
    type cc_float = Real.real
    type cc_double = Real.real

    (* wrapping and unwrapping for cc types *)
    fun wrap_addr (x : addr) = x : cc_addr
    fun wrap_schar (x : MLRep.Signed.int) = x : cc_schar
    fun wrap_uchar (x : MLRep.Unsigned.word) = x : cc_uchar
    fun wrap_sint (x : MLRep.Signed.int) = x : cc_sint
    fun wrap_uint (x : MLRep.Unsigned.word) = x : cc_uint
    fun wrap_sshort (x : MLRep.Signed.int) = x : cc_sshort
    fun wrap_ushort (x : MLRep.Unsigned.word) = x : cc_ushort
    fun wrap_slong (x : MLRep.Signed.int) = x : cc_slong
    fun wrap_ulong (x : MLRep.Unsigned.word) = x : cc_ulong
    fun wrap_float (x : MLRep.Real.real) = x : cc_float
    fun wrap_double (x : MLRep.Real.real) = x : cc_double

    fun unwrap_addr (x : cc_addr) = x : addr
    fun unwrap_schar (x : cc_schar) = x : MLRep.Signed.int
    fun unwrap_uchar (x : cc_uchar) = x : MLRep.Unsigned.word
    fun unwrap_sint (x : cc_sint) = x : MLRep.Signed.int
    fun unwrap_uint (x : cc_uint) = x : MLRep.Unsigned.word
    fun unwrap_sshort (x : cc_sshort) = x : MLRep.Signed.int
    fun unwrap_ushort (x : cc_ushort) = x : MLRep.Unsigned.word
    fun unwrap_slong (x : cc_slong) = x : MLRep.Signed.int
    fun unwrap_ulong (x : cc_ulong) = x : MLRep.Unsigned.word
    fun unwrap_float (x : cc_float) = x : MLRep.Real.real
    fun unwrap_double (x : cc_double) = x : MLRep.Real.real

    fun p2i (x : addr) = x : MLRep.Unsigned.word
    fun i2p (x : MLRep.Unsigned.word) = x : addr
end
