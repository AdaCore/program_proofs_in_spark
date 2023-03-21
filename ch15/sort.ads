with Sort_Types; use Sort_Types;

package Sort is

   function Is_Sorted (A : Nat_Array; From, To : Index) return Boolean is
     (for all I in From .. To - 1 => A (I) <= A (I + 1))
   with
     Ghost;

   function Is_Sorted (A : Nat_Array) return Boolean is
     (Is_Sorted (A, A'First, A'Last))
   with
     Ghost;

   Permutation : Permut_Array with Ghost;

   function Is_Perm (Left, Right : Nat_Array) return Boolean is
     (Is_Permutation_Array (Permutation)
       and then
     (for all J in Index => Right (J) = Left (Permutation (J))))
   with
     Ghost;

   procedure Selection_Sort (A : in out Nat_Array)
   with
     Post => Is_Sorted (A)
       and then Is_Perm (A'Old, A);

   procedure Quicksort (A : in out Nat_Array)
   with
     Post => Is_Sorted (A)
       and then Is_Perm (A'Old, A);

end Sort;
