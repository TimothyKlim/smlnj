(* WARNING: this is generated by running 'nowhere x86Peephole.peep'.
 * Do not edit this file directly.
 * Version 1.2
 *)

(*#line 20.1 "x86Peephole.peep"*)
functor X86Peephole(X86Instr : X86INSTR): PEEPHOLE =
struct

(*#line 22.4 "x86Peephole.peep"*)
   structure I = X86Instr

(*#line 23.4 "x86Peephole.peep"*)
   structure C = I.C

(*#line 24.4 "x86Peephole.peep"*)
   structure CBase = CellsBasis

(*#line 27.4 "x86Peephole.peep"*)
   fun peephole instrs = 
       let 
(*#line 28.8 "x86Peephole.peep"*)
           fun isStackPtr (I.Direct r) = CBase.sameColor (r, C.esp)
             | isStackPtr _ = false

(*#line 31.8 "x86Peephole.peep"*)
           fun isZero (I.Immed n) = n = 0
             | isZero (I.ImmedLabel le) = (I.LabelExp.valueOf le) = 0
             | isZero _ = false

(*#line 35.8 "x86Peephole.peep"*)
           fun isZeroOpt NONE = true
             | isZeroOpt (SOME opn) = isZero opn

(*#line 38.8 "x86Peephole.peep"*)
           fun loop (code, instrs) = 
               let val v_32 = code
                   fun state_9 (v_0, v_3) = 
                       let val i = v_0
                           and rest = v_3
                       in loop (rest, i :: instrs)
                       end
                   fun state_21 (v_0, v_16, v_3) = 
                       let val le = v_16
                           and rest = v_3
                       in (if ((I.LabelExp.valueOf le) = 0)
                             then (loop (rest, instrs))
                             else (state_9 (v_0, v_3)))
                       end
                   fun state_49 (v_0, v_1, v_2, v_3) = 
                       (case v_1 of
                         I.Direct v_25 => 
                         let val dst = v_1
                             and rest = v_3
                             and src = v_2
                         in (if (isZero src)
                               then (loop (rest, (I.BINARY {binOp=I.XORL, src=dst, dst=dst}) :: instrs))
                               else (state_9 (v_0, v_3)))
                         end
                       | _ => state_9 (v_0, v_3)
                       )
               in 
                  (case v_32 of
                    op :: v_31 => 
                    let val (v_0, v_3) = v_31
                    in 
                       (case v_0 of
                         I.BINARY v_18 => 
                         let val {binOp=v_30, dst=v_1, src=v_2, ...} = v_18
                         in 
                            (case v_30 of
                              I.ADDL => 
                              (case v_2 of
                                I.Immed v_16 => 
                                (case v_1 of
                                  I.Direct v_25 => 
                                  (case v_3 of
                                    op :: v_13 => 
                                    let val (v_12, v_4) = v_13
                                    in 
                                       (case v_12 of
                                         I.BINARY v_11 => 
                                         let val {binOp=v_10, dst=v_9, src=v_8, ...} = v_11
                                         in 
                                            (case v_10 of
                                              I.SUBL => 
                                              (case v_9 of
                                                I.Direct v_5 => 
                                                (case v_8 of
                                                  I.Immed v_7 => 
                                                  let val d_i = v_25
                                                      and d_j = v_5
                                                      and m = v_7
                                                      and n = v_16
                                                      and rest = v_4
                                                  in (if ((CBase.sameColor (d_i, C.esp)) andalso (CBase.sameColor (d_j, C.esp)))
                                                        then (if (m = n)
                                                          then (loop (rest, instrs))
                                                          else (if (m < n)
                                                          then (loop (rest, (I.BINARY {binOp=I.ADDL, src=I.Immed (n - m), dst=I.Direct C.esp}) :: instrs))
                                                          else (loop (rest, (I.BINARY {binOp=I.SUBL, src=I.Immed (m - n), dst=I.Direct C.esp}) :: instrs))))
                                                        else (state_9 (v_0, v_3)))
                                                  end
                                                | _ => state_9 (v_0, v_3)
                                                )
                                              | _ => state_9 (v_0, v_3)
                                              )
                                            | _ => state_9 (v_0, v_3)
                                            )
                                         end
                                       | _ => state_9 (v_0, v_3)
                                       )
                                    end
                                  | nil => state_9 (v_0, v_3)
                                  )
                                | _ => state_9 (v_0, v_3)
                                )
                              | I.ImmedLabel v_16 => state_21 (v_0, v_16, v_3)
                              | _ => state_9 (v_0, v_3)
                              )
                            | I.SUBL => 
                              (case v_2 of
                                I.Immed v_16 => 
                                (case v_1 of
                                  I.Direct v_25 => 
                                  (case v_16 of
                                    4 => 
                                    (case v_3 of
                                      op :: v_13 => 
                                      let val (v_12, v_4) = v_13
                                      in 
                                         (case v_12 of
                                           I.MOVE v_11 => 
                                           let val {dst=v_9, mvOp=v_27, src=v_8, ...} = v_11
                                           in 
                                              (case v_9 of
                                                I.Displace v_5 => 
                                                let val {base=v_26, disp=v_29, ...} = v_5
                                                in 
                                                   (case v_29 of
                                                     I.Immed v_28 => 
                                                     (case v_28 of
                                                       0 => 
                                                       (case v_27 of
                                                         I.MOVL => 
                                                         let val base = v_26
                                                          and dst_i = v_25
                                                          and rest = v_4
                                                          and src = v_8
                                                         in (if (((CBase.sameColor (base, C.esp)) andalso (CBase.sameColor (dst_i, C.esp))) andalso (not (isStackPtr src)))
                                                          then (loop (rest, (I.PUSHL src) :: instrs))
                                                          else (state_9 (v_0, v_3)))
                                                         end
                                                       | _ => state_9 (v_0, v_3)
                                                       )
                                                     | _ => state_9 (v_0, v_3)
                                                     )
                                                   | _ => state_9 (v_0, v_3)
                                                   )
                                                end
                                              | _ => state_9 (v_0, v_3)
                                              )
                                           end
                                         | _ => state_9 (v_0, v_3)
                                         )
                                      end
                                    | nil => state_9 (v_0, v_3)
                                    )
                                  | _ => state_9 (v_0, v_3)
                                  )
                                | _ => state_9 (v_0, v_3)
                                )
                              | I.ImmedLabel v_16 => state_21 (v_0, v_16, v_3)
                              | _ => state_9 (v_0, v_3)
                              )
                            | _ => state_9 (v_0, v_3)
                            )
                         end
                       | I.LEA v_18 => 
                         let val {addr=v_24, r32=v_19, ...} = v_18
                         in 
                            (case v_24 of
                              I.Displace v_23 => 
                              let val {base=v_21, disp=v_22, ...} = v_23
                              in 
                                 (case v_22 of
                                   I.ImmedLabel v_20 => 
                                   let val base = v_21
                                       and le = v_20
                                       and r32 = v_19
                                       and rest = v_3
                                   in (if (((I.LabelExp.valueOf le) = 0) andalso (CBase.sameColor (r32, base)))
                                         then (loop (rest, instrs))
                                         else (state_9 (v_0, v_3)))
                                   end
                                 | _ => state_9 (v_0, v_3)
                                 )
                              end
                            | _ => state_9 (v_0, v_3)
                            )
                         end
                       | I.MOVE v_18 => 
                         let val {dst=v_1, mvOp=v_17, src=v_2, ...} = v_18
                         in 
                            (case v_17 of
                              I.MOVL => 
                              (case v_2 of
                                I.Displace v_16 => 
                                let val {base=v_6, disp=v_15, ...} = v_16
                                in 
                                   (case v_15 of
                                     I.Immed v_14 => 
                                     (case v_14 of
                                       0 => 
                                       (case v_3 of
                                         op :: v_13 => 
                                         let val (v_12, v_4) = v_13
                                         in 
                                            (case v_12 of
                                              I.BINARY v_11 => 
                                              let val {binOp=v_10, dst=v_9, src=v_8, ...} = v_11
                                              in 
                                                 (case v_10 of
                                                   I.ADDL => 
                                                   (case v_9 of
                                                     I.Direct v_5 => 
                                                     (case v_8 of
                                                       I.Immed v_7 => 
                                                       (case v_7 of
                                                         4 => 
                                                         let val base = v_6
                                                          and dst = v_1
                                                          and dst_i = v_5
                                                          and rest = v_4
                                                         in (if (((CBase.sameColor (base, C.esp)) andalso (CBase.sameColor (dst_i, C.esp))) andalso (not (isStackPtr dst)))
                                                          then (loop (rest, (I.POP dst) :: instrs))
                                                          else (state_49 (v_0, v_1, v_2, v_3)))
                                                         end
                                                       | _ => state_49 (v_0, v_1, v_2, v_3)
                                                       )
                                                     | _ => state_49 (v_0, v_1, v_2, v_3)
                                                     )
                                                   | _ => state_49 (v_0, v_1, v_2, v_3)
                                                   )
                                                 | _ => state_49 (v_0, v_1, v_2, v_3)
                                                 )
                                              end
                                            | _ => state_49 (v_0, v_1, v_2, v_3)
                                            )
                                         end
                                       | nil => state_49 (v_0, v_1, v_2, v_3)
                                       )
                                     | _ => state_49 (v_0, v_1, v_2, v_3)
                                     )
                                   | _ => state_49 (v_0, v_1, v_2, v_3)
                                   )
                                end
                              | _ => state_49 (v_0, v_1, v_2, v_3)
                              )
                            | _ => state_9 (v_0, v_3)
                            )
                         end
                       | _ => state_9 (v_0, v_3)
                       )
                    end
                  | nil => instrs
                  )
               end
       in loop (instrs, [])
       end
end

