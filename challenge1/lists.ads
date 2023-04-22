with SPARK.Containers.Functional.Infinite_Sequences;
with SPARK.Big_Intervals; use SPARK.Big_Intervals;

package Lists is

   type List;
   type List_Acc is access List;
   type List is record
      Value : Integer;
      Next : List_Acc;
   end record;

   package LLists is new SPARK.Containers.Functional.Infinite_Sequences (Integer);
   use LLists;

   function Model (L : access constant List) return Sequence is
     (if L = null then Empty_Sequence
      else Add (Model (L.Next), Position => 1, New_Item => L.Value))
   with
      Subprogram_Variant => (Structural => L);

   procedure Reverse_List (L : in out List_Acc)
   with
     Annotate => (GNATprove, Always_Return);
--     Post =>

end Lists;
