#include <X11/Xlib.h>
#include <caml/alloc.h>
#include <caml/custom.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>

static struct custom_operations xlib_display_ops = {
    "caml.xlib_display",        custom_finalize_default,
    custom_compare_default,     custom_hash_default,
    custom_serialize_default,   custom_deserialize_default,
    custom_compare_ext_default, custom_fixed_length_default};

static struct custom_operations xlib_window_ops = {
    "caml.xlib_window",         custom_finalize_default,
    custom_compare_default,     custom_hash_default,
    custom_serialize_default,   custom_deserialize_default,
    custom_compare_ext_default, custom_fixed_length_default};

/* Accessing the Display * part of an OCaml custom block */
#define Display_val(v) (*((Display **)Data_custom_val(v)))
#define Window_val(v) (*((Window *)Data_custom_val(v)))

/* Allocating an OCaml custom block to hold the given Display * */
static value alloc_display(Display *dpy) {
  value v = caml_alloc_custom(&xlib_display_ops, sizeof(Display *), 0, 1);
  Display_val(v) = dpy;
  return v;
}

CAMLprim value caml_x11_xOpenDisplay(value display_name) {
  CAMLparam1(display_name);
  Display *dpy = XOpenDisplay(String_val(display_name));
  if (dpy == NULL)
    caml_failwith("XOpenDisplay");
  CAMLreturn(alloc_display(dpy));
}

CAMLprim value caml_x11_xCloseDisplay(value display) {
  CAMLparam1(display);
  XCloseDisplay(Display_val(display));
  CAMLreturn(Val_unit);
}

CAMLprim value caml_x11_xSync(value display, value discard) {
  CAMLparam2(display, discard);
  XSync(Display_val(display), Bool_val(discard));
  CAMLreturn(Val_unit);
}

static value alloc_window(Window win) {
  value v = caml_alloc_custom(&xlib_window_ops, sizeof(Window *), 0, 1);
  Window_val(v) = win;
  return v;
}

CAMLprim value caml_x11_xDefaultRootWindow(value display) {
  CAMLparam1(display);
  CAMLreturn(alloc_window(DefaultRootWindow(Display_val(display))));
}

CAMLprim value caml_x11_xStoreName(value display, value win, value name) {
  CAMLparam3(display, win, name);
  XStoreName(Display_val(display), Window_val(win), String_val(name));
  CAMLreturn(Val_unit);
}
