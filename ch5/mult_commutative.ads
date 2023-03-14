-- 5.6 Example: Associativity of Multiplication

with SPARK.Big_Integers; use SPARK.Big_Integers;

package Mult_Commutative is

   function Mult (X, Y : Big_Natural) return Big_Natural is
     (if Y = 0 then 0 else X + Mult (X, Y-1))
   with
     Subprogram_Variant => (Decreases => Y);

   procedure Lemma_Mult_Commutative (X, Y : Big_Natural)
   with
     Ghost,
     Subprogram_Variant => (Decreases => X, Decreases => Y),
     Post => Mult (X, Y) = Mult (Y, X);

end Mult_Commutative;
