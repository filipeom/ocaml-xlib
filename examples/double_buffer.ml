(* Demonstration of double-buffer rendering.

   - left clic: with double-buffer
   - right clic: single buffer

   We render to a pixmap and then copy the contents of the pixmap to the
   window with xCopyArea().

   This will be similar to many implementations of glXSwapBuffers, however,
   many GL implementation allow synchronization with the refresh rate,
   while Xlib offers no such feature.
   Note that glXSwapBuffers executes an implicit glFlush, while xCopyArea
   does not execute an implicit xFlush.
*)
open Xlib

let () =
  let width = 500 and height = 500 in
  let dpy = xOpenDisplay ~name:"" in

  (* initialisation of the standard variables *)
  let screen = xDefaultScreen ~dpy in
  let root = xDefaultRootWindow ~dpy
  and visual = xDefaultVisual ~dpy ~scr:screen
  and depth = xDefaultDepth ~dpy ~scr:screen
  and fg = xBlackPixel ~dpy ~scr:screen
  and bg = xWhitePixel ~dpy ~scr:screen in

  (* set foreground and background in the graphics context *)
  let gcvalues = new_xGCValues () in
  xGCValues_set_foreground ~gcv:gcvalues ~fg;
  xGCValues_set_background ~gcv:gcvalues ~bg;
  let gc = xCreateGC ~dpy ~d:root [ GCForeground; GCBackground ] gcvalues in

  (* creation of the double buffer *)
  let db = xCreatePixmap ~dpy ~d:root ~width ~height ~depth in
  (* without these lines previous images from memory will appear *)
  xSetForeground ~dpy ~gc ~fg:bg;
  xFillRectangle ~dpy ~d:db ~gc ~x:0 ~y:0 ~width ~height;
  xSetForeground ~dpy ~gc ~fg;

  (* window attributes *)
  let xswa = new_win_attr () in

  (* the events we want *)
  xswa.set_event_mask
    ~event_mask:
      [
        ExposureMask;
        ButtonPressMask;
        ButtonReleaseMask;
        PointerMotionMask;
        KeyPressMask;
      ];

  (* border and background colors *)
  xswa.set_background_pixel ~background_pixel:bg;
  xswa.set_border_pixel ~border_pixel:fg;

  let win =
    xCreateWindow ~dpy ~parent:root ~x:100 ~y:100 ~width ~height ~border_width:2
      ~depth ~win_class:InputOutput ~visual
      ~valuemask:[ CWEventMask; CWBorderPixel; CWBackPixel ]
      ~attributes:xswa.attr
  in

  (* END *)
  xMapRaised ~dpy ~win;

  let report = new_xEvent () in
  while true do
    xNextEvent ~dpy ~event:report;
    match xEventType ~event:report with
    | Expose ->
        (* remove all the Expose events from the event stack *)
        while xCheckTypedEvent ~dpy Expose report do
          ()
        done;
        xCopyArea ~dpy ~src:db ~dest:win ~gc ~src_x:0 ~src_y:0 ~width ~height
          ~dest_x:0 ~dest_y:0;
        (* force refresh the screen *)
        xFlush ~dpy
    | ButtonPress -> (
        let xbutton = xButtonEvent_datas (to_xButtonEvent ~event:report) in
        match xbutton.button with
        (* left clic *)
        | Button1 ->
            (* animation with the double buffer *)
            for j = 0 to pred 100 do
              xSetForeground ~dpy ~gc ~fg:bg;
              xFillRectangle ~dpy ~d:db ~gc ~x:0 ~y:0 ~width ~height;
              xSetForeground ~dpy ~gc ~fg;

              for i = 0 to pred 100 do
                let i = i * 4 in
                xDrawArc ~dpy ~d:db ~gc ~x:(xbutton.button_x + j)
                  ~y:(xbutton.button_y + j) ~width:i ~height:i ~angle1:0
                  ~angle2:(360 * 64)
              done;

              xCopyArea ~dpy ~src:db ~dest:win ~gc ~src_x:0 ~src_y:0 ~width
                ~height ~dest_x:0 ~dest_y:0;
              (* force refresh the screen *)
              xFlush ~dpy
            done
        (* right and middle clic *)
        | Button2 | Button3 ->
            (* animation without double buffer *)
            for j = 0 to pred 100 do
              xClearWindow ~dpy ~win;

              for i = 0 to pred 100 do
                let i = i * 4 in
                xDrawArc ~dpy ~d:win ~gc ~x:(xbutton.button_x + j)
                  ~y:(xbutton.button_y + j) ~width:i ~height:i ~angle1:0
                  ~angle2:(360 * 64)
              done
            done
        | _ -> ())
    | KeyPress ->
        (* exit on any key press *)
        xCloseDisplay ~dpy;
        exit 0
    | ConfigureNotify -> ()
    | _ -> ()
  done
