type display

type window

external xOpenDisplay_ : string -> display = "caml_x11_XOpenDisplay"

let xOpenDisplay ?name () =
  let name =
    match name with
    | Some name -> name
    | None -> ( try Sys.getenv "DISPLAY" with Not_found -> ":0")
  in
  xOpenDisplay_ name

external xDefaultRootWindow : display -> window = "caml_x11_XDefaultRootWindow"

external xNoOp : display -> unit = "caml_x11_XNoOp"

external xCloseDisplay : display -> unit = "caml_x11_XCloseDisplay"

external xSetCloseDownMode : display -> int -> unit = "caml_x11_XSetCloseDownMode"

external xSync : display -> discard:bool -> unit = "caml_x11_XSync"

external xStoreName : display -> window -> string -> unit
  = "caml_x11_XStoreName"
