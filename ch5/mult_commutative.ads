-- 5.6 Example: Associativity of Multiplication

with Ada.Numerics.Big_Numbers.Big_Integers; use Ada.Numerics.Big_Numbers.Big_Integers;

package Mult_Commutative is

   function Big (X : Integer) return Big_Integer renames To_Big_Integer;

   function Mult (X, Y : Big_Natural) return Big_Natural is
     (if Y = Big (0) then Big (0) else X + Mult (X, Y-1))
   with
     Annotate => (GNATprove, Terminating),
     Annotate => (GNATprove, False_Positive, "terminating annotation",
                  "That version of SPARK does not allow variant on Big_Natural");

   procedure Lemma_Mult_Commutative (X, Y : Big_Natural)
   with
     Ghost,
     Post => Mult (X, Y) = Mult (Y, X);

end Mult_Commutative;
