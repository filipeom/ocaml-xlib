# OCaml Xlib bindings

OCaml bindings for the Xlib library.

## Installation

### OPAM

- Install [opam](https://opam.ocaml.org/doc/Install.html).
- Bootstrap the OCaml compiler:

```sh
opam init
opam switch create 5.1.0 5.1.0
```

```sh
opam install ... # Not yet available
```

### Build from source

- Install the library dependencies:

```sh
git clone https://github.com/filipeom/ocaml-xlib.git
cd ocaml-xlib
opam install . --deps-only
```

- Build and test:

```sh
dune build
dune runtest
```

- Install `ocaml-xlib` on your switch by running:

```sh
dune install
```

## Depandants

Projects currently using `ocaml-xlib`:

- [filipeom/dwmstatusml](https://github.com/filipeom/dwmstatusml): A status bar
for dwm written in OCaml.

## About

This project started as a fork of the original project by Florent Monnier, which can
be found here: [fccm/ocaml-xlib](https://github.com/fccm/ocaml-xlib) and
[docs](http://decapode314.free.fr/ocaml/Xlib/), but has since been rewritten from scratch.
