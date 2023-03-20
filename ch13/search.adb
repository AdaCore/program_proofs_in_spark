package body Search is

   procedure Slope_Search
     (A   : Matrix;
      Key : Value;
      M   : out Row;
      N   : out Col)
   is
   begin
      M := A'First(1);
      N := A'Last(2);

      while A(M,N) /= Key loop

         pragma Loop_Invariant (M in A'Range(1) and N in A'Range(2));
         pragma Loop_Invariant
           (for some I in M .. A'Last(1) =>
              (for some J in A'First(2) .. N =>
                 A(I,J) = Key));
         pragma Loop_Variant (Increases => M, Decreases => N);

         if A(M,N) < Key then
            M := M+1;
         else
            N := N-1;
         end if;
      end loop;
   end Slope_Search;

   function Canyon_Search (A, B : Arr) return Value is
      M : Index'Base := A'First;
      N : Index'Base := B'First;
      D : Value := Dist (A(M), B(N));
   begin
      while M <= A'Last and N <= B'Last loop

         pragma Loop_Invariant (M in A'Range and N in B'Range);
         pragma Loop_Invariant
           (for some I in A'Range => (for some J in B'Range =>
              D = Dist (A(I), B(J))));
         pragma Loop_Invariant
           (for all I in A'Range => (for all J in B'Range =>
              D <= Dist (A(I), B(J)) or (M <= I and N <= J)));

         D := Value'Min (D, Dist (A(M), B(N)));
         if A(M) < B(N) then
            M := M+1;
         elsif A(M) > B(N) then
            N := N+1;
         else
            return 0;
         end if;
      end loop;

      return D;
   end Canyon_Search;

end Search;
