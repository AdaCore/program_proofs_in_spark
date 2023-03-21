package body Fibonacci_Squared is

   function Square_Fib (N : Big_Natural) return Big_Natural is
      I : Big_Natural := 0;
      X : Big_Natural := 0;
      Y : Big_Natural := 1;
      K : Big_Natural := 0;
   begin
      while I < N loop
         pragma Loop_Invariant (0 <= I and I <= N);
         pragma Loop_Invariant (X = Fib (I) * Fib (I));
         pragma Loop_Invariant (Y = Fib (I+1) * Fib (I+1));
         pragma Loop_Invariant (K = 2 * Fib (I) * Fib (I+1));

         declare
            YY : constant Big_Natural := Y;
         begin
            Y := X + K + YY;
            X := YY;
            K := K + YY + YY;
            I := I + 1;
         end;
      end loop;

      return X;
   end Square_Fib;

end Fibonacci_Squared;
