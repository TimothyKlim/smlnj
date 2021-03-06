(*
 * This module ties together all the visualization backends.
 *
 * -- Allen
 *)

structure AllDisplays : GRAPH_DISPLAY =
struct

   val viewer = MLRiscControl.getString "viewer"

   fun visualize print =
       (case !viewer of
          "daVinci" => daVinci.visualize print
        | "vcg"     => VCG.visualize print
        | _         => daVinci.visualize print
       )

   fun program() =
       (case !viewer of
          "daVinci" => daVinci.program()
        | "vcg"     => VCG.program()
        | _         => daVinci.program()
       )

   fun suffix() =
       (case !viewer of
          "daVinci" => daVinci.suffix()
        | "vcg"     => VCG.suffix()
        | _         => daVinci.suffix()
       )

end
