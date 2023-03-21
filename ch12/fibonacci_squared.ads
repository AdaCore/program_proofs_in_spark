with Ada.Numerics.Big_Numbers.Big_Integers; use Ada.Numerics.Big_Numbers.Big_Integers;

package Fibonacci_Squared is

   function Fib (N : Big_Natural) return Big_Natural is
      (if N < 2 then N else Fib (N-1) + Fib (N-2))
   with
     Annotate => (GNATprove, Terminating),
     Annotate => (GNATprove, False_Positive, "terminating annotation",
                  "That version of SPARK does not allow variant on Big_Natural");

   function Square_Fib (N : Big_Natural) return Big_Natural
   with
     Post => Square_Fib'Result = Fib (N) * Fib (N);

end Fibonacci_Squared;
