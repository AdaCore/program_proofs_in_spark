package body Dutch_National_Flag is

   -- local procedure Swap without contract is inlined for proof
   procedure Swap (A : in out Arr; I, J : Index) is
      Tmp : constant Color := A(I);
      Tmp_Index : Index := Permutation(I) with Ghost;
   begin
      A(I) := A(J);
      A(J) := Tmp;

      Permutation(I) := Permutation(J);
      Permutation(J) := Tmp_Index;
   end Swap;

   procedure Dutch_Flag (A : in out Arr) is
      R : Index'Base := A'First;
      W : Index'Base := A'First;
      B : Index'Base := A'Last + 1;
   begin
      Permutation := (for J in Permutation'Range => J);

      while W < B loop

         pragma Loop_Invariant (R in A'First .. W);
         pragma Loop_Invariant (B in W .. A'Last+1);
         pragma Loop_Invariant (for all I in A'First .. R-1 => A(I) = Red);
         pragma Loop_Invariant (for all I in R .. W-1 => A(I) = White);
         pragma Loop_Invariant (for all I in B .. A'Last => A(I) = Blue);
         pragma Loop_Invariant (Is_Perm (A'Loop_Entry, A));
         pragma Loop_Variant (Increases => W, Decreases => B);

         case A(W) is
            when White =>
               W := W+1;
            when Red =>
               Swap (A, R, W); R := R+1; W := W+1;
            when Blue =>
               B := B-1; Swap (A, W, B);
         end case;
      end loop;
   end Dutch_Flag;

end Dutch_National_Flag;
