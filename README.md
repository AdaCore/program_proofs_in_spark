# Program Proofs in SPARK

This repository contains some programs from [Rustan Leino's excellent book "Program Proofs"](https://program-proofs.com/) verified with SPARK.

All examples in branch `master` prove at level 2 (using switch `--level=2`) using SPARK Pro 23.

All examples in branch `fsf` prove at level 2 (using switch `--level=2`) using SPARK FSF, that you can download directly or through Alire following the instructions on [the README of the SPARK project](https://github.com/AdaCore/spark2014).

Compared to SPARK Pro 23, the current FSF release does not include yet:

- structural loop and subprogram variants

- loop and subprogram variants on `Big_Natural`

- the new organization of SPARKlib

- annotation `Automatic_Instantiation`

If you want to contribute another example, please open a PR with the code, following the organization of existing chapters, with a project file per chapter. Missing examples of interest are:

- the list operation of chapter 6

- insertion sort and merge sort from chapter 8

- the queue of chapter 9

- the priority queue of chapter 10

- the sums of chapter 12

- linear search and binary search of chapter 13

- the array operations of chapter 14

- the objects with invariants of chapter 16

- the objects with dynamic allocation of chapter 17

For many of these, inspiration from similar examples can be found in the examples presented in [the SPARK User's Guide](https://docs.adacore.com/live/wave/spark2014/html/spark2014_ug/index.html).
