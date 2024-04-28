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
 (synopsis "Bindings to the Xlib library")
 (description "OCaml bindings to the Xlib library.")
 (depends
  dune
  ocaml
  conf-libX11))

(package
 (allow_empty)
 (name keysym)
 (synopsis "Todo")
 (description "Todo")
 (depends
  dune
  ocaml
  xlib))

(package
 (allow_empty)
 (name keysym_match)
 (synopsis "Todo")
 (description "Todo")
 (depends
  dune
  ocaml
  xlib))

(package
 (allow_empty)
 (name GLX)
 (synopsis "Todo")
 (description "Todo")
 (depends
  dune
  ocaml
  xlib))
