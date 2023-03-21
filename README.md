# Program Proofs in SPARK

This repository contains some programs from [Rustan Leino's excellent book "Program Proofs"](https://program-proofs.com/) verified with SPARK.

All examples in branch `master` prove at level 2 (using switch `--level=2`) using SPARK Pro 23.

All examples in branch `fsf` prove at level 2 (using switch `--level=2`) using SPARK FSF, that you can download directly or through Alire following the instructions on [the README of the SPARK project](https://github.com/AdaCore/spark2014).

Compared to SPARK Pro 23, the current FSF release does not include yet:

- structural loop and subprogram variants

- loop and subprogram variants on `Big_Natural`

- the new organization of SPARKlib

- annotation `Automatic_Instantiation`
