(*
 * Here is an encoding of our canonical style example.
 * It uses boxes, frames, buttons, shapes and shells.
 * When you get a signature for styles, I'll modify
 * these widgets to use them.
 *
 * This example begins to raise the question as to how
 * much control we can have via resources. For example,
 * it's hard to see how box glue can be handled dynamically.
 *)
structure VKBD :
  sig val keyboard : Widget.root -> unit end =
  struct
    open Box
    val kbd_data = [
            ["1","2","3","4","5","6","7","8","9","0"],
            ["q","w","e","r","t","y","u","i","o","p"],
            ["a","s","d","f","g","h","j","k","l",";"],
            ["z","x","c","v","b","n","m",",",".","/"]
          ]
    val pad_data = [
            ["7","8","9"],
            ["4","5","6"],
            ["1","2","3"],
            ["","0",""]
          ]
    fun mkB root syms = let
          val glue = Glue{nat = 10, min = 10, max = SOME 10}
          val flex_glue = Glue{nat = 10, min = 0, max = NONE}
          fun action sym = fn () => CIO.print(implode["key ",sym,"\n"])
          fun args sym = {rounded=true,backgrnd=NONE,foregrnd=NONE,label=sym,action= action sym}
          fun mkBut ("",buts) = flex_glue::buts
            | mkBut (sym,buts) = let
                val b = Button.mkTextCmd root (args sym)
                val but = Shape.mkRigid (Button.widgetOf b)
                in glue::(WBox but)::buts end
          fun mkRow (syms,rows) = let
                val row = HzCenter(fold mkBut syms [glue])
                in glue::row::rows end
          val w = widgetOf (mkLayout root (VtCenter(fold mkRow syms [glue])))
          val black = EXeneBase.blackOfScr (Widget.screenOf root)
          in
            Frame.widgetOf(Frame.mkFrame {color=SOME black,width=2,widget=w})
          end

    fun keyboard root = let
          val keypad = mkB root pad_data
          val keyboard = mkB root kbd_data
          val topw = mkLayout root (VtCenter [
                  Glue{nat = 10, min = 10, max = SOME 10},
                  HzCenter [
                    Glue{nat = 10, min = 10, max = SOME 10},
                    WBox keyboard,
                    Glue{nat = 10, min = 10, max = SOME 10},
                    WBox keypad,
                    Glue{nat = 10, min = 10, max = SOME 10}
                  ],
                  Glue{nat = 10, min = 10, max = SOME 10}
                ])
          val shell = Shell.mkShell (widgetOf topw, NONE, {win_name = NONE, icon_name = NONE})
          in
            Shell.init shell;
            CIO.input_line CIO.std_in;
            RunCML.shutdown()
          end
  end

fun doit () = RunEXene.runWArgs VKBD.keyboard {dpy=SOME "",timeq=NONE}
