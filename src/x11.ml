module Xlib = struct
  type display
  type window

  external xOpenDisplay : string -> display = "caml_x11_xOpenDisplay"

  let open_display ?name () =
    let name =
      match name with
      | Some name -> name
      | None -> ( try Sys.getenv "DISPLAY" with Not_found -> ":0")
    in
    xOpenDisplay name

  external xCloseDisplay : display -> unit = "caml_x11_xCloseDisplay"

  external xSync : display -> discard:bool -> unit = "caml_x11_xSync"

  external xDefaultRootWindow : display -> window
    = "caml_x11_xDefaultRootWindow"

  external xStoreName : display -> window -> string -> unit
    = "caml_x11_xStoreName"
end
