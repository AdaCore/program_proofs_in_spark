with SPARK.Big_Integers; use SPARK.Big_Integers;

package Unary_Numbers is

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
         when Zero => 0,
         when Succ => 1 + To_Int (U.Minus_One.all))
   with
     Subprogram_Variant => (Structural => U);

   function Of_Int (N : Big_Natural) return Unary is
     (if N = 0 then
         Unary'(Kind => Zero)
      else
         Unary'(Kind => Succ, Minus_One => New_Unary (Of_Int (N -1))))
   with
     Subprogram_Variant => (Decreases => N);

   procedure Lemma_To_Int_Of_Int (N : Big_Natural)
   with
     Ghost,
     Subprogram_Variant => (Decreases => N),
     Post => To_Int (Of_Int (N)) = N;

   -- Of_Int_To_Int cannot be expressed as pointer equality is not allowed.

   function "<" (X, Y : Unary) return Boolean is
      (if X.Kind = Zero and Y.Kind = Succ then True
       elsif Y.Kind = Zero then False
       else X.Minus_One.all < Y.Minus_One.all)
   with
     Subprogram_Variant => (Structural => X);

   procedure Lemma_Less_Transitive (X, Y : Unary)
   with
     Ghost,
     Subprogram_Variant => (Structural => X),
     Post => (X < Y) = (To_Int (X) < To_Int (Y));

   function "+" (X, Y : Unary) return Unary is
     (if Y.Kind = Zero then
         X
      else
         Unary'(Kind => Succ, Minus_One => New_Unary(X + Y.Minus_One.all)))
   with
     Subprogram_Variant => (Structural => Y);

   procedure Lemma_Add_Correct (X, Y : Unary)
   with
     Ghost,
     Subprogram_Variant => (Structural => Y),
     Post => To_Int (X + Y) = To_Int (X) + To_Int (Y),
     Annotate => (GNATprove, Automatic_Instantiation);

   function "-" (X, Y : Unary) return Unary is
     (if Y.Kind = Zero then
         X
      else
         X.Minus_One.all - Y.Minus_One.all)
   with
     Subprogram_Variant => (Structural => Y),
     Pre  => not (X < Y);

   procedure Lemma_Sub_Correct (X, Y : Unary)
   with
     Ghost,
     Subprogram_Variant => (Structural => Y),
     Pre  => not (X < Y),
     Post => To_Int (X - Y) = To_Int (X) - To_Int (Y),
     Annotate => (GNATprove, Automatic_Instantiation);

   function "*" (X, Y : Unary) return Unary is
     (if X.Kind = Zero then
         Unary'(Kind => Zero)
      else
         Y + (X.Minus_One.all * Y))
   with
     Subprogram_Variant => (Structural => X);

   procedure Lemma_Mul_Correct (X, Y : Unary)
   with
     Ghost,
     Subprogram_Variant => (Structural => X),
     Post => To_Int (X * Y) = To_Int (X) * To_Int (Y),
     Annotate => (GNATprove, Automatic_Instantiation);

   procedure Div_Mod (X, Y : Unary; Q, M : out Unary)
   with
     Subprogram_Variant => (Decreases => To_Int (X)),
     Pre  => To_Int (Y) /= 0
       and then not Q'Constrained
       and then not M'Constrained,
     Post => To_Int (Q * Y + M) = To_Int (X)
       and then M < Y;

end Unary_Numbers;
