module Xlib : sig
  type display
  type window

  val xOpenDisplay : string -> display
  val open_display : ?name:string -> unit -> display
  val xCloseDisplay : display -> unit
  val xSync : display -> discard:bool -> unit
  val xDefaultRootWindow : display -> window
  val xStoreName : display -> window -> string -> unit
end
