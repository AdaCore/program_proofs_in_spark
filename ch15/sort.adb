package body Sort is

   -- Swap the A of A (X) and A (Y).
   -- We could also remove the contract and let it be inlined for proof.
   procedure Swap (A : in out Nat_Array; X, Y : Index)
   with
     Pre  => X in A'Range and Y in A'Range,
     Post => A = (A'Old with delta
                         X => A'Old (Y),
                         Y => A'Old (X))
       and then Permutation = (Permutation'Old with delta
                                 X => Permutation'Old (Y),
                                 Y => Permutation'Old (X))
   is
      Temp       : Integer;
      Temp_Index : Index with Ghost;
   begin
      Temp  := A (X);
      A (X) := A (Y);
      A (Y) := Temp;

      Temp_Index := Permutation (X);
      Permutation (X) := Permutation (Y);
      Permutation (Y) := Temp_Index;
   end Swap;

   -- Finds the index of the smallest element in the slice A (From .. To)
   function Index_Of_Minimum (A : Nat_Array; From, To : Index) return Index
   with
     Pre  => From in A'Range and To in From .. A'Last,
     Post => Index_Of_Minimum'Result in From .. To and then
       (for all I in From .. To =>
          A (Index_Of_Minimum'Result) <= A (I))
   is
      Min : Index range A'Range := From;
   begin
      for Index in From .. To loop
         if A (Index) < A (Min) then
            Min := Index;
         end if;
         pragma Loop_Invariant
           (Min in From .. To and then
              (for all I in From .. Index => A (Min) <= A (I)));
      end loop;

      return Min;
   end Index_Of_Minimum;

   procedure Selection_Sort (A : in out Nat_Array) is
      Smallest : Index range A'Range;  -- Index of the smallest value in the unsorted part
   begin
      if A'Length = 0 then
         return;
      end if;

      Permutation := (for J in Index => J);

      for Current in A'First .. A'Last - 1 loop
         Smallest := Index_Of_Minimum (A, Current, A'Last);

         if Smallest /= Current then
            Swap (A => A,
                  X => Current,
                  Y => Smallest);
         end if;

         pragma Loop_Invariant (Is_Sorted (A, A'First, Current));
         pragma Loop_Invariant
           (for all J in Current + 1 .. A'Last =>
              A (Current) <= A (J));
         pragma Loop_Invariant (Is_Perm (A'Loop_Entry, A));
      end loop;
   end Selection_Sort;

   procedure Quicksort (A : in out Nat_Array) is

      -- Record entry value of A for use in calls to Is_Perm property
      A_Entry : constant Nat_Array := A with Ghost;

      function Split_Point (A : Nat_Array; N : Index'Base) return Boolean is
        (for all I in A'Range => (for all J in A'Range =>
           (if I < N and N <= J then A(I) <= A(J))))
      with
        Ghost;

      function Swap_Frame (A1, A2 : Nat_Array; Lo, Hi : Index'Base) return Boolean is
        (A1'First = A2'First
         and then A1'Last = A2'Last
         and then (for all I in A1'Range =>
                     (if I < Lo or Hi <= I then A2(I) = A1(I))))
      with
        Ghost;

      procedure Partition (A : in out Nat_Array; Lo, Hi : Index'Base; P : out Index)
      with
        Pre => Lo in A'First .. A'Last+1
          and then Hi in A'First .. A'Last+1
          and then Lo < Hi
          and then Split_Point (A, Lo)
          and then Split_Point (A, Hi)
          and then Same_Bounds (A_Entry, A)
          and then Is_Perm (A_Entry, A),
        Post => P in Lo .. Hi-1
          and then (for all I in Lo .. P-1 => A(I) < A(P))
          and then (for all I in P .. Hi-1 => A(P) <= A(I))
          and then Split_Point (A, Lo)
          and then Split_Point (A, Hi)
          and then Is_Perm (A_Entry, A)
          and then Swap_Frame (A, A'Old, Lo, Hi)
      is
         Pivot : Natural := A(Lo);
         M : Index'Base := Lo+1;
         N : Index'Base := Hi;
      begin
         while M < N loop

            pragma Loop_Invariant (Lo < M and M <= N and N <= Hi);
            pragma Loop_Invariant (A(Lo) = Pivot);
            pragma Loop_Invariant (for all I in Lo+1 .. M-1 => A(I) < Pivot);
            pragma Loop_Invariant (for all I in N .. Hi-1 => Pivot <= A(I));
            pragma Loop_Invariant (Split_Point (A, Lo));
            pragma Loop_Invariant (Split_Point (A, Hi));
            pragma Loop_Invariant (Is_Perm (A_Entry, A));
            pragma Loop_Invariant (Swap_Frame (A, A'Loop_Entry, Lo, Hi));
            pragma Loop_Variant (Increases => M, Decreases => N);

            if A(M) < Pivot then
               M := M+1;
            else
               N := N-1;
               Swap (A, M, N);
            end if;
         end loop;

         M := M-1;
         Swap (A, Lo, M);
         P := M;
      end Partition;

      procedure Quicksort_Aux (A : in out Nat_Array; Lo, Hi : Index'Base)
      with
        Subprogram_Variant => (Decreases => Hi - Lo),
        Pre => Lo in A'First .. A'Last+1
          and then Hi in A'First .. A'Last+1
          and then Lo <= Hi
          and then Split_Point (A, Lo)
          and then Split_Point (A, Hi)
          and then Same_Bounds (A_Entry, A)
          and then Is_Perm (A_Entry, A),
        Post =>
          (Lo = Hi or else Is_Sorted (A, From => Lo, To => Hi-1))
          and then Split_Point (A, Lo)
          and then Split_Point (A, Hi)
          and then Is_Perm (A_Entry, A)
          and then Swap_Frame (A, A'Old, Lo, Hi)
      is
         P : Index;
      begin
         if Hi - Lo <= 1 then
            return;
         end if;

         Partition (A, Lo, Hi, P);
         Quicksort_Aux (A, Lo, P);
         Quicksort_Aux (A, P+1, Hi);
      end Quicksort_Aux;

   begin
      if A'Length = 0 then
         return;
      end if;

      Permutation := (for J in Index => J);

      Quicksort_Aux (A, A'First, A'Last+1);
   end Quicksort;

end Sort;
