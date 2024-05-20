(lang dune 3.10)

(name xlib)

(generate_opam_files true)

(source
 (github filipeom/ocaml-xlib))

(authors "Florent Monnier")

(maintainers "Filipe Marques")

(documentation "http://decapode314.free.fr/ocaml/Xlib/doc/")

(license "MIT")

(package
 (name xlib)
 (synopsis "Bindings for the X11 library")
 (description "OCaml bindings to the X11 library.")
 (depends
  dune
  ocaml
  conf-libX11))
