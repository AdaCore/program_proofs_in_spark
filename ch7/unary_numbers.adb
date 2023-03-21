package body Unary_Numbers is

   procedure Lemma_To_Int_Of_Int (N : Big_Natural) is
   begin
      if N > 0 then
         Lemma_To_Int_Of_Int (N-1);
         pragma Annotate (GNATprove, False_Positive, "terminating annotation",
                          "That version of SPARK does not allow variant on Big_Natural");
      end if;
   end Lemma_To_Int_Of_Int;

   procedure Lemma_Less_Transitive (X, Y : Unary) is
   begin
      if X.Kind = Succ and Y.Kind = Succ then
         Lemma_Less_Transitive (X.Minus_One.all, Y.Minus_One.all);
         pragma Annotate (GNATprove, False_Positive, "terminating annotation",
                          "That version of SPARK does not allow structural variant");
      end if;
   end Lemma_Less_Transitive;

   procedure Lemma_Add_Correct (X, Y : Unary) is
   begin
      if Y.Kind /= Zero then
         Lemma_Add_Correct (X, Y.Minus_One.all);
         pragma Annotate (GNATprove, False_Positive, "terminating annotation",
                          "That version of SPARK does not allow structural variant");
      end if;
   end Lemma_Add_Correct;

   procedure Lemma_Sub_Correct (X, Y : Unary) is
   begin
      if Y.Kind /= Zero then
         Lemma_Sub_Correct (X.Minus_One.all, Y.Minus_One.all);
         pragma Annotate (GNATprove, False_Positive, "terminating annotation",
                          "That version of SPARK does not allow structural variant");
      end if;
   end Lemma_Sub_Correct;

   procedure Lemma_Mul_Correct (X, Y : Unary) is
   begin
      if X.Kind /= Zero then
         Lemma_Add_Correct (Y, X.Minus_One.all * Y);
         Lemma_Mul_Correct (X.Minus_One.all, Y);
         pragma Annotate (GNATprove, False_Positive, "terminating annotation",
                          "That version of SPARK does not allow structural variant");
      end if;
   end Lemma_Mul_Correct;

   procedure Div_Mod (X, Y : Unary; Q, M : out Unary) is
   begin
      if X < Y then
         Q := Unary'(Kind => Zero);
         M := X;
      else
         Div_Mod (X - Y, Y, Q, M);
         pragma Annotate (GNATprove, False_Positive, "terminating annotation",
                          "That version of SPARK does not allow variant on Big_Natural");
         Lemma_Mul_Correct (Q, Y);
         Lemma_Add_Correct (Q * Y, M);
         Lemma_Sub_Correct (X, Y);
         Q := Unary'(Kind => Succ, Minus_One => New_Unary (Q));
      end if;
      Lemma_Mul_Correct (Q, Y);
      Lemma_Add_Correct (Q * Y, M);
   end Div_Mod;

end Unary_Numbers;
