pragma Unevaluated_Use_Of_Old (Allow);

with SPARK.Big_Integers; use SPARK.Big_Integers;

package body Lists is

   procedure Reverse_List (L : in out List_Acc) is
      R : List_Acc := null;
   begin
      while L /= null loop

         pragma Loop_Variant (Decreases => Last (Model (L)));
         pragma Loop_Invariant (Model (R).Length + Model (L).Length = Model (L).Length'Loop_Entry);
         pragma Loop_Invariant
           (for all J in Interval'(1,Last (Model (R))) =>
              Model (R).Get (J) = Model (L)'Loop_Entry.Get (Last (Model (R)) - J + 1));
         pragma Loop_Invariant
           (for all J in Interval'(1,Last (Model (L))) =>
              Model (L).Get (J) = Model (L)'Loop_Entry.Get (Last (Model (R)) + J));

         declare
            Tmp : List_Acc := L;
         begin
            L := Tmp.Next;
            Tmp.Next := R;
            R := Tmp;
         end;
      end loop;

      L := R;
   end Reverse_List;

end Lists;
