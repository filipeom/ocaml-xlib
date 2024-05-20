(lang dune 3.10)

(name xlib)

(generate_opam_files true)

(source
 (github filipeom/ocaml-xlib))

(authors "Filipe Marques")

(maintainers "Filipe Marques")

(documentation "https://github.com/filipeom/ocaml-xlib")

(license "MIT")

(package
 (name xlib)
 (synopsis "Bindings for the X11 library")
 (description "OCaml bindings to the X11 library.")
 (depends
  dune
  ocaml
  conf-libX11))
