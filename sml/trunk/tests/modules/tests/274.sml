signature S =
sig
  structure A : sig type t end
  structure B : sig type s = A.t end
end
