with SPARK.Big_Integers; use SPARK.Big_Integers;

package Fibonacci_Squared is

   function Fib (N : Big_Natural) return Big_Natural is
      (if N < 2 then N else Fib (N-1) + Fib (N-2))
   with
     Subprogram_Variant => (Decreases => N);

   function Square_Fib (N : Big_Natural) return Big_Natural
   with
     Post => Square_Fib'Result = Fib (N) * Fib (N);

end Fibonacci_Squared;
