(** {0 Xlib bindings} *)

(** {1 Display functions} *)

type display

type window

(** {2 Opening the Display} *)

val xOpenDisplay : ?name:string -> unit -> display
(** To open a connection to the X server that controls a display, use [xOpenDisplay] *)

(** {2 Obtaining Information about the Display, Image Formats, or Screens} *)

val xDefaultRootWindow : display -> window
(** Return the root window for the default screen. *)

(** {2 Generating a NoOperation Protocol Request} *)

val xNoOp : display -> unit

(** {2 Freeing Client-Created Data} *)

(* val xFree : ? -> unit *)

(** {2 Closing the Display} *)

val xCloseDisplay : display -> unit

val xSetCloseDownMode : display -> int -> unit

(** {1 Event Handling Functions } *)

val xSync : display -> discard:bool -> unit

(** {1 Inter-Client Communication Functions} *)

val xStoreName : display -> window -> string -> unit
