with Search; use Search;

procedure Test_Search is

   A : constant Arr := (0, 5, 7, 10, 124, 234);
   B : constant Arr := (2, 23, 145, 2356);

   Dist_AA : constant Value := Canyon_Search (A, A);
   Dist_BB : constant Value := Canyon_Search (B, B);
   Dist_AB : constant Value := Canyon_Search (A, B);
   Dist_BA : constant Value := Canyon_Search (B, A);
begin
   pragma Assert (Dist_AA = 0);
   pragma Assert (Dist_BB = 0);
   pragma Assert (Dist_AB = Dist_BA);
end Test_Search;
