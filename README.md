
# Some notes

## Prereqs

camlp5
pa_ppx
bos
rresult

## To use

opam install those, then you should be able to `#use "include_syntax_ml" ;;`

Then you can `#use "conv.ml";;` for the first example.

## To see the expanded OCaml code, sans quotations:

```
not-ocamlfind preprocess -package camlp5,pa_ppx.testutils,camlp5.quotations,camlp5.pr_o -syntax camlp5o conv.ml 
```
