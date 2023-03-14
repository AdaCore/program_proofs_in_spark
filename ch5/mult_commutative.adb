package body Mult_Commutative is

   procedure Lemma_Mult_Commutative (X, Y : Big_Natural) is
   begin
      if X = Y then
         null;
      elsif X = 0 then
         Lemma_Mult_Commutative (X, Y-1);
      elsif Y < X then
         Lemma_Mult_Commutative (Y, X);
      else
         Lemma_Mult_Commutative (X, Y-1);
         Lemma_Mult_Commutative (X-1, Y-1);
         Lemma_Mult_Commutative (X-1, Y);
      end if;
   end Lemma_Mult_Commutative;

end Mult_Commutative;
