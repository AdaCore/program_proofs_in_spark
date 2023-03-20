package Dutch_National_Flag is

   type Color is (Red, White, Blue);

   type Index is new Natural range 0 .. Natural'Last-1;
   type Arr is array (Index range <>) of Color;

   type Permut_Array is array (Index range <>) of Index with Ghost;

   function Is_Permutation_Array (Permut : Permut_Array) return Boolean is
     ((for all J in Permut'Range => Permut(J) in Permut'Range)
        and then
      (for all J in Permut'Range =>
         (for all K in Permut'Range =>
            (if J /= K then Permut(J) /= Permut(K)))))
   with
     Ghost;

   Permutation : Permut_Array(Index) with Ghost;
   -- variable Permutation holds the Ghost witness for the current permutation

   function Is_Perm (Left, Right : Arr) return Boolean is
     (Is_Permutation_Array (Permutation(Left'Range))
       and then
     (for all J in Left'Range => Right(J) = Left(Permutation(J))))
   with
     Ghost,
     Pre => Left'First = Right'First and Left'Last = Right'Last;

   procedure Dutch_Flag (A : in out Arr)
   with
     Post => (for all I in A'Range => (for all J in A'Range =>
                (if I < J then A(I) <= A(J))))
       and then Is_Perm (A'Old, A);

end Dutch_National_Flag;
