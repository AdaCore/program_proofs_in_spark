package Sort_Types is

   subtype Index is Integer range 1 .. 100;

   type Nat_Array is array (Index range <>) of Natural;

   type Permut_Array is array (Index range <>) of Index with Ghost;

   function Is_Permutation_Array (Permut : Permut_Array) return Boolean is
     ((for all J in Permut'Range => Permut(J) in Permut'Range)
        and then
      (for all J in Index =>
         (for all K in Index =>
            (if J /= K then Permut (J) /= Permut (K)))))
   with
     Ghost;

end Sort_Types;
