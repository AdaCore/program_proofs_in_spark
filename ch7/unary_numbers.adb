package body Unary_Numbers is

   procedure Lemma_To_Int_Of_Int (N : Big_Natural) is
   begin
      if N > 0 then
         Lemma_To_Int_Of_Int (N-1);
      end if;
   end Lemma_To_Int_Of_Int;

   procedure Lemma_Less_Transitive (X, Y : Unary) is
   begin
      if X.Kind = Succ and Y.Kind = Succ then
         Lemma_Less_Transitive (X.Minus_One.all, Y.Minus_One.all);
      end if;
   end Lemma_Less_Transitive;

   procedure Lemma_Add_Correct (X, Y : Unary) is
   begin
      if Y.Kind /= Zero then
         Lemma_Add_Correct (X, Y.Minus_One.all);
      end if;
   end Lemma_Add_Correct;

   procedure Lemma_Sub_Correct (X, Y : Unary) is
   begin
      if Y.Kind /= Zero then
         Lemma_Sub_Correct (X.Minus_One.all, Y.Minus_One.all);
      end if;
   end Lemma_Sub_Correct;

   procedure Lemma_Mul_Correct (X, Y : Unary) is
   begin
      if X.Kind /= Zero then
         Lemma_Mul_Correct (X.Minus_One.all, Y);
      end if;
   end Lemma_Mul_Correct;

   procedure Div_Mod (X, Y : Unary; Q, M : out Unary) is
   begin
      if X < Y then
         Q := Unary'(Kind => Zero);
         M := X;
      else
         Div_Mod (X - Y, Y, Q, M);
         Q := Unary'(Kind => Succ, Minus_One => New_Unary (Q));
      end if;
   end Div_Mod;

end Unary_Numbers;
