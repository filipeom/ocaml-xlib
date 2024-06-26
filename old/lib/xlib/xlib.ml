type event_mask =
  | KeyPressMask
  | KeyReleaseMask
  | ButtonPressMask
  | ButtonReleaseMask
  | EnterWindowMask
  | LeaveWindowMask
  | PointerMotionMask
  | PointerMotionHintMask
  | Button1MotionMask
  | Button2MotionMask
  | Button3MotionMask
  | Button4MotionMask
  | Button5MotionMask
  | ButtonMotionMask
  | KeymapStateMask
  | ExposureMask
  | VisibilityChangeMask
  | StructureNotifyMask
  | ResizeRedirectMask
  | SubstructureNotifyMask
  | SubstructureRedirectMask
  | FocusChangeMask
  | PropertyChangeMask
  | ColormapChangeMask
  | OwnerGrabButtonMask

type uint = int
type 'a drawable
type _window
type window = _window drawable
type _pixmap
type pixmap = _pixmap drawable
type gc
type colormap
type atom
type time = int64

(* exposed *)
type keysym = int
type keycode = int

(*
(* abstract *)
type keysym
type keycode

external keysym_of_int: int -> keysym = "%identity"
external int_of_keysym: keysym -> int = "%identity"

external keycode_of_int: int -> keycode = "%identity"
external int_of_keycode: keycode -> int = "%identity"
*)

type display

external xOpenDisplay : name:string -> display = "ml_XOpenDisplay"

let open_display ?name () =
  let name =
    match name with
    | Some id -> id
    | None -> ( try Sys.getenv "DISPLAY" with Not_found -> ":0")
  in
  xOpenDisplay ~name

external xCloseDisplay : display -> unit = "ml_XCloseDisplay"
external xFlush : dpy:display -> unit = "ml_XFlush"
external xBell : dpy:display -> percent:int -> unit = "ml_XBell"

external xLastKnownRequestProcessed : dpy:display -> int
  = "ml_LastKnownRequestProcessed"

(* WIP *)
external xChangeKeyboardControl_bell_percent :
  dpy:display -> bell_percent:int -> unit
  = "ml_XChangeKeyboardControl_bell_percent"

external xChangeKeyboardControl_bell_pitch :
  dpy:display -> bell_pitch:int -> unit = "ml_XChangeKeyboardControl_bell_pitch"

external xChangeKeyboardControl_bell_duration :
  dpy:display -> bell_duration:int -> unit
  = "ml_XChangeKeyboardControl_bell_duration"

external xChangeKeyboardControl_bell :
  dpy:display -> bell_percent:int -> bell_pitch:int -> bell_duration:int -> unit
  = "ml_XChangeKeyboardControl_bell"

external xChangeKeyboardControl_key_click_percent :
  dpy:display -> key_click_percent:int -> unit
  = "ml_XChangeKeyboardControl_key_click_percent"

type close_mode = DestroyAll | RetainPermanent | RetainTemporary

external xSetCloseDownMode : dpy:display -> close_mode:close_mode -> unit
  = "ml_XSetCloseDownMode"

external xSync : dpy:display -> discard:bool -> unit = "ml_XSync"
external xConnectionNumber : dpy:display -> int = "ml_XConnectionNumber"
external xProtocolVersion : dpy:display -> int = "ml_XProtocolVersion"
external xProtocolRevision : dpy:display -> int = "ml_XProtocolRevision"
external xVendorRelease : dpy:display -> int = "ml_XVendorRelease"
external xServerVendor : dpy:display -> string = "ml_XServerVendor"
external xlibSpecificationRelease : unit -> int = "ml_XlibSpecificationRelease"
external xGrabServer : dpy:display -> unit = "ml_XGrabServer"
external xUngrabServer : dpy:display -> unit = "ml_XUngrabServer"
external xUngrabPointer : dpy:display -> time:time -> unit = "ml_XUngrabPointer"

external xUngrabKeyboard : dpy:display -> time:time -> unit
  = "ml_XUngrabKeyboard"

type screen_number = private int

external xDefaultScreen : dpy:display -> screen_number = "ml_XDefaultScreen"

external xDisplayWidth : dpy:display -> scr:screen_number -> int
  = "ml_XDisplayWidth"

external xDisplayHeight : dpy:display -> scr:screen_number -> int
  = "ml_XDisplayHeight"

external xDefaultDepth : dpy:display -> scr:screen_number -> int
  = "ml_XDefaultDepth"

external xListDepths : dpy:display -> scr:screen_number -> int array
  = "ml_XListDepths"

external xDisplayPlanes : dpy:display -> scr:screen_number -> int
  = "ml_XDisplayPlanes"

external xScreenCount : dpy:display -> int = "ml_XScreenCount"

let xScreenNumbers ~dpy =
  let n = xScreenCount ~dpy in
  Array.init n (fun i : screen_number -> Obj.magic i)

type pixel_color

external xBlackPixel : dpy:display -> scr:screen_number -> pixel_color
  = "ml_XBlackPixel"

external xWhitePixel : dpy:display -> scr:screen_number -> pixel_color
  = "ml_XWhitePixel"

type xColor

external new_xColor : unit -> xColor = "ml_alloc_XColor"

external xAllocNamedColor :
  dpy:display -> colormap:colormap -> color_name:string -> xColor * xColor
  = "ml_XAllocNamedColor"

external xColor_set_red : xColor -> int -> unit = "ml_XColor_set_red"
external xColor_set_green : xColor -> int -> unit = "ml_XColor_set_green"
external xColor_set_blue : xColor -> int -> unit = "ml_XColor_set_blue"

external xColor_set_rgb : xColor -> r:int -> g:int -> b:int -> unit
  = "ml_XColor_set_rgb"

type color_flags = DoRed | DoGreen | DoBlue

external xColor_set_flags : xColor -> color_flags list -> unit
  = "ml_XColor_set_flags"

(* type x_color = { *)
(*   xcolor : xColor; *)
(*   set_red : int -> unit; *)
(*   set_green : int -> unit; *)
(*   set_blue : int -> unit; *)
(* } *)

(* let new_x_color () = *)
(*   let xcolor = new_xColor () in *)
(*   xColor_set_flags xcolor [ DoRed; DoGreen; DoBlue ]; *)
(*   { *)
(*     xcolor; *)
(*     set_red = xColor_set_red xcolor; *)
(*     set_green = xColor_set_green xcolor; *)
(*     set_blue = xColor_set_blue xcolor; *)
(*   } *)

external xAllocColor : dpy:display -> colormap:colormap -> xColor -> unit
  = "ml_XAllocColor"

external xAllocColorCells :
  dpy:display ->
  colormap:colormap ->
  contig:bool ->
  nplanes:uint ->
  npixels:uint ->
  uint array * uint array = "ml_XAllocColorCells"

external xAllocColorCellsPixels :
  dpy:display -> colormap:colormap -> contig:bool -> npixels:uint -> uint array
  = "ml_XAllocColorCellsPixels"

external xColor_pixel : xColor -> pixel_color = "ml_XColor_pixel"

external xColor_set_pixel : xColor -> pixel_color -> unit
  = "ml_XColor_set_pixel"

external xQueryColor : dpy:display -> colormap:colormap -> xColor -> unit
  = "ml_XQueryColor"

external xColor_get_red : xColor -> int = "ml_XColor_get_red"
external xColor_get_green : xColor -> int = "ml_XColor_get_green"
external xColor_get_blue : xColor -> int = "ml_XColor_get_blue"
external xColor_get_rgb : xColor -> int * int * int = "ml_XColor_get_rgb"

type visual
type visualID

external xDefaultVisual : dpy:display -> scr:screen_number -> visual
  = "ml_XDefaultVisual"

external visual_red_mask : visual:visual -> int = "ml_Visual_red_mask"
external visual_green_mask : visual:visual -> int = "ml_Visual_green_mask"
external visual_blue_mask : visual:visual -> int = "ml_Visual_blue_mask"
external visual_bits_per_rgb : visual:visual -> int = "ml_Visual_bits_per_rgb"
external visual_visualid : visual:visual -> visualID = "ml_Visual_visualid"
external visual_map_entries : visual:visual -> int = "ml_Visual_map_entries"

type xVisualInfo (* pointer to a structure *)

type xVisualInfo_contents = {
  (* contents of this structure *)
  visual : visual;
  visual_id : visualID;
  screen_number : screen_number;
  depth : int;
  red_mask : uint;
  green_mask : uint;
  blue_mask : uint;
  colormap_size : int;
  bits_per_rgb : int;
}

external xVisualInfo_datas : visual_info:xVisualInfo -> xVisualInfo_contents
  = "ml_XVisualInfo_contents"

external xFree_xVisualInfo : xVisualInfo -> unit = "ml_XFree_XVisualInfo"

type color_class =
  | StaticGray
  | GrayScale
  | StaticColor
  | PseudoColor
  | TrueColor
  | DirectColor

external new_xVisualInfo : unit -> xVisualInfo = "ml_alloc_XVisualInfo"
external xVisualInfo_set_visual : visual -> unit = "ml_XVisualInfo_set_visual"

external xVisualInfo_set_visualid : visualID -> unit
  = "ml_XVisualInfo_set_visualid"

external xVisualInfo_set_screen : screen_number -> unit
  = "ml_XVisualInfo_set_screen"

external xVisualInfo_set_depth : uint -> unit = "ml_XVisualInfo_set_depth"

external xVisualInfo_set_class : color_class -> unit
  = "ml_XVisualInfo_set_class"

external xVisualInfo_set_red_mask : uint -> unit = "ml_XVisualInfo_set_red_mask"

external xVisualInfo_set_green_mask : uint -> unit
  = "ml_XVisualInfo_set_green_mask"

external xVisualInfo_set_blue_mask : uint -> unit
  = "ml_XVisualInfo_set_blue_mask"

external xVisualInfo_set_colormap_size : int -> unit
  = "ml_XVisualInfo_set_colormap_size"

external xVisualInfo_set_bits_per_rgb : int -> unit
  = "ml_XVisualInfo_set_bits_per_rgb"

type visual_info_mask =
  | VisualNoMask
  | VisualIDMask
  | VisualScreenMask
  | VisualDepthMask
  | VisualClassMask
  | VisualRedMaskMask
  | VisualGreenMaskMask
  | VisualBlueMaskMask
  | VisualColormapSizeMask
  | VisualBitsPerRGBMask
  | VisualAllMask

external xGetVisualInfo :
  dpy:display ->
  visual_info_mask list ->
  template:xVisualInfo ->
  xVisualInfo array = "ml_XGetVisualInfo"

external xMatchVisualInfo :
  dpy:display ->
  scr:screen_number ->
  depth:int ->
  color_class:color_class ->
  xVisualInfo = "ml_XMatchVisualInfo"

external xDefaultColormap : dpy:display -> scr:screen_number -> colormap
  = "ml_XDefaultColormap"

external xDisplayCells : dpy:display -> scr:screen_number -> int
  = "ml_XDisplayCells"

type colormap_alloc = AllocNone | AllocAll

external xCreateColormap :
  dpy:display -> win:window -> visual:visual -> alloc:colormap_alloc -> colormap
  = "ml_XCreateColormap"

external xFreeColormap : dpy:display -> colormap:colormap -> unit
  = "ml_XFreeColormap"

external xCopyColormapAndFree : dpy:display -> colormap:colormap -> colormap
  = "ml_XCopyColormapAndFree"

external xSetWindowColormap :
  dpy:display -> win:window -> colormap:colormap -> unit
  = "ml_XSetWindowColormap"

external xInstallColormap : dpy:display -> colormap:colormap -> unit
  = "ml_XInstallColormap"

external xUninstallColormap : dpy:display -> colormap:colormap -> unit
  = "ml_XUninstallColormap"

external xListInstalledColormaps : dpy:display -> win:window -> colormap array
  = "ml_XListInstalledColormaps"

type xSetWindowAttributes

external new_xSetWindowAttributes : unit -> xSetWindowAttributes
  = "ml_XSetWindowAttributes_alloc"

type event_mask_list = event_mask list
type cursor

external winAttr_set_background_pixmap :
  xSetWindowAttributes -> background_pixmap:pixmap -> unit
  = "ml_xSetWindowAttributes_set_background_pixmap"

external winAttr_set_background_pixel :
  xSetWindowAttributes -> background_pixel:pixel_color -> unit
  = "ml_xSetWindowAttributes_set_background_pixel"

external winAttr_set_border_pixmap :
  xSetWindowAttributes -> border_pixmap:pixmap -> unit
  = "ml_xSetWindowAttributes_set_border_pixmap"

external winAttr_set_border_pixel :
  xSetWindowAttributes -> border_pixel:pixel_color -> unit
  = "ml_xSetWindowAttributes_set_border_pixel"

external winAttr_set_bit_gravity :
  xSetWindowAttributes -> bit_gravity:int -> unit
  = "ml_xSetWindowAttributes_set_bit_gravity"

external winAttr_set_win_gravity :
  xSetWindowAttributes -> win_gravity:int -> unit
  = "ml_xSetWindowAttributes_set_win_gravity"

external winAttr_set_backing_store :
  xSetWindowAttributes -> backing_store:int -> unit
  = "ml_xSetWindowAttributes_set_backing_store"

external winAttr_set_backing_planes :
  xSetWindowAttributes -> backing_planes:uint -> unit
  = "ml_xSetWindowAttributes_set_backing_planes"

external winAttr_set_backing_pixel :
  xSetWindowAttributes -> backing_pixel:uint -> unit
  = "ml_xSetWindowAttributes_set_backing_pixel"

external winAttr_set_save_under :
  xSetWindowAttributes -> save_under:bool -> unit
  = "ml_xSetWindowAttributes_set_save_under"

external winAttr_set_event_mask :
  xSetWindowAttributes -> event_mask:event_mask_list -> unit
  = "ml_xSetWindowAttributes_set_event_mask"

external winAttr_set_do_not_propagate_mask :
  xSetWindowAttributes -> do_not_propagate_mask:int -> unit
  = "ml_xSetWindowAttributes_set_do_not_propagate_mask"

external winAttr_set_override_redirect :
  xSetWindowAttributes -> override_redirect:bool -> unit
  = "ml_xSetWindowAttributes_set_override_redirect"

external winAttr_set_colormap :
  xSetWindowAttributes -> colormap:colormap -> unit
  = "ml_xSetWindowAttributes_set_colormap"

external winAttr_set_cursor : xSetWindowAttributes -> cursor:cursor -> unit
  = "ml_xSetWindowAttributes_set_cursor"

type set_win_attr = {
  attr : xSetWindowAttributes;
  set_background_pixmap : background_pixmap:pixmap -> unit;
  set_background_pixel : background_pixel:pixel_color -> unit;
  set_border_pixmap : border_pixmap:pixmap -> unit;
  set_border_pixel : border_pixel:pixel_color -> unit;
  set_bit_gravity : bit_gravity:int -> unit;
  set_win_gravity : win_gravity:int -> unit;
  set_backing_store : backing_store:int -> unit;
  set_backing_planes : backing_planes:uint -> unit;
  set_backing_pixel : backing_pixel:uint -> unit;
  set_save_under : save_under:bool -> unit;
  set_event_mask : event_mask:event_mask_list -> unit;
  set_do_not_propagate_mask : do_not_propagate_mask:int -> unit;
  set_override_redirect : override_redirect:bool -> unit;
  set_colormap : colormap:colormap -> unit;
  set_cursor : cursor:cursor -> unit;
}
(** a record to replace all the [winAttr_set_*] functions *)

let new_win_attr () =
  let wa = new_xSetWindowAttributes () in
  {
    attr = wa;
    set_background_pixmap = winAttr_set_background_pixmap wa;
    set_background_pixel = winAttr_set_background_pixel wa;
    set_border_pixmap = winAttr_set_border_pixmap wa;
    set_border_pixel = winAttr_set_border_pixel wa;
    set_bit_gravity = winAttr_set_bit_gravity wa;
    set_win_gravity = winAttr_set_win_gravity wa;
    set_backing_store = winAttr_set_backing_store wa;
    set_backing_planes = winAttr_set_backing_planes wa;
    set_backing_pixel = winAttr_set_backing_pixel wa;
    set_save_under = winAttr_set_save_under wa;
    set_event_mask = winAttr_set_event_mask wa;
    set_do_not_propagate_mask = winAttr_set_do_not_propagate_mask wa;
    set_override_redirect = winAttr_set_override_redirect wa;
    set_colormap = winAttr_set_colormap wa;
    set_cursor = winAttr_set_cursor wa;
  }

external xRootWindow : dpy:display -> scr:screen_number -> window
  = "ml_XRootWindow"

external xDefaultRootWindow : dpy:display -> window = "ml_XDefaultRootWindow"

type focus_state = RevertToParent | RevertToPointerRoot | RevertToNone

external xGetInputFocus : dpy:display -> window option * focus_state
  = "ml_XGetInputFocus"

let root_win ~dpy ?scr () =
  let scr = match scr with Some scr -> scr | None -> xDefaultScreen ~dpy in
  let win = xRootWindow ~dpy ~scr in
  win

external xCreateSimpleWindow :
  dpy:display ->
  parent:window ->
  x:int ->
  y:int ->
  width:uint ->
  height:uint ->
  border_width:uint ->
  border_color:pixel_color ->
  background:pixel_color ->
  window = "ml_XCreateSimpleWindow_bytecode" "ml_XCreateSimpleWindow"

let simple_window ~dpy ?parent ?(x = 0) ?(y = 0) ?(width = 0xFF)
    ?(height = 0xFF) ?(border_width = 0x01) ?border_color ?background () =
  let d, s = (dpy, xDefaultScreen ~dpy) in

  let parent =
    match parent with Some v -> v | None -> xRootWindow ~dpy:d ~scr:s
  and border_color =
    match border_color with Some v -> v | None -> xBlackPixel ~dpy:d ~scr:s
  and background =
    match background with Some v -> v | None -> xWhitePixel ~dpy:d ~scr:s
  in
  xCreateSimpleWindow ~dpy ~parent ~x ~y ~width ~height ~border_width
    ~border_color ~background

external xDestroyWindow : dpy:display -> win:window -> unit
  = "ml_XDestroyWindow"

external xid : int -> 'a = "caml_get_xid"
external xid_of_window : window -> int = "caml_get_xid_of_window"

external xStoreName : dpy:display -> win:window -> name:string -> unit
  = "ml_XStoreName"

external xFetchName : dpy:display -> win:window -> string = "ml_XFetchName"

external xSelectInput :
  dpy:display -> win:window -> event_mask:event_mask list -> unit
  = "ml_XSelectInput"

external xMapWindow : dpy:display -> win:window -> unit = "ml_XMapWindow"

external xMapSubwindows : dpy:display -> win:window -> unit
  = "ml_XMapSubwindows"

external xMapRaised : dpy:display -> win:window -> unit = "ml_XMapRaised"
external xUnmapWindow : dpy:display -> win:window -> unit = "ml_XUnmapWindow"

type window_class = CopyFromParent | InputOutput | InputOnly

type winattr_valuemask =
  | CWBackPixmap
  | CWBackPixel
  | CWBorderPixmap
  | CWBorderPixel
  | CWBitGravity
  | CWWinGravity
  | CWBackingStore
  | CWBackingPlanes
  | CWBackingPixel
  | CWOverrideRedirect
  | CWSaveUnder
  | CWEventMask
  | CWDontPropagate
  | CWColormap
  | CWCursor

external xCreateWindow :
  dpy:display ->
  parent:window ->
  x:int ->
  y:int ->
  width:uint ->
  height:uint ->
  border_width:uint ->
  depth:int ->
  win_class:window_class ->
  visual:visual ->
  valuemask:winattr_valuemask list ->
  attributes:xSetWindowAttributes ->
  window = "ml_XCreateWindow_bytecode" "ml_XCreateWindow"

type winattr =
  | BackPixmap of pixmap
  | BackPixel of pixel_color
  | BorderPixmap of pixmap
  | BorderPixel of pixel_color
  | BitGravity of int
  | WinGravity of int
  | BackingStore of int
  | BackingPlanes of uint
  | BackingPixel of uint
  | OverrideRedirect of bool
  | SaveUnder of bool
  | EventMask of event_mask_list
  | DontPropagate of int
  | Colormap of colormap
  | Cursor of cursor

let create_window ~dpy ~parent ~x ~y ~width ~height ~border_width ~depth
    ~win_class ~visual ~win_attrs =
  let wa = new_xSetWindowAttributes () in
  let valuemask =
    List.map
      (function
        | BackPixmap background_pixmap ->
            winAttr_set_background_pixmap wa ~background_pixmap;
            CWBackPixmap
        | BackPixel background_pixel ->
            winAttr_set_background_pixel wa ~background_pixel;
            CWBackPixel
        | BorderPixmap border_pixmap ->
            winAttr_set_border_pixmap wa ~border_pixmap;
            CWBorderPixmap
        | BorderPixel border_pixel ->
            winAttr_set_border_pixel wa ~border_pixel;
            CWBorderPixel
        | BitGravity bit_gravity ->
            winAttr_set_bit_gravity wa ~bit_gravity;
            CWBitGravity
        | WinGravity win_gravity ->
            winAttr_set_win_gravity wa ~win_gravity;
            CWWinGravity
        | BackingStore backing_store ->
            winAttr_set_backing_store wa ~backing_store;
            CWBackingStore
        | BackingPlanes backing_planes ->
            winAttr_set_backing_planes wa ~backing_planes;
            CWBackingPlanes
        | BackingPixel backing_pixel ->
            winAttr_set_backing_pixel wa ~backing_pixel;
            CWBackingPixel
        | OverrideRedirect override_redirect ->
            winAttr_set_override_redirect wa ~override_redirect;
            CWOverrideRedirect
        | SaveUnder save_under ->
            winAttr_set_save_under wa ~save_under;
            CWSaveUnder
        | EventMask event_mask ->
            winAttr_set_event_mask wa ~event_mask;
            CWEventMask
        | DontPropagate do_not_propagate_mask ->
            winAttr_set_do_not_propagate_mask wa ~do_not_propagate_mask;
            CWDontPropagate
        | Colormap colormap ->
            winAttr_set_colormap wa ~colormap;
            CWColormap
        | Cursor cursor ->
            winAttr_set_cursor wa ~cursor;
            CWCursor)
      win_attrs
  in
  xCreateWindow ~dpy ~parent ~x ~y ~width ~height ~border_width ~depth
    ~win_class ~visual ~valuemask ~attributes:wa

external xResizeWindow :
  dpy:display -> win:window -> width:uint -> height:uint -> unit
  = "ml_XResizeWindow"

external xMoveWindow : dpy:display -> win:window -> x:int -> y:int -> unit
  = "ml_XMoveWindow"

external xMoveResizeWindow :
  dpy:display ->
  win:window ->
  x:int ->
  y:int ->
  width:uint ->
  height:uint ->
  unit = "ml_XMoveResizeWindow_bytecode" "ml_XMoveResizeWindow"

external xLowerWindow : dpy:display -> win:window -> unit = "ml_XLowerWindow"
external xRaiseWindow : dpy:display -> win:window -> unit = "ml_XRaiseWindow"

external xQueryTree :
  dpy:display -> win:window -> window * window * window array = "ml_XQueryTree"

external xRestackWindows : dpy:display -> win:window array -> unit
  = "ml_XRestackWindows"

external xCirculateSubwindowsDown : dpy:display -> win:window -> unit
  = "ml_XCirculateSubwindowsDown"

external xCirculateSubwindowsUp : dpy:display -> win:window -> unit
  = "ml_XCirculateSubwindowsUp"

type circulate_subwindows_direction = RaiseLowest | LowerHighest

external xCirculateSubwindows :
  dpy:display -> win:window -> dir:circulate_subwindows_direction -> unit
  = "ml_XCirculateSubwindows"

type req_type = Atom of atom | AnyPropertyType

external xGetWindowProperty_string :
  dpy:display ->
  win:window ->
  property:atom ->
  long_offset:int ->
  long_length:int ->
  delete:bool ->
  req_type:req_type ->
  atom
  * (* actual_type *)
    int
  * (* actual_format *)
    int
  * (* nitems *)
    int
  * (* bytes_after *)
    string (* prop_return *)
  = "ml_XGetWindowProperty_string_bytecode" "ml_XGetWindowProperty_string"

external xGetWindowProperty_window :
  dpy:display ->
  win:window ->
  property:atom ->
  long_offset:int ->
  long_length:int ->
  delete:bool ->
  req_type:req_type ->
  atom
  * (* actual_type *)
    int
  * (* actual_format *)
    int
  * (* nitems *)
    int
  * (* bytes_after *)
    window (* prop_return *)
  = "ml_XGetWindowProperty_window_bytecode" "ml_XGetWindowProperty_window"

external hasWindowProperty : dpy:display -> win:window -> property:atom -> bool
  = "ml_hasWindowProperty"

type xScreen

external xDefaultScreenOfDisplay : dpy:display -> xScreen
  = "ml_XDefaultScreenOfDisplay"

external xScreenOfDisplay : dpy:display -> scr:screen_number -> xScreen
  = "ml_XScreenOfDisplay"

external xDefaultVisualOfScreen : xScreen -> visual
  = "ml_XDefaultVisualOfScreen"

external xRootWindowOfScreen : xScreen -> window = "ml_XRootWindowOfScreen"
external xBlackPixelOfScreen : xScreen -> pixel_color = "ml_XBlackPixelOfScreen"
external xWhitePixelOfScreen : xScreen -> pixel_color = "ml_XWhitePixelOfScreen"

external xDefaultColormapOfScreen : xScreen -> colormap
  = "ml_XDefaultColormapOfScreen"

external xDefaultDepthOfScreen : xScreen -> int = "ml_XDefaultDepthOfScreen"
external xDefaultGCOfScreen : xScreen -> gc = "ml_XDefaultGCOfScreen"
external xDisplayOfScreen : xScreen -> display = "ml_XDisplayOfScreen"
external xWidthOfScreen : xScreen -> int = "ml_XWidthOfScreen"
external xHeightOfScreen : xScreen -> int = "ml_XHeightOfScreen"

external xScreenNumberOfScreen : xScreen -> screen_number
  = "ml_XScreenNumberOfScreen"

type xWindowAttributes

external xGetWindowAttributes : dpy:display -> win:window -> xWindowAttributes
  = "ml_XGetWindowAttributes"

external xWindowAttributes_x : xWindowAttributes -> int
  = "ml_XWindowAttributes_x"

external xWindowAttributes_y : xWindowAttributes -> int
  = "ml_XWindowAttributes_y"

external xWindowAttributes_width : xWindowAttributes -> int
  = "ml_XWindowAttributes_width"

external xWindowAttributes_height : xWindowAttributes -> int
  = "ml_XWindowAttributes_height"

external xWindowAttributes_depth : xWindowAttributes -> int
  = "ml_XWindowAttributes_depth"

external xWindowAttributes_screen : xWindowAttributes -> xScreen
  = "ml_XWindowAttributes_screen"

external xWindowAttributes_border_width : xWindowAttributes -> int
  = "ml_XWindowAttributes_border_width"

external xWindowAttributes_colormap : xWindowAttributes -> colormap
  = "ml_XWindowAttributes_colormap"

external xWindowAttributes_map_installed : xWindowAttributes -> bool
  = "ml_XWindowAttributes_map_installed"

type wattr = {
  wattr_x : int;
  wattr_y : int;
  wattr_width : int;
  wattr_height : int;
  wattr_depth : int;
}

external xGetWindowAttributesAll : dpy:display -> win:window -> wattr
  = "ml_XWindowAttributes_all"

let get_win_attrs = xGetWindowAttributesAll

type wattrs = {
  winat_x : unit -> int;
  winat_y : unit -> int;
  winat_width : unit -> int;
  winat_height : unit -> int;
  winat_depth : unit -> int;
  winat_screen : unit -> xScreen;
  winat_border_width : unit -> int;
  winat_colormap : unit -> colormap;
  winat_map_installed : unit -> bool;
}

let win_attrs ~dpy ~win =
  let xwa = xGetWindowAttributes ~dpy ~win in
  {
    winat_x = (fun () -> xWindowAttributes_x xwa);
    winat_y = (fun () -> xWindowAttributes_y xwa);
    winat_width = (fun () -> xWindowAttributes_width xwa);
    winat_height = (fun () -> xWindowAttributes_height xwa);
    winat_depth = (fun () -> xWindowAttributes_depth xwa);
    winat_screen = (fun () -> xWindowAttributes_screen xwa);
    winat_border_width = (fun () -> xWindowAttributes_border_width xwa);
    winat_colormap = (fun () -> xWindowAttributes_colormap xwa);
    winat_map_installed = (fun () -> xWindowAttributes_map_installed xwa);
  }

type xSizeHints

external new_xSizeHints : unit -> xSizeHints = "ml_alloc_XSizeHints"

external xSizeHints_set_USPosition : xSizeHints -> x:int -> y:int -> unit
  = "ml_XSizeHints_set_USPosition"

external xSizeHints_set_USSize : xSizeHints -> width:int -> height:int -> unit
  = "ml_XSizeHints_set_USSize"

external xSizeHints_set_PPosition : xSizeHints -> x:int -> y:int -> unit
  = "ml_XSizeHints_set_PPosition"

external xSizeHints_set_PSize : xSizeHints -> width:int -> height:int -> unit
  = "ml_XSizeHints_set_PSize"

external xSizeHints_set_PMinSize : xSizeHints -> width:int -> height:int -> unit
  = "ml_XSizeHints_set_PMinSize"

external xSizeHints_set_PMaxSize : xSizeHints -> width:int -> height:int -> unit
  = "ml_XSizeHints_set_PMaxSize"

external xSizeHints_set_PResizeInc :
  xSizeHints -> width_inc:int -> height_inc:int -> unit
  = "ml_XSizeHints_set_PResizeInc"

external xSizeHints_set_PBaseSize :
  xSizeHints -> base_width:int -> base_height:int -> unit
  = "ml_XSizeHints_set_PBaseSize"

external xSizeHints_set_PAspect :
  xSizeHints -> min_aspect:int * int -> max_aspect:int * int -> unit
  = "ml_XSizeHints_set_PAspect"

external xSizeHints_set_PWinGravity : xSizeHints -> win_gravity:int -> unit
  = "ml_XSizeHints_set_PWinGravity"

external xSetNormalHints : dpy:display -> win:window -> hints:xSizeHints -> unit
  = "ml_XSetNormalHints"

external xSetStandardProperties :
  dpy:display ->
  win:window ->
  window_name:string ->
  icon_name:string ->
  icon_pixmap:pixmap option ->
  argv:string array ->
  hints:xSizeHints ->
  unit = "ml_XSetStandardProperties_bytecode" "ml_XSetStandardProperties"

type set_size_hints = {
  hints : xSizeHints;
  set_USPosition : x:int -> y:int -> unit;
  set_USSize : width:int -> height:int -> unit;
  set_PPosition : x:int -> y:int -> unit;
  set_PSize : width:int -> height:int -> unit;
  set_PMinSize : width:int -> height:int -> unit;
  set_PMaxSize : width:int -> height:int -> unit;
  set_PResizeInc : width_inc:int -> height_inc:int -> unit;
  set_PBaseSize : base_width:int -> base_height:int -> unit;
  set_PAspect : min_aspect:int * int -> max_aspect:int * int -> unit;
  set_PWinGravity : win_gravity:int -> unit;
}
(** a record to replace all the [xSizeHints_set_*] functions *)

let new_size_hints () =
  let sh = new_xSizeHints () in
  {
    hints = sh;
    set_USPosition = xSizeHints_set_USPosition sh;
    set_USSize = xSizeHints_set_USSize sh;
    set_PPosition = xSizeHints_set_PPosition sh;
    set_PSize = xSizeHints_set_PSize sh;
    set_PMinSize = xSizeHints_set_PMinSize sh;
    set_PMaxSize = xSizeHints_set_PMaxSize sh;
    set_PResizeInc = xSizeHints_set_PResizeInc sh;
    set_PBaseSize = xSizeHints_set_PBaseSize sh;
    set_PAspect = xSizeHints_set_PAspect sh;
    set_PWinGravity = xSizeHints_set_PWinGravity sh;
  }

type size_hints =
  | USPosition of int * int
  | USSize of int * int  (** (width, height) *)
  | PPosition of int * int
  | PSize of int * int
  | PMinSize of int * int
  | PMaxSize of int * int
  | PResizeInc of int * int
  | PBaseSize of int * int
  | PAspect of (int * int) * (int * int)
  | PWinGravity of int

let set_normal_hints ~dpy ~win ~hints =
  let sh = new_xSizeHints () in
  List.iter
    (function
      | USPosition (x, y) -> xSizeHints_set_USPosition sh ~x ~y
      | USSize (width, height) -> xSizeHints_set_USSize sh ~width ~height
      | PPosition (x, y) -> xSizeHints_set_PPosition sh ~x ~y
      | PSize (width, height) -> xSizeHints_set_PSize sh ~width ~height
      | PMinSize (width, height) -> xSizeHints_set_PMinSize sh ~width ~height
      | PMaxSize (width, height) -> xSizeHints_set_PMaxSize sh ~width ~height
      | PResizeInc (width_inc, height_inc) ->
          xSizeHints_set_PResizeInc sh ~width_inc ~height_inc
      | PBaseSize (base_width, base_height) ->
          xSizeHints_set_PBaseSize sh ~base_width ~base_height
      | PAspect (min_aspect, max_aspect) ->
          xSizeHints_set_PAspect sh ~min_aspect ~max_aspect
      | PWinGravity win_gravity -> xSizeHints_set_PWinGravity sh ~win_gravity)
    hints;
  xSetNormalHints ~dpy ~win ~hints:sh

let set_standard_properties ~dpy ~win ~window_name ~icon_name ~icon_pixmap ~argv
    ~hints =
  let sh = new_xSizeHints () in
  List.iter
    (function
      | USPosition (x, y) -> xSizeHints_set_USPosition sh ~x ~y
      | USSize (width, height) -> xSizeHints_set_USSize sh ~width ~height
      | PPosition (x, y) -> xSizeHints_set_PPosition sh ~x ~y
      | PSize (width, height) -> xSizeHints_set_PSize sh ~width ~height
      | PMinSize (width, height) -> xSizeHints_set_PMinSize sh ~width ~height
      | PMaxSize (width, height) -> xSizeHints_set_PMaxSize sh ~width ~height
      | PResizeInc (width_inc, height_inc) ->
          xSizeHints_set_PResizeInc sh ~width_inc ~height_inc
      | PBaseSize (base_width, base_height) ->
          xSizeHints_set_PBaseSize sh ~base_width ~base_height
      | PAspect (min_aspect, max_aspect) ->
          xSizeHints_set_PAspect sh ~min_aspect ~max_aspect
      | PWinGravity win_gravity -> xSizeHints_set_PWinGravity sh ~win_gravity)
    hints;
  xSetStandardProperties ~dpy ~win ~window_name ~icon_name ~icon_pixmap ~argv
    ~hints:sh

type 'a xEvent

type event_type =
  | KeyPress
  | KeyRelease
  | ButtonPress
  | ButtonRelease
  | MotionNotify
  | EnterNotify
  | LeaveNotify
  | FocusIn
  | FocusOut
  | KeymapNotify
  | Expose
  | GraphicsExpose
  | NoExpose
  | VisibilityNotify
  | CreateNotify
  | DestroyNotify
  | UnmapNotify
  | MapNotify
  | MapRequest
  | ReparentNotify
  | ConfigureNotify
  | ConfigureRequest
  | GravityNotify
  | ResizeRequest
  | CirculateNotify
  | CirculateRequest
  | PropertyNotify
  | SelectionClear
  | SelectionRequest
  | SelectionNotify
  | ColormapNotify
  | ClientMessage
  | MappingNotify

type any
type xKeyEvent
type xButtonEvent
type xMotionEvent
type xCrossingEvent
type xFocusChangeEvent
type xExposeEvent
type xGraphicsExposeEvent
type xNoExposeEvent
type xVisibilityEvent
type xCreateWindowEvent
type xDestroyWindowEvent
type xUnmapEvent
type xMapEvent
type xMapRequestEvent
type xReparentEvent
type xConfigureEvent
type xGravityEvent
type xResizeRequestEvent
type xConfigureRequestEvent
type xCirculateEvent
type xCirculateRequestEvent
type xPropertyEvent
type xSelectionClearEvent
type xSelectionRequestEvent
type xSelectionEvent
type xColormapEvent
type xClientMessageEvent
type xMappingEvent
type xErrorEvent
type xKeymapEvent
type xKeyPressedEvent = xKeyEvent
type xKeyReleasedEvent = xKeyEvent
type xButtonPressedEvent = xButtonEvent
type xButtonReleasedEvent = xButtonEvent
type xEnterWindowEvent = xCrossingEvent
type xLeaveWindowEvent = xCrossingEvent
type xFocusInEvent = xFocusChangeEvent
type xFocusOutEvent = xFocusChangeEvent

type event_kind =
  | XKeyPressedEvent of xKeyPressedEvent xEvent
  | XKeyReleasedEvent of xKeyReleasedEvent xEvent
  | XButtonPressedEvent of xButtonPressedEvent xEvent
  | XButtonReleasedEvent of xButtonReleasedEvent xEvent
  | XMotionEvent of xMotionEvent xEvent
  | XCrossingEvent of xCrossingEvent xEvent
  | XFocusChangeEvent of xFocusChangeEvent xEvent
  | XExposeEvent of xExposeEvent xEvent
  | XGraphicsExposeEvent of xGraphicsExposeEvent xEvent
  | XNoExposeEvent of xNoExposeEvent xEvent
  | XVisibilityEvent of xVisibilityEvent xEvent
  | XCreateWindowEvent of xCreateWindowEvent xEvent
  | XDestroyWindowEvent of xDestroyWindowEvent xEvent
  | XUnmapEvent of xUnmapEvent xEvent
  | XMapEvent of xMapEvent xEvent
  | XMapRequestEvent of xMapRequestEvent xEvent
  | XReparentEvent of xReparentEvent xEvent
  | XConfigureEvent of xConfigureEvent xEvent
  | XGravityEvent of xGravityEvent xEvent
  | XResizeRequestEvent of xResizeRequestEvent xEvent
  | XConfigureRequestEvent of xConfigureRequestEvent xEvent
  | XCirculateEvent of xCirculateEvent xEvent
  | XCirculateRequestEvent of xCirculateRequestEvent xEvent
  | XPropertyEvent of xPropertyEvent xEvent
  | XSelectionClearEvent of xSelectionClearEvent xEvent
  | XSelectionRequestEvent of xSelectionRequestEvent xEvent
  | XSelectionEvent of xSelectionEvent xEvent
  | XColormapEvent of xColormapEvent xEvent
  | XClientMessageEvent of xClientMessageEvent xEvent
  | XMappingEvent of xMappingEvent xEvent
  | XErrorEvent of xErrorEvent xEvent
  | XKeymapEvent of xKeymapEvent xEvent

external new_xEvent : unit -> any xEvent = "ml_alloc_XEvent"
external xNextEvent : dpy:display -> event:any xEvent -> unit = "ml_XNextEvent"
external xNextEventFun : dpy:display -> any xEvent = "ml_XNextEvent_fun"
external xPeekEvent : dpy:display -> event:any xEvent -> unit = "ml_XPeekEvent"

external xMaskEvent : dpy:display -> event_mask list -> any xEvent -> unit
  = "ml_XMaskEvent"

external xWindowEvent :
  dpy:display -> win:window -> event_mask list -> 'a xEvent = "ml_XWindowEvent"

external xPending : dpy:display -> int = "ml_XPending"

type event_mode =
  | AsyncPointer
  | SyncPointer
  | AsyncKeyboard
  | SyncKeyboard
  | ReplayPointer
  | ReplayKeyboard
  | AsyncBoth
  | SyncBoth

external xAllowEvents :
  dpy:display -> event_mode:event_mode -> time:time -> unit = "ml_XAllowEvents"

external xPutBackEvent : dpy:display -> event:'a xEvent -> unit
  = "ml_XPutBackEvent"

type queued_mode = QueuedAlready | QueuedAfterFlush | QueuedAfterReading

external xEventsQueued : dpy:display -> mode:queued_mode -> int
  = "ml_XEventsQueued"

external xCheckTypedEvent : dpy:display -> event_type -> any xEvent -> bool
  = "ml_XCheckTypedEvent"

let xCheckTypedEvent_option ~dpy event_type =
  let ev = new_xEvent () in
  if xCheckTypedEvent ~dpy event_type ev then Some ev else None

external xEventType : event:'a xEvent -> event_type = "ml_XEvent_type"

let xEventKind ~event =
  match xEventType ~event with
  | MotionNotify -> XMotionEvent (Obj.magic event : xMotionEvent xEvent)
  | KeyPress ->
      XKeyPressedEvent (Obj.magic event : xKeyPressedEvent xEvent)
      (* xKeyEvent *)
  | KeyRelease ->
      XKeyReleasedEvent (Obj.magic event : xKeyReleasedEvent xEvent)
      (* xKeyEvent *)
  | ButtonPress ->
      XButtonPressedEvent (Obj.magic event : xButtonPressedEvent xEvent)
      (* xButtonEvent *)
  | ButtonRelease ->
      XButtonReleasedEvent (Obj.magic event : xButtonReleasedEvent xEvent)
      (* xButtonEvent *)
  | EnterNotify ->
      XCrossingEvent (Obj.magic event : xEnterWindowEvent xEvent)
      (* xCrossingEvent *)
  | LeaveNotify ->
      XCrossingEvent (Obj.magic event : xLeaveWindowEvent xEvent)
      (* xCrossingEvent *)
  | FocusIn ->
      XFocusChangeEvent (Obj.magic event : xFocusInEvent xEvent)
      (* xFocusChangeEvent *)
  | FocusOut ->
      XFocusChangeEvent (Obj.magic event : xFocusOutEvent xEvent)
      (* xFocusChangeEvent *)
  | KeymapNotify -> XKeymapEvent (Obj.magic event : xKeymapEvent xEvent)
  | Expose -> XExposeEvent (Obj.magic event : xExposeEvent xEvent)
  | GraphicsExpose ->
      XGraphicsExposeEvent (Obj.magic event : xGraphicsExposeEvent xEvent)
  | NoExpose -> XNoExposeEvent (Obj.magic event : xNoExposeEvent xEvent)
  | VisibilityNotify ->
      XVisibilityEvent (Obj.magic event : xVisibilityEvent xEvent)
  | CreateNotify ->
      XCreateWindowEvent (Obj.magic event : xCreateWindowEvent xEvent)
  | DestroyNotify ->
      XDestroyWindowEvent (Obj.magic event : xDestroyWindowEvent xEvent)
  | UnmapNotify -> XUnmapEvent (Obj.magic event : xUnmapEvent xEvent)
  | MapNotify -> XMapEvent (Obj.magic event : xMapEvent xEvent)
  | MapRequest -> XMapRequestEvent (Obj.magic event : xMapRequestEvent xEvent)
  | ReparentNotify -> XReparentEvent (Obj.magic event : xReparentEvent xEvent)
  | ConfigureNotify ->
      XConfigureEvent (Obj.magic event : xConfigureEvent xEvent)
  | ConfigureRequest ->
      XConfigureRequestEvent (Obj.magic event : xConfigureRequestEvent xEvent)
  | GravityNotify -> XGravityEvent (Obj.magic event : xGravityEvent xEvent)
  | ResizeRequest ->
      XResizeRequestEvent (Obj.magic event : xResizeRequestEvent xEvent)
  | CirculateNotify ->
      XCirculateEvent (Obj.magic event : xCirculateEvent xEvent)
  | CirculateRequest ->
      XCirculateRequestEvent (Obj.magic event : xCirculateRequestEvent xEvent)
  | PropertyNotify -> XPropertyEvent (Obj.magic event : xPropertyEvent xEvent)
  | SelectionClear ->
      XSelectionClearEvent (Obj.magic event : xSelectionClearEvent xEvent)
  | SelectionRequest ->
      XSelectionRequestEvent (Obj.magic event : xSelectionRequestEvent xEvent)
  | SelectionNotify ->
      XSelectionEvent (Obj.magic event : xSelectionEvent xEvent)
  | ColormapNotify -> XColormapEvent (Obj.magic event : xColormapEvent xEvent)
  | ClientMessage ->
      XClientMessageEvent (Obj.magic event : xClientMessageEvent xEvent)
  | MappingNotify -> XMappingEvent (Obj.magic event : xMappingEvent xEvent)

(* {{{ string_of_event_type *)

let string_of_event_type ~event_type =
  match event_type with
  | MotionNotify -> "MotionNotify"
  | KeyPress -> "KeyPress"
  | KeyRelease -> "KeyRelease"
  | ButtonPress -> "ButtonPress"
  | ButtonRelease -> "ButtonRelease"
  | EnterNotify -> "EnterNotify"
  | LeaveNotify -> "LeaveNotify"
  | FocusIn -> "FocusIn"
  | FocusOut -> "FocusOut"
  | KeymapNotify -> "KeymapNotify"
  | Expose -> "Expose"
  | GraphicsExpose -> "GraphicsExpose"
  | NoExpose -> "NoExpose"
  | VisibilityNotify -> "VisibilityNotify"
  | CreateNotify -> "CreateNotify"
  | DestroyNotify -> "DestroyNotify"
  | UnmapNotify -> "UnmapNotify"
  | MapNotify -> "MapNotify"
  | MapRequest -> "MapRequest"
  | ReparentNotify -> "ReparentNotify"
  | ConfigureNotify -> "ConfigureNotify"
  | ConfigureRequest -> "ConfigureRequest"
  | GravityNotify -> "GravityNotify"
  | ResizeRequest -> "ResizeRequest"
  | CirculateNotify -> "CirculateNotify"
  | CirculateRequest -> "CirculateRequest"
  | PropertyNotify -> "PropertyNotify"
  | SelectionClear -> "SelectionClear"
  | SelectionRequest -> "SelectionRequest"
  | SelectionNotify -> "SelectionNotify"
  | ColormapNotify -> "ColormapNotify"
  | ClientMessage -> "ClientMessage"
  | MappingNotify -> "MappingNotify"

let to_xMotionEvent ~(event : any xEvent) =
  if xEventType ~event <> MotionNotify then invalid_arg "to_xMotionEvent";
  (Obj.magic event : xMotionEvent xEvent)

let to_xKeyEvent ~(event : any xEvent) =
  if xEventType ~event <> KeyPress && xEventType ~event <> KeyRelease then
    invalid_arg "to_xKeyEvent";
  (Obj.magic event : xKeyEvent xEvent)

let to_xKeyPressedEvent ~(event : any xEvent) =
  if xEventType ~event <> KeyPress then invalid_arg "to_xKeyPressedEvent";
  (Obj.magic event : xKeyPressedEvent xEvent)

let to_xKeyReleasedEvent ~(event : any xEvent) =
  if xEventType ~event <> KeyRelease then invalid_arg "to_xKeyReleasedEvent";
  (Obj.magic event : xKeyReleasedEvent xEvent)

let to_xButtonEvent ~(event : any xEvent) =
  if xEventType ~event <> ButtonPress && xEventType ~event <> ButtonRelease then
    invalid_arg "to_xButtonEvent";
  (Obj.magic event : xButtonEvent xEvent)

let to_xButtonPressedEvent ~(event : any xEvent) =
  if xEventType ~event <> ButtonPress then invalid_arg "to_xButtonPressedEvent";
  (Obj.magic event : xButtonPressedEvent xEvent)

let to_xButtonReleasedEvent ~(event : any xEvent) =
  if xEventType ~event <> ButtonRelease then
    invalid_arg "to_xButtonReleasedEvent";
  (Obj.magic event : xButtonReleasedEvent xEvent)

let to_xCrossingEvent ~(event : any xEvent) =
  if xEventType ~event <> EnterNotify && xEventType ~event <> LeaveNotify then
    invalid_arg "to_xCrossingEvent";
  (Obj.magic event : xCrossingEvent xEvent)

let to_xEnterWindowEvent ~(event : any xEvent) =
  if xEventType ~event <> EnterNotify then invalid_arg "to_xEnterWindowEvent";
  (Obj.magic event : xEnterWindowEvent xEvent)

let to_xLeaveWindowEvent ~(event : any xEvent) =
  if xEventType ~event <> LeaveNotify then invalid_arg "to_xLeaveWindowEvent";
  (Obj.magic event : xLeaveWindowEvent xEvent)

let to_xFocusChangeEvent ~(event : any xEvent) =
  if xEventType ~event <> FocusIn && xEventType ~event <> FocusOut then
    invalid_arg "to_xFocusChangeEvent";
  (Obj.magic event : xFocusChangeEvent xEvent)

let to_xFocusInEvent ~(event : any xEvent) =
  if xEventType ~event <> FocusIn then invalid_arg "to_xFocusInEvent";
  (Obj.magic event : xFocusInEvent xEvent)

let to_xFocusOutEvent ~(event : any xEvent) =
  if xEventType ~event <> FocusOut then invalid_arg "to_xFocusOutEvent";
  (Obj.magic event : xFocusOutEvent xEvent)

let to_xKeymapEvent ~(event : any xEvent) =
  if xEventType ~event <> KeymapNotify then invalid_arg "to_xKeymapEvent";
  (Obj.magic event : xKeymapEvent xEvent)

let to_xExposeEvent ~(event : any xEvent) =
  if xEventType ~event <> Expose then invalid_arg "to_xExposeEvent";
  (Obj.magic event : xExposeEvent xEvent)

let to_xGraphicsExposeEvent ~(event : any xEvent) =
  if xEventType ~event <> GraphicsExpose then
    invalid_arg "to_xGraphicsExposeEvent";
  (Obj.magic event : xGraphicsExposeEvent xEvent)

let to_xNoExposeEvent ~(event : any xEvent) =
  if xEventType ~event <> NoExpose then invalid_arg "to_xNoExposeEvent";
  (Obj.magic event : xNoExposeEvent xEvent)

let to_xVisibilityEvent ~(event : any xEvent) =
  if xEventType ~event <> VisibilityNotify then
    invalid_arg "to_xVisibilityEvent";
  (Obj.magic event : xVisibilityEvent xEvent)

let to_xCreateWindowEvent ~(event : any xEvent) =
  if xEventType ~event <> CreateNotify then invalid_arg "to_xCreateWindowEvent";
  (Obj.magic event : xCreateWindowEvent xEvent)

let to_xDestroyWindowEvent ~(event : any xEvent) =
  if xEventType ~event <> DestroyNotify then
    invalid_arg "to_xDestroyWindowEvent";
  (Obj.magic event : xDestroyWindowEvent xEvent)

let to_xUnmapEvent ~(event : any xEvent) =
  if xEventType ~event <> UnmapNotify then invalid_arg "to_xUnmapEvent";
  (Obj.magic event : xUnmapEvent xEvent)

let to_xMapEvent ~(event : any xEvent) =
  if xEventType ~event <> MapNotify then invalid_arg "to_xMapEvent";
  (Obj.magic event : xMapEvent xEvent)

let to_xMapRequestEvent ~(event : any xEvent) =
  if xEventType ~event <> MapRequest then invalid_arg "to_xMapRequestEvent";
  (Obj.magic event : xMapRequestEvent xEvent)

let to_xReparentEvent ~(event : any xEvent) =
  if xEventType ~event <> ReparentNotify then invalid_arg "to_xReparentEvent";
  (Obj.magic event : xReparentEvent xEvent)

let to_xConfigureEvent ~(event : any xEvent) =
  if xEventType ~event <> ConfigureNotify then invalid_arg "to_xConfigureEvent";
  (Obj.magic event : xConfigureEvent xEvent)

let to_xConfigureRequestEvent ~(event : any xEvent) =
  if xEventType ~event <> ConfigureRequest then
    invalid_arg "to_xConfigureRequestEvent";
  (Obj.magic event : xConfigureRequestEvent xEvent)

let to_xGravityEvent ~(event : any xEvent) =
  if xEventType ~event <> GravityNotify then invalid_arg "to_xGravityEvent";
  (Obj.magic event : xGravityEvent xEvent)

let to_xResizeRequestEvent ~(event : any xEvent) =
  if xEventType ~event <> ResizeRequest then
    invalid_arg "to_xResizeRequestEvent";
  (Obj.magic event : xResizeRequestEvent xEvent)

let to_xCirculateEvent ~(event : any xEvent) =
  if xEventType ~event <> CirculateNotify then invalid_arg "to_xCirculateEvent";
  (Obj.magic event : xCirculateEvent xEvent)

let to_xCirculateRequestEvent ~(event : any xEvent) =
  if xEventType ~event <> CirculateRequest then
    invalid_arg "to_xCirculateRequestEvent";
  (Obj.magic event : xCirculateRequestEvent xEvent)

let to_xPropertyEvent ~(event : any xEvent) =
  if xEventType ~event <> PropertyNotify then invalid_arg "to_xPropertyEvent";
  (Obj.magic event : xPropertyEvent xEvent)

let to_xSelectionClearEvent ~(event : any xEvent) =
  if xEventType ~event <> SelectionClear then
    invalid_arg "to_xSelectionClearEvent";
  (Obj.magic event : xSelectionClearEvent xEvent)

let to_xSelectionRequestEvent ~(event : any xEvent) =
  if xEventType ~event <> SelectionRequest then
    invalid_arg "to_xSelectionRequestEvent";
  (Obj.magic event : xSelectionRequestEvent xEvent)

let to_xSelectionEvent ~(event : any xEvent) =
  if xEventType ~event <> SelectionNotify then invalid_arg "to_xSelectionEvent";
  (Obj.magic event : xSelectionEvent xEvent)

let to_xColormapEvent ~(event : any xEvent) =
  if xEventType ~event <> ColormapNotify then invalid_arg "to_xColormapEvent";
  (Obj.magic event : xColormapEvent xEvent)

let to_xClientMessageEvent ~(event : any xEvent) =
  if xEventType ~event <> ClientMessage then
    invalid_arg "to_xClientMessageEvent";
  (Obj.magic event : xClientMessageEvent xEvent)

let to_xMappingEvent ~(event : any xEvent) =
  if xEventType ~event <> MappingNotify then invalid_arg "to_xMappingEvent";
  (Obj.magic event : xMappingEvent xEvent)

type xAnyEvent_contents = {
  xany_type : event_type;
  xany_serial : uint;
  xany_send_event : bool;
  xany_display : display;
  xany_window : window;
}

external xAnyEvent_datas : 'a xEvent -> xAnyEvent_contents
  = "ml_XAnyEvent_datas"

type logical_state =
  | AnyModifier
  | Button1Mask
  | Button2Mask
  | Button3Mask
  | Button4Mask
  | Button5Mask
  | ShiftMask
  | LockMask
  | ControlMask
  | Mod1Mask
  | Mod2Mask
  | Mod3Mask
  | Mod4Mask
  | Mod5Mask

type xKeyEvent_contents = {
  key_serial : uint;
  key_send_event : bool;
  key_display : display;
  key_window : window;
  key_root : window;
  key_subwindow : window;
  key_time : time;
  key_x : int;
  key_y : int;
  key_x_root : int;
  key_y_root : int;
  key_state : logical_state list;
  key_keycode : keycode;
  key_same_screen : bool;
}

external xKeyEvent_datas : xKeyEvent xEvent -> xKeyEvent_contents
  = "ml_XKeyEvent_datas"

type xMotionEvent_contents = {
  motion_serial : uint;
  motion_send_event : bool;
  motion_display : display;
  motion_window : window;
  motion_root : window;
  motion_subwindow : window;
  motion_time : time;
  motion_x : int;
  motion_y : int;
  motion_x_root : int;
  motion_y_root : int;
  motion_state : (* button_mask *) logical_state list;
      (* TODO check the additionnal Masks *)
  motion_is_hint : char;
  motion_same_screen : bool;
}

external xMotionEvent_datas : xMotionEvent xEvent -> xMotionEvent_contents
  = "ml_XMotionEvent_datas"
(** {{:http://tronche.com/gui/x/xlib/events/keyboard-pointer/keyboard-pointer.html#XMotionEvent}man} *)

type button = AnyButton | Button1 | Button2 | Button3 | Button4 | Button5

type xButtonEvent_contents = {
  button_serial : uint;
  button_send_event : bool;
  button_display : display;
  button_window : window;
  button_root : window;
  button_subwindow : window;
  button_time : time;
  button_x : int;
  button_y : int;
  button_x_root : int;
  button_y_root : int;
  button_state : uint;
  button : button;
  button_same_screen : bool;
}

external xButtonEvent_datas : xButtonEvent xEvent -> xButtonEvent_contents
  = "ml_XButtonEvent_datas"

module Cross = struct
  type crossing_mode = NotifyNormal | NotifyGrab | NotifyUngrab

  type crossing_detail =
    | NotifyAncestor
    | NotifyVirtual
    | NotifyInferior
    | NotifyNonlinear
    | NotifyNonlinearVirtual

  type crossing_state =
    | Button1Mask
    | Button2Mask
    | Button3Mask
    | Button4Mask
    | Button5Mask
    | ShiftMask
    | LockMask
    | ControlMask
    | Mod1Mask
    | Mod2Mask
    | Mod3Mask
    | Mod4Mask
    | Mod5Mask
end

type xCrossingEvent_contents = {
  cross_window : window;
  cross_root : window;
  cross_subwindow : window;
  cross_time : time;
  cross_x : int;
  cross_y : int;
  cross_x_root : int;
  cross_y_root : int;
  cross_mode : Cross.crossing_mode;
  cross_detail : Cross.crossing_detail;
  cross_same_screen : bool;
  cross_focus : bool;
  cross_state : Cross.crossing_state;
}

external xCrossingEvent_datas : xCrossingEvent xEvent -> xCrossingEvent_contents
  = "ml_XCrossingEvent_datas"

type focus_mode =
  | NotifyNormal
  | NotifyGrab
  | NotifyUngrab
  | NotifyWhileGrabbed

type focus_detail =
  | NotifyAncestor
  | NotifyVirtual
  | NotifyInferior
  | NotifyNonlinear
  | NotifyNonlinearVirtual
  | NotifyPointer
  | NotifyPointerRoot
  | NotifyDetailNone

type xFocusChangeEvent_contents = {
  focus_mode : focus_mode;
  focus_detail : focus_detail;
}

external xFocusChangeEvent_datas :
  xFocusChangeEvent xEvent -> xFocusChangeEvent_contents
  = "ml_XFocusChangeEvent_datas"

type xKeymapEvent_contents = { key_vector : string } [@@unboxed]

external xKeymapEvent_datas : xKeymapEvent xEvent -> xKeymapEvent_contents
  = "ml_XKeymapEvent_datas"

type xExposeEvent_contents = {
  expose_x : int;
  expose_y : int;
  expose_width : int;
  expose_height : int;
  expose_count : int;
}

external xExposeEvent_datas : xExposeEvent xEvent -> xExposeEvent_contents
  = "ml_XExposeEvent_datas"

type visibility_state =
  | VisibilityUnobscured
  | VisibilityPartiallyObscured
  | VisibilityFullyObscured

type xVisibilityEvent_contents = { visibility_state : visibility_state }
[@@unboxed]

external xVisibilityEvent_datas :
  xVisibilityEvent xEvent -> xVisibilityEvent_contents
  = "ml_XVisibilityEvent_datas"

type xDestroyWindowEvent_contents = {
  destroy_event : window;
  destroy_window : window;
}

external xDestroyWindowEvent_datas :
  xDestroyWindowEvent xEvent -> xDestroyWindowEvent_contents
  = "ml_XDestroyWindowEvent_datas"

type xReparentEvent_contents = {
  reparent_event : window;
  reparent_window : window;
  reparent_parent : window;
  reparent_x : int;
  reparent_y : int;
  reparent_override_redirect : bool;
}

external xReparentEvent_datas : xReparentEvent xEvent -> xReparentEvent_contents
  = "ml_XReparentEvent_datas"

type xConfigureEvent_contents = {
  conf_x : int;
  conf_y : int;
  conf_width : int;
  conf_height : int;
  conf_border_width : int;
  conf_above : window;
  conf_override_redirect : bool;
}

external xConfigureEvent_datas :
  xConfigureEvent xEvent -> xConfigureEvent_contents
  = "ml_XConfigureEvent_datas"

type xconfreq_detail = Above | Below | TopIf | BottomIf | Opposite

type xConfigureRequestEvent_contents = {
  confreq_parent : window;
  confreq_window : window;
  confreq_x : int;
  confreq_y : int;
  confreq_width : int;
  confreq_height : int;
  confreq_border_width : int;
  confreq_above : window;
  confreq_detail : xconfreq_detail;
  confreq_value_mask : uint; (* XXX TODO *)
}

external xConfigureRequestEvent_datas :
  xConfigureRequestEvent xEvent -> xConfigureRequestEvent_contents
  = "ml_XConfigureRequestEvent_datas"

type xResizeRequestEvent_contents = { resize_width : int; resize_height : int }

external xResizeRequestEvent_datas :
  xResizeRequestEvent xEvent -> xResizeRequestEvent_contents
  = "ml_XResizeRequestEvent_datas"

type xSelectionEvent_contents = {
  selec_requestor : window;
  selec_selection : atom;
  selec_target : atom;
  selec_property : atom option;
  selec_time : time;
}

external xSelectionEvent_datas :
  xSelectionEvent xEvent -> xSelectionEvent_contents
  = "ml_XSelectionEvent_datas"

type xClientMessgeEvent_data =
  | ClientMessageBytes of int array
  | ClientMessageShorts of int array
  | ClientMessageLongs of int array

type xClientMessageEvent_contents = {
  client_message_serial : uint;
  client_message_send_event : bool;
  client_message_display : display;
  client_message_window : window;
  client_message_type : atom;
  client_message_data : xClientMessgeEvent_data;
}

type xCreateWindowEvent_contents = {
  createwindow_serial : uint;
  createwindow_send_event : bool;
  createwindow_display : display;
  createwindow_parent : window;
  createwindow_window : window;
  createwindow_x : int;
  createwindow_y : int;
  createwindow_width : int;
  createwindow_height : int;
  createwindow_border_width : int;
  createwindow_override_redirect : bool;
}

external xCreateWindowEvent_datas :
  xCreateWindowEvent xEvent -> xCreateWindowEvent_contents
  = "ml_XCreateWindowEvent_datas"

type todo_contents = { todo_field : int }

type event_content =
  | XMotionEvCnt of xMotionEvent_contents
  | XKeyPressedEvCnt of xKeyEvent_contents
  | XKeyReleasedEvCnt of xKeyEvent_contents
  | XButtonPressedEvCnt of xButtonEvent_contents
  | XButtonReleasedEvCnt of xButtonEvent_contents
  | XCrossingEvCnt of xCrossingEvent_contents
  | XFocusChangeEvCnt of xFocusChangeEvent_contents
  | XKeymapEvCnt of xKeymapEvent_contents
  | XExposeEvCnt of xExposeEvent_contents
  | XGraphicsExposeEvCnt of todo_contents
  | XNoExposeEvCnt of todo_contents
  | XVisibilityEvCnt of xVisibilityEvent_contents
  | XCreateWindowEvCnt of xCreateWindowEvent_contents
  | XDestroyWindowEvCnt of xDestroyWindowEvent_contents
  | XUnmapEvCnt of todo_contents
  | XMapEvCnt of todo_contents
  | XMapRequestEvCnt of todo_contents
  | XReparentEvCnt of xReparentEvent_contents
  | XConfigureEvCnt of xConfigureEvent_contents
  | XConfigureRequestEvCnt of xConfigureRequestEvent_contents
  | XGravityEvCnt of todo_contents
  | XResizeRequestEvCnt of xResizeRequestEvent_contents
  | XCirculateEvCnt of todo_contents
  | XCirculateRequestEvCnt of todo_contents
  | XPropertyEvCnt of todo_contents
  | XSelectionClearEvCnt of todo_contents
  | XSelectionRequestEvCnt of todo_contents
  | XSelectionEvCnt of xSelectionEvent_contents
  | XColormapEvCnt of todo_contents
  | XClientMessageEvCnt of xClientMessageEvent_contents
  | XMappingEvCnt of todo_contents

external xSendEvent :
  dpy:display ->
  win:window ->
  propagate:bool ->
  event_mask:event_mask ->
  event_content ->
  unit = "ml_XSendEvent"

external xLookupString : event:xKeyEvent xEvent -> buffer:string -> int * keysym
  = "ml_XLookupString"

external xLookupKeysym : event:xKeyEvent xEvent -> index:int -> keysym
  = "ml_XLookupKeysym"

external xRefreshKeyboardMapping : event:xMappingEvent xEvent -> unit
  = "ml_XRefreshKeyboardMapping"

external xDisplayKeycodes : dpy:display -> keycode * keycode
  = "ml_XDisplayKeycodes"

external xGetKeyboardMapping :
  dpy:display ->
  first_keycode:keycode ->
  keycode_count:int ->
  keysym array array = "ml_XGetKeyboardMapping"

external xChangeKeyboardMapping :
  dpy:display ->
  first_keycode:keycode ->
  keysyms_per_keycode:int ->
  keysyms:keysym array ->
  num_codes:int ->
  unit = "ml_XChangeKeyboardMapping"

external xChangeKeyboardMapping_single :
  dpy:display -> keycode:keycode -> keysym:int -> unit
  = "ml_XChangeKeyboardMapping_single"
[@@noalloc]

external xSetWMProtocols :
  dpy:display -> win:window -> protocols:atom -> count:int -> unit
  = "ml_XSetWMProtocols"

external xInternAtom :
  dpy:display -> atom_name:string -> only_if_exists:bool -> atom
  = "ml_XInternAtom"

external xInternAtoms :
  dpy:display -> names:string array -> only_if_exists:bool -> atom array
  = "ml_XInternAtoms"

external xGetAtomName : dpy:display -> atom:atom -> string = "ml_XGetAtomName"

external xEvent_xclient_data : xClientMessageEvent xEvent -> atom
  = "ml_XEvent_xclient_data_l_0"

type font
type xFontStruct (* pointer to a structure *)

external xLoadFont : dpy:display -> name:string -> font = "ml_XLoadFont"

external xLoadQueryFont : dpy:display -> name:string -> xFontStruct
  = "ml_XLoadQueryFont"

external xQueryFont : dpy:display -> font:font -> xFontStruct = "ml_XQueryFont"
external xQueryFontGC : dpy:display -> gc:gc -> xFontStruct = "ml_XQueryFontGC"
external xSetFont : dpy:display -> gc:gc -> font:font -> unit = "ml_XSetFont"
external xFontStruct_font : xFontStruct -> font = "ml_XFontStruct_get_fid"
external xFontStruct_ascent : xFontStruct -> int = "ml_XFontStruct_get_ascent"
external xFontStruct_descent : xFontStruct -> int = "ml_XFontStruct_get_descent"

external xFontStruct_all_chars_exist : xFontStruct -> bool
  = "ml_XFontStruct_get_all_chars_exist"

external xFontStruct_get_height : xFontStruct -> int * int
  = "ml_XFontStruct_get_height"

external xTextWidth : xFontStruct -> string -> int = "ml_XTextWidth"

type xCharStruct = {
  lbearing : int;
  rbearing : int;
  width : int;
  ascent : int;
  descent : int;
}

external xFontStruct_min_bounds : xFontStruct -> xCharStruct
  = "ml_xFontStruct_min_bounds"

external xFontStruct_max_bounds : xFontStruct -> xCharStruct
  = "ml_xFontStruct_max_bounds"

type font_struct = {
  _font : font;
  _ascent : int;
  _descent : int;
  all_chars_exist : bool;
  font_height : int * int;
  text_width : string -> int;
  min_bounds : xCharStruct;
  max_bounds : xCharStruct;
}

let load_font ~dpy ~name =
  let fs = xLoadQueryFont ~dpy ~name in
  {
    _font = xFontStruct_font fs;
    _ascent = xFontStruct_ascent fs;
    _descent = xFontStruct_descent fs;
    all_chars_exist = xFontStruct_all_chars_exist fs;
    font_height = xFontStruct_get_height fs;
    text_width = xTextWidth fs;
    min_bounds = xFontStruct_min_bounds fs;
    max_bounds = xFontStruct_max_bounds fs;
  }

external xSetFontPath : dpy:display -> directories:string array -> unit
  = "ml_XSetFontPath"

external xGetFontPath : dpy:display -> string array = "ml_XGetFontPath"

external xListFonts :
  dpy:display -> pattern:string -> maxnames:int -> string array
  = "ml_XListFonts"

external xDefaultGC : dpy:display -> scr:screen_number -> gc = "ml_XDefaultGC"

type xGCValues

external new_xGCValues : unit -> xGCValues = "ml_alloc_XGCValues"

type line_style = LineSolid | LineOnOffDash | LineDoubleDash
type cap_style = CapNotLast | CapButt | CapRound | CapProjecting
type join_style = JoinMiter | JoinRound | JoinBevel
type fill_style = FillSolid | FillTiled | FillStippled | FillOpaqueStippled
type fill_rule = EvenOddRule | WindingRule

type logop_func =
  | GXclear
  | GXand
  | GXandReverse
  | GXcopy
  | GXandInverted
  | GXnoop
  | GXxor
  | GXor
  | GXnor
  | GXequiv
  | GXinvert
  | GXorReverse
  | GXcopyInverted
  | GXorInverted
  | GXnand
  | GXset

type arc_mode = ArcChord | ArcPieSlice
type subwindow_mode = ClipByChildren | IncludeInferiors

external xGCValues_set_foreground : gcv:xGCValues -> fg:pixel_color -> unit
  = "ml_XGCValues_set_foreground"

external xGCValues_set_background : gcv:xGCValues -> bg:pixel_color -> unit
  = "ml_XGCValues_set_background"

external xGCValues_set_graphics_exposures : gcv:xGCValues -> bool -> unit
  = "ml_XGCValues_set_graphics_exposures"

external xGCValues_set_tile : gcv:xGCValues -> pixmap -> unit
  = "ml_XGCValues_set_tile"

external xGCValues_set_clip_x_origin : gcv:xGCValues -> int -> unit
  = "ml_XGCValues_set_clip_x_origin"

external xGCValues_set_clip_y_origin : gcv:xGCValues -> int -> unit
  = "ml_XGCValues_set_clip_y_origin"

external xGCValues_set_ts_x_origin : gcv:xGCValues -> int -> unit
  = "ml_XGCValues_set_ts_x_origin"

external xGCValues_set_ts_y_origin : gcv:xGCValues -> int -> unit
  = "ml_XGCValues_set_ts_y_origin"

external xGCValues_set_line_style : gcv:xGCValues -> line_style -> unit
  = "ml_XGCValues_set_line_style"

external xGCValues_set_cap_style : gcv:xGCValues -> cap_style -> unit
  = "ml_XGCValues_set_cap_style"

external xGCValues_set_join_style : gcv:xGCValues -> join_style -> unit
  = "ml_XGCValues_set_join_style"

external xGCValues_set_fill_style : gcv:xGCValues -> fill_style -> unit
  = "ml_XGCValues_set_fill_style"

external xGCValues_set_fill_rule : gcv:xGCValues -> fill_rule -> unit
  = "ml_XGCValues_set_fill_rule"

external xGCValues_set_function : gcv:xGCValues -> logop_func -> unit
  = "ml_XGCValues_set_function"

external xGCValues_set_line_width : gcv:xGCValues -> int -> unit
  = "ml_XGCValues_set_line_width"

external xGCValues_set_arc_mode : gcv:xGCValues -> arc_mode -> unit
  = "ml_XGCValues_set_arc_mode"

external xGCValues_set_font : gcv:xGCValues -> font -> unit
  = "ml_XGCValues_set_font"

external xGCValues_set_subwindow_mode : gcv:xGCValues -> subwindow_mode -> unit
  = "ml_XGCValues_set_subwindow_mode"

external xGCValues_get_foreground : gcv:xGCValues -> pixel_color
  = "ml_XGCValues_get_foreground"

external xGCValues_get_background : gcv:xGCValues -> pixel_color
  = "ml_XGCValues_get_background"

external xGCValues_get_graphics_exposures : gcv:xGCValues -> bool
  = "ml_XGCValues_get_graphics_exposures"

external xGCValues_get_tile : gcv:xGCValues -> pixmap = "ml_XGCValues_get_tile"

external xGCValues_get_clip_x_origin : gcv:xGCValues -> int
  = "ml_XGCValues_get_clip_x_origin"

external xGCValues_get_clip_y_origin : gcv:xGCValues -> int
  = "ml_XGCValues_get_clip_y_origin"

external xGCValues_get_ts_x_origin : gcv:xGCValues -> int
  = "ml_XGCValues_get_ts_x_origin"

external xGCValues_get_ts_y_origin : gcv:xGCValues -> int
  = "ml_XGCValues_get_ts_y_origin"

external xGCValues_get_line_style : gcv:xGCValues -> line_style
  = "ml_XGCValues_get_line_style"

external xGCValues_get_cap_style : gcv:xGCValues -> cap_style
  = "ml_XGCValues_get_cap_style"

external xGCValues_get_join_style : gcv:xGCValues -> join_style
  = "ml_XGCValues_get_join_style"

external xGCValues_get_fill_style : gcv:xGCValues -> fill_style
  = "ml_XGCValues_get_fill_style"

external xGCValues_get_fill_rule : gcv:xGCValues -> fill_rule
  = "ml_XGCValues_get_fill_rule"

external xGCValues_get_function : gcv:xGCValues -> logop_func
  = "ml_XGCValues_get_function"

external xGCValues_get_line_width : gcv:xGCValues -> int
  = "ml_XGCValues_get_line_width"

external xGCValues_get_arc_mode : gcv:xGCValues -> arc_mode
  = "ml_XGCValues_get_arc_mode"

external xGCValues_get_font : gcv:xGCValues -> font = "ml_XGCValues_get_font"

external xGCValues_get_subwindow_mode : gcv:xGCValues -> subwindow_mode
  = "ml_XGCValues_get_subwindow_mode"

type gc_values = {
  gcValues : xGCValues;
  set_foreground : fg:pixel_color -> unit;
  set_background : bg:pixel_color -> unit;
  set_graphics_exposures : bool -> unit;
  set_tile : pixmap -> unit;
  set_clip_x_origin : int -> unit;
  set_clip_y_origin : int -> unit;
  set_ts_x_origin : int -> unit;
  set_ts_y_origin : int -> unit;
  set_line_style : line_style -> unit;
  set_cap_style : cap_style -> unit;
  set_join_style : join_style -> unit;
  set_fill_style : fill_style -> unit;
  set_fill_rule : fill_rule -> unit;
  set_function : logop_func -> unit;
  set_line_width : int -> unit;
  set_arc_mode : arc_mode -> unit;
  set_font : font -> unit;
  set_subwindow_mode : subwindow_mode -> unit;
  foreground : pixel_color;
  background : pixel_color;
  graphics_exposures : bool;
  tile : pixmap;
  clip_x_origin : int;
  clip_y_origin : int;
  ts_x_origin : int;
  ts_y_origin : int;
  line_style : line_style;
  cap_style : cap_style;
  join_style : join_style;
  fill_style : fill_style;
  fill_rule : fill_rule;
  logical_op : logop_func;
  line_width : int;
  arc_mode : arc_mode;
  gc_font : font;
  subwindow_mode : subwindow_mode;
}
(** a record to replace all the [xGCValues_set_*] and [xGCValues_get_*] functions *)

let new_gc_values () =
  let gcv = new_xGCValues () in
  {
    gcValues = gcv;
    set_foreground = xGCValues_set_foreground ~gcv;
    set_background = xGCValues_set_background ~gcv;
    set_graphics_exposures = xGCValues_set_graphics_exposures ~gcv;
    set_tile = xGCValues_set_tile ~gcv;
    set_clip_x_origin = xGCValues_set_clip_x_origin ~gcv;
    set_clip_y_origin = xGCValues_set_clip_y_origin ~gcv;
    set_ts_x_origin = xGCValues_set_ts_x_origin ~gcv;
    set_ts_y_origin = xGCValues_set_ts_y_origin ~gcv;
    set_line_style = xGCValues_set_line_style ~gcv;
    set_cap_style = xGCValues_set_cap_style ~gcv;
    set_join_style = xGCValues_set_join_style ~gcv;
    set_fill_style = xGCValues_set_fill_style ~gcv;
    set_fill_rule = xGCValues_set_fill_rule ~gcv;
    set_function = xGCValues_set_function ~gcv;
    set_line_width = xGCValues_set_line_width ~gcv;
    set_arc_mode = xGCValues_set_arc_mode ~gcv;
    set_font = xGCValues_set_font ~gcv;
    set_subwindow_mode = xGCValues_set_subwindow_mode ~gcv;
    foreground = xGCValues_get_foreground ~gcv;
    background = xGCValues_get_background ~gcv;
    graphics_exposures = xGCValues_get_graphics_exposures ~gcv;
    tile = xGCValues_get_tile ~gcv;
    clip_x_origin = xGCValues_get_clip_x_origin ~gcv;
    clip_y_origin = xGCValues_get_clip_y_origin ~gcv;
    ts_x_origin = xGCValues_get_ts_x_origin ~gcv;
    ts_y_origin = xGCValues_get_ts_y_origin ~gcv;
    line_style = xGCValues_get_line_style ~gcv;
    cap_style = xGCValues_get_cap_style ~gcv;
    join_style = xGCValues_get_join_style ~gcv;
    fill_style = xGCValues_get_fill_style ~gcv;
    fill_rule = xGCValues_get_fill_rule ~gcv;
    logical_op = xGCValues_get_function ~gcv;
    line_width = xGCValues_get_line_width ~gcv;
    arc_mode = xGCValues_get_arc_mode ~gcv;
    gc_font = xGCValues_get_font ~gcv;
    subwindow_mode = xGCValues_get_subwindow_mode ~gcv;
  }

type gc_valuemask =
  | GCFunction
  | GCPlaneMask
  | GCForeground
  | GCBackground
  | GCLineWidth
  | GCLineStyle
  | GCCapStyle
  | GCJoinStyle
  | GCFillStyle
  | GCFillRule
  | GCTile
  | GCStipple
  | GCTileStipXOrigin
  | GCTileStipYOrigin
  | GCFont
  | GCSubwindowMode
  | GCGraphicsExposures
  | GCClipXOrigin
  | GCClipYOrigin
  | GCClipMask
  | GCDashOffset
  | GCDashList
  | GCArcMode

external xCreateGC :
  dpy:display -> d:'a drawable -> gc_valuemask list -> xGCValues -> gc
  = "ml_XCreateGC"

external do_finalize_gc : gc -> unit = "do_finalize_GC"

let xCreateGC ~dpy ~d mask vals =
  let gc = xCreateGC ~dpy ~d mask vals in
  Gc.finalise do_finalize_gc gc;
  gc

external xChangeGC :
  dpy:display -> gc:gc -> gc_valuemask list -> xGCValues -> unit
  = "ml_XChangeGC"

external xGetGCValues : dpy:display -> gc:gc -> gc_valuemask list -> xGCValues
  = "ml_XGetGCValues"

external xSetLineAttributes :
  dpy:display ->
  gc:gc ->
  line_width:uint ->
  line_style:line_style ->
  cap_style:cap_style ->
  join_style:join_style ->
  unit = "ml_XSetLineAttributes_bytecode" "ml_XSetLineAttributes"

external xSetFillStyle : dpy:display -> gc:gc -> fill_style:fill_style -> unit
  = "ml_XSetFillStyle"

external xSetForeground : dpy:display -> gc:gc -> fg:pixel_color -> unit
  = "ml_XSetForeground"

external xSetBackground : dpy:display -> gc:gc -> bg:pixel_color -> unit
  = "ml_XSetBackground"

external xClearWindow : dpy:display -> win:window -> unit = "ml_XClearWindow"

external xClearArea :
  dpy:display ->
  win:window ->
  x:int ->
  y:int ->
  width:uint ->
  height:uint ->
  exposures:bool ->
  unit = "ml_XClearArea_bytecode" "ml_XClearArea"

external xDrawPoint :
  dpy:display -> d:'a drawable -> gc:gc -> x:int -> y:int -> unit
  = "ml_XDrawPoint"

type coordinate_mode = CoordModeOrigin | CoordModePrevious
type xPoint = { pnt_x : int; pnt_y : int }

external xDrawPoints :
  dpy:display ->
  d:'a drawable ->
  gc:gc ->
  points:xPoint array ->
  mode:coordinate_mode ->
  unit = "ml_XDrawPoints"

external xDrawLine :
  dpy:display ->
  d:'a drawable ->
  gc:gc ->
  x1:int ->
  y1:int ->
  x2:int ->
  y2:int ->
  unit = "ml_XDrawLine_bytecode" "ml_XDrawLine"

external xDrawLines :
  dpy:display ->
  d:'a drawable ->
  gc:gc ->
  points:xPoint array ->
  mode:coordinate_mode ->
  unit = "ml_XDrawLines"

type segment = { x1 : int; y1 : int; x2 : int; y2 : int }

external xDrawSegments :
  dpy:display -> d:'a drawable -> gc:gc -> segments:segment array -> unit
  = "ml_XDrawSegments"

external xDrawRectangle :
  dpy:display ->
  d:'a drawable ->
  gc:gc ->
  x:int ->
  y:int ->
  width:uint ->
  height:uint ->
  unit = "ml_XDrawRectangle_bytecode" "ml_XDrawRectangle"

external xFillRectangle :
  dpy:display ->
  d:'a drawable ->
  gc:gc ->
  x:int ->
  y:int ->
  width:uint ->
  height:uint ->
  unit = "ml_XFillRectangle_bytecode" "ml_XFillRectangle"

type x_rectangle = {
  rect_x : int;
  rect_y : int;
  rect_width : uint;
  rect_height : uint;
}

external xFillRectangles :
  dpy:display -> d:'a drawable -> gc:gc -> rectangles:x_rectangle array -> unit
  = "ml_XFillRectangles"

external xDrawRectangles :
  dpy:display -> d:'a drawable -> gc:gc -> rectangles:x_rectangle array -> unit
  = "ml_XDrawRectangles"

external xDrawArc :
  dpy:display ->
  d:'a drawable ->
  gc:gc ->
  x:int ->
  y:int ->
  width:uint ->
  height:uint ->
  angle1:int ->
  angle2:int ->
  unit = "ml_XDrawArc_bytecode" "ml_XDrawArc"

external xFillArc :
  dpy:display ->
  d:'a drawable ->
  gc:gc ->
  x:int ->
  y:int ->
  width:uint ->
  height:uint ->
  angle1:int ->
  angle2:int ->
  unit = "ml_XFillArc_bytecode" "ml_XFillArc"

type x_arc = {
  arc_x : int;
  arc_y : int;
  arc_width : uint;
  arc_height : uint;
  arc_angle1 : int;
  arc_angle2 : int;
}

external xDrawArcs :
  dpy:display -> d:'a drawable -> gc:gc -> arcs:x_arc array -> unit
  = "ml_XDrawArcs"

external xFillArcs :
  dpy:display -> d:'a drawable -> gc:gc -> arcs:x_arc array -> unit
  = "ml_XFillArcs"

type shape_kind = Complex | Nonconvex | Convex

external xFillPolygon :
  dpy:display ->
  d:'a drawable ->
  gc:gc ->
  points:xPoint array ->
  shape:shape_kind ->
  mode:coordinate_mode ->
  unit = "ml_XFillPolygon_bytecode" "ml_XFillPolygon"

external xDrawString :
  dpy:display -> d:'a drawable -> gc:gc -> x:int -> y:int -> str:string -> unit
  = "ml_XDrawString_bytecode" "ml_XDrawString"

external xDrawImageString :
  dpy:display -> d:'a drawable -> gc:gc -> x:int -> y:int -> str:string -> unit
  = "ml_XDrawImageString_bytecode" "ml_XDrawImageString"

type xChar2b

external new_xChar2b : char * char -> xChar2b = "ml_alloc_XChar2b"

type xChar2b_string

external new_xChar2b_string : (char * char) array -> xChar2b_string
  = "ml_alloc_XChar2b_string"

external xDrawImageString16 :
  dpy:display ->
  d:'a drawable ->
  gc:gc ->
  x:int ->
  y:int ->
  str16:xChar2b_string ->
  unit = "ml_XDrawImageString16_bytecode" "ml_XDrawImageString16"

external xDrawString16 :
  dpy:display ->
  d:'a drawable ->
  gc:gc ->
  x:int ->
  y:int ->
  str16:xChar2b_string ->
  unit = "ml_XDrawString16_bytecode" "ml_XDrawString16"

external xCopyArea :
  dpy:display ->
  src:'a drawable ->
  dest:'b drawable ->
  gc:gc ->
  src_x:int ->
  src_y:int ->
  width:uint ->
  height:uint ->
  dest_x:int ->
  dest_y:int ->
  unit = "ml_XCopyArea_bytecode" "ml_XCopyArea"

external xCreatePixmap :
  dpy:display ->
  d:'a drawable ->
  width:uint ->
  height:uint ->
  depth:uint ->
  pixmap = "ml_XCreatePixmap"

external xCreateBitmapFromData :
  dpy:display ->
  d:'a drawable ->
  data:string ->
  width:uint ->
  height:uint ->
  pixmap = "ml_XCreateBitmapFromData"

external xCreatePixmapCursor :
  dpy:display ->
  source:pixmap ->
  mask:pixmap ->
  foreground:xColor ->
  background:xColor ->
  x:uint ->
  y:uint ->
  cursor = "ml_XCreatePixmapCursor_bytecode" "ml_XCreatePixmapCursor"

external xFreePixmap : dpy:display -> pixmap -> unit = "ml_XFreePixmap"

external xQueryBestTile :
  dpy:display -> d:'a drawable -> width:uint -> height:uint -> uint * uint
  = "ml_XQueryBestTile"

type xPixmapFormatValues = {
  pxm_depth : int;
  bits_per_pixel : int;
  scanline_pad : int;
}

external xListPixmapFormats : dpy:display -> xPixmapFormatValues array
  = "ml_XListPixmapFormats"

external xBitmapUnit : dpy:display -> int = "ml_XBitmapUnit"
external xBitmapPad : dpy:display -> int = "ml_XBitmapPad"

type byte_order = LSBFirst | MSBFirst

external xImageByteOrder : dpy:display -> byte_order = "ml_XImageByteOrder"

type ximage_format = XYBitmap | XYPixmap | ZPixmap
type xImage

external xCreateImage :
  dpy:display ->
  visual:visual ->
  depth:int ->
  fmt:ximage_format ->
  offset:int ->
  data:'a ->
  width:uint ->
  height:uint ->
  bitmap_pad:int ->
  bytes_per_line:int ->
  xImage = "ml_XCreateImage_bytecode" "ml_XCreateImage"

external xDestroyImage : image:xImage -> unit = "ml_XDestroyImage"

external xSubImage :
  image:xImage -> x:int -> y:int -> width:uint -> height:uint -> xImage
  = "ml_XSubImage"

external xAllPlanes : unit -> uint
  = "ml_XAllPlanes" (* TODO: maybe switch for an ocaml int32 *)

external xGetImage :
  dpy:display ->
  d:'a drawable ->
  x:int ->
  y:int ->
  width:uint ->
  height:uint ->
  plane_mask:uint ->
  fmt:ximage_format ->
  xImage = "ml_XGetImage_bytecode" "ml_XGetImage"

type image_data =
  (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Genarray.t

external xImage_data_ba : image:xImage -> image_data
  = "ml_XImage_data_ba" (* XXX : Experimental ; TODO : test me *)

external xImage_data_str : image:xImage -> string
  = "ml_XImage_data_str" (* XXX : Experimental ; TODO : test me *)

external xGetPixel : image:xImage -> x:int -> y:int -> pixel_color
  = "ml_XGetPixel"

external xPutPixel : image:xImage -> x:int -> y:int -> pixel:pixel_color -> unit
  = "ml_XPutPixel"

external xAddPixel : image:xImage -> v:int -> unit = "ml_XAddPixel"

external xPutImage :
  dpy:display ->
  d:'a drawable ->
  gc:gc ->
  image:xImage ->
  src_x:int ->
  src_y:int ->
  dest_x:int ->
  dest_y:int ->
  width:uint ->
  height:uint ->
  unit = "ml_XPutImage_bytecode" "ml_XPutImage"

external xAutoRepeatOff : dpy:display -> unit = "ml_XAutoRepeatOff"
external xAutoRepeatOn : dpy:display -> unit = "ml_XAutoRepeatOn"
external xQueryKeymap : dpy:display -> string = "ml_XQueryKeymap"

external xQueryPointer :
  dpy:display ->
  win:window ->
  window * int * int * (window * int * int) option * logical_state list
  = "ml_XQueryPointer"

module Got = struct
  type auto_repeat_mode = AutoRepeatModeOff | AutoRepeatModeOn
end

module Set = struct
  type auto_repeat_mode =
    | AutoRepeatModeOff
    | AutoRepeatModeOn
    | AutoRepeatModeDefault
end

type xKeyboardState = {
  key_click_percent : int;
  bell_percent : int;
  bell_pitch : uint;
  bell_duration : uint;
  led_mask : uint;
  global_auto_repeat : Got.auto_repeat_mode;
  auto_repeats : string;
}

external xGetKeyboardControl : dpy:display -> xKeyboardState
  = "ml_XGetKeyboardControl"

type screensaver_mode = ScreenSaverActive | ScreenSaverReset

external xForceScreenSaver : dpy:display -> mode:screensaver_mode -> unit
  = "ml_XForceScreenSaver"

type prefer_blanking = DontPreferBlanking | PreferBlanking | DefaultBlanking
type allow_exposures = DontAllowExposures | AllowExposures | DefaultExposures

type screensaver_values = {
  timeout : int;
  interval : int;
  prefer_blanking : prefer_blanking;
  allow_exposures : allow_exposures;
}

external xGetScreenSaver : dpy:display -> screensaver_values
  = "ml_XGetScreenSaver"

external xSetScreenSaver :
  dpy:display ->
  timeout:int ->
  interval:int ->
  prefer_blanking:prefer_blanking ->
  allow_exposures:allow_exposures ->
  unit = "ml_XSetScreenSaver"

external xActivateScreenSaver : dpy:display -> unit = "ml_XActivateScreenSaver"
external xResetScreenSaver : dpy:display -> unit = "ml_XResetScreenSaver"

type xID

type xErrorEvent_contents = {
  error_display : display;
  error_resourceid : xID; (* resource id                     *)
  error_serial : uint; (* serial number of failed request *)
  error_error_code : char; (* error code of failed request    *)
  error_request_code : char; (* Major op-code of failed request *)
  error_minor_code : char; (* Minor op-code of failed request *)
}

external xErrorEvent_datas : xErrorEvent xEvent -> xErrorEvent_contents
  = "ml_XErrorEvent_datas"

external xSetErrorHandler : unit -> unit = "ml_XSetErrorHandler"

let xSetErrorHandler ~cb =
  Callback.register "Error Handler Callback" cb;
  xSetErrorHandler ()

type cursor_shape =
  | XC_X_cursor
  | XC_arrow
  | XC_based_arrow_down
  | XC_based_arrow_up
  | XC_boat
  | XC_bogosity
  | XC_bottom_left_corner
  | XC_bottom_right_corner
  | XC_bottom_side
  | XC_bottom_tee
  | XC_box_spiral
  | XC_center_ptr
  | XC_circle
  | XC_clock
  | XC_coffee_mug
  | XC_cross
  | XC_cross_reverse
  | XC_crosshair
  | XC_diamond_cross
  | XC_dot
  | XC_dotbox
  | XC_double_arrow
  | XC_draft_large
  | XC_draft_small
  | XC_draped_box
  | XC_exchange
  | XC_fleur
  | XC_gobbler
  | XC_gumby
  | XC_hand1
  | XC_hand2
  | XC_heart
  | XC_icon
  | XC_iron_cross
  | XC_left_ptr
  | XC_left_side
  | XC_left_tee
  | XC_leftbutton
  | XC_ll_angle
  | XC_lr_angle
  | XC_man
  | XC_middlebutton
  | XC_mouse
  | XC_pencil
  | XC_pirate
  | XC_plus
  | XC_question_arrow
  | XC_right_ptr
  | XC_right_side
  | XC_right_tee
  | XC_rightbutton
  | XC_rtl_logo
  | XC_sailboat
  | XC_sb_down_arrow
  | XC_sb_h_double_arrow
  | XC_sb_left_arrow
  | XC_sb_right_arrow
  | XC_sb_up_arrow
  | XC_sb_v_double_arrow
  | XC_shuttle
  | XC_sizing
  | XC_spider
  | XC_spraycan
  | XC_star
  | XC_target
  | XC_tcross
  | XC_top_left_arrow
  | XC_top_left_corner
  | XC_top_right_corner
  | XC_top_side
  | XC_top_tee
  | XC_trek
  | XC_ul_angle
  | XC_umbrella
  | XC_ur_angle
  | XC_watch
  | XC_xterm

external xCreateFontCursor : dpy:display -> shape:cursor_shape -> cursor
  = "ml_XCreateFontCursor"

external xDefineCursor : dpy:display -> win:window -> cursor:cursor -> unit
  = "ml_XDefineCursor"

external xRecolorCursor :
  dpy:display -> cursor:cursor -> foreground:xColor -> background:xColor -> unit
  = "ml_XRecolorCursor"

external xChangePointerControl :
  dpy:display ->
  do_accel:bool ->
  do_threshold:bool ->
  accel_numerator:int ->
  accel_denominator:int ->
  threshold:int ->
  unit = "ml_XChangePointerControl_bytecode" "ml_XChangePointerControl"

external xGetPointerControl : dpy:display -> int * int * int
  = "ml_XGetPointerControl"

external xReparentWindow :
  dpy:display -> win:window -> parent:window -> x:int -> y:int -> unit
  = "ml_XReparentWindow"

type change_mode = SetModeInsert | SetModeDelete

external xChangeSaveSet : dpy:display -> win:window -> mode:change_mode -> unit
  = "ml_XChangeSaveSet"

external xAddToSaveSet : dpy:display -> win:window -> unit = "ml_XAddToSaveSet"

external xRemoveFromSaveSet : dpy:display -> win:window -> unit
  = "ml_XRemoveFromSaveSet"

external xKillClient : dpy:display -> resource:window -> unit = "ml_XKillClient"
external xInitThreads : unit -> unit = "ml_XInitThreads"
external xLockDisplay : dpy:display -> unit = "ml_XLockDisplay"
external xUnlockDisplay : dpy:display -> unit = "ml_XUnlockDisplay"

external xIconifyWindow : dpy:display -> win:window -> scr:screen_number -> unit
  = "ml_XIconifyWindow"

external xWithdrawWindow :
  dpy:display -> win:window -> scr:screen_number -> unit = "ml_XWithdrawWindow"

external xGetCommand : dpy:display -> win:window -> string array
  = "ml_XGetCommand"
