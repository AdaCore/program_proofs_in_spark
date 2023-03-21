with Ada.Numerics.Big_Numbers.Big_Integers; use Ada.Numerics.Big_Numbers.Big_Integers;

package Unary_Numbers is

   function Big (X : Integer) return Big_Integer renames To_Big_Integer;

   type Zero_Or_Succ is (Zero, Succ);

   type Unary;
   type Unary_Acc is not null access constant Unary;
   type Unary (Kind : Zero_Or_Succ := Zero) is record
      case Kind is
         when Zero => null;
         when Succ => Minus_One : Unary_Acc;
      end case;
   end record;

   function New_Unary (U : Unary) return Unary_Acc is
     (new Unary'(U))
   with
     Annotate => (GNATprove, Intentional, "memory leak",
                  "allocation of access-to-constant is not reclaimed");

   function To_Int (U : Unary) return Big_Natural is
      (case U.Kind is
         when Zero => Big (0),
         when Succ => Big (1) + To_Int (U.Minus_One.all))
   with
     Annotate => (GNATprove, Terminating);

   function Of_Int (N : Big_Natural) return Unary is
     (if N = 0 then
         Unary'(Kind => Zero)
      else
         Unary'(Kind => Succ, Minus_One => New_Unary (Of_Int (N -1))))
   with
     Annotate => (GNATprove, Terminating);

   procedure Lemma_To_Int_Of_Int (N : Big_Natural)
   with
     Ghost,
     Post => To_Int (Of_Int (N)) = N,
     Annotate => (GNATprove, Terminating);

   -- Of_Int_To_Int cannot be expressed as pointer equality is not allowed.

   function "<" (X, Y : Unary) return Boolean is
      (if X.Kind = Zero and Y.Kind = Succ then True
       elsif Y.Kind = Zero then False
       else X.Minus_One.all < Y.Minus_One.all)
   with
     Annotate => (GNATprove, Terminating);

   procedure Lemma_Less_Transitive (X, Y : Unary)
   with
     Ghost,
     Post => (X < Y) = (To_Int (X) < To_Int (Y)),
     Annotate => (GNATprove, Terminating);

   function "+" (X, Y : Unary) return Unary is
     (if Y.Kind = Zero then
         X
      else
         Unary'(Kind => Succ, Minus_One => New_Unary(X + Y.Minus_One.all)))
   with
     Annotate => (GNATprove, Terminating);

   procedure Lemma_Add_Correct (X, Y : Unary)
   with
     Ghost,
     Post => To_Int (X + Y) = To_Int (X) + To_Int (Y),
     Annotate => (GNATprove, Terminating);

   function "-" (X, Y : Unary) return Unary is
     (if Y.Kind = Zero then
         X
      else
         X.Minus_One.all - Y.Minus_One.all)
   with
     Pre  => not (X < Y),
     Annotate => (GNATprove, Terminating);

   procedure Lemma_Sub_Correct (X, Y : Unary)
   with
     Ghost,
     Pre  => not (X < Y),
     Post => To_Int (X - Y) = To_Int (X) - To_Int (Y),
     Annotate => (GNATprove, Terminating);

   function "*" (X, Y : Unary) return Unary is
     (if X.Kind = Zero then
         Unary'(Kind => Zero)
      else
         Y + (X.Minus_One.all * Y))
   with
     Annotate => (GNATprove, Terminating);

   procedure Lemma_Mul_Correct (X, Y : Unary)
   with
     Ghost,
     Post => To_Int (X * Y) = To_Int (X) * To_Int (Y),
     Annotate => (GNATprove, Terminating);

   procedure Div_Mod (X, Y : Unary; Q, M : out Unary)
   with
     Annotate => (GNATprove, Terminating),
     Annotate => (GNATprove, False_Positive, "terminating annotation",
                  "That version of SPARK does not allow variant on Big_Natural"),
     Pre  => To_Int (Y) /= 0
       and then not Q'Constrained
       and then not M'Constrained,
     Post => To_Int (Q * Y + M) = To_Int (X)
       and then M < Y;

end Unary_Numbers;
