package body Abstract_Syntax_Trees is

   procedure Lemma_Eval_Unit_Left (Op : Oper; Right : Expr_Acc; Cur : Env) is null;
   procedure Lemma_Eval_Unit_Right (Op : Oper; Left : Expr_Acc; Cur : Env) is null;

   procedure Lemma_Optimize_Correct (E : Expr; Cur : Env) is
      Res : constant Expr := Optimize (E);
   begin
      if E.Kind = Node then
         Lemma_Optimize_Correct (E.Left.all, Cur);
         pragma Annotate (GNATprove, False_Positive, "terminating annotation",
                          "That version of SPARK does not allow structural variant");
         Lemma_Optimize_Correct (E.Right.all, Cur);
         pragma Annotate (GNATprove, False_Positive, "terminating annotation",
                          "That version of SPARK does not allow structural variant");

         case E.Op is
            when Add =>
               pragma Assert (Eval (E, Cur) = Eval (Res, Cur));
            when Mul =>
               pragma Assert (Eval (E, Cur) = Eval (Res, Cur));
         end case;
      end if;
   end Lemma_Optimize_Correct;

end Abstract_Syntax_Trees;
