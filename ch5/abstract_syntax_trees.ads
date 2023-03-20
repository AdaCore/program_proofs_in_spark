-- 5.8 Example: Working on Abstract Syntax Trees

with SPARK.Big_Integers; use SPARK.Big_Integers;
with SPARK.Containers.Functional.Maps; use SPARK.Containers;

package Abstract_Syntax_Trees is

   type Oper is (Add, Mul);

   type Expr_Kind is (Const, Var, Node);
   type String_Acc is not null access constant String;
   type Expr;
   type Expr_Acc is not null access constant Expr;
   type Expr (Kind : Expr_Kind) is record
      case Kind is
         when Const =>
            Value : Big_Natural;
         when Var   =>
            Name  : String_Acc;
         when Node  =>
            Op    : Oper;
            -- It is possible to use a discriminant record with an array
            -- component for encoding a list of arguments, but this is more
            -- difficult to prove.
            Left  : Expr_Acc;
            Right : Expr_Acc;
      end case;
   end record;

   function New_Expr (E : Expr) return Expr_Acc is
     (new Expr'(E))
   with
     Annotate => (GNATprove, Intentional, "memory leak",
                  "allocation of access-to-constant is not reclaimed");

   function New_Const (Value : Big_Natural) return Expr_Acc is
     (New_Expr (Expr'(Kind => Const, Value => Value)));

   package Environments is new Functional.Maps (String, Big_Natural);
   subtype Env is Environments.Map;

   function Unit (Op : Oper) return Big_Natural is
      (case Op is when Add => Big_Natural'(0), when Mul => 1);

   function Eval (E : Expr; Cur : Env) return Big_Natural is
     (case E.Kind is
         when Const => E.Value,
         when Var   =>
           (if Cur.Has_Key (E.Name.all) then Cur.Get (E.Name.all) else 0),
         when Node  =>
           (declare
              V0 : constant Big_Natural := Eval (E.Left.all, Cur);
              V1 : constant Big_Natural := Eval (E.Right.all, Cur);
            begin
              (case E.Op is
                  when Add => V0 + V1,
                  when Mul => V0 * V1)))
   with
     Subprogram_Variant => (Structural => E);

   procedure Lemma_Eval_Unit_Left (Op : Oper; Right : Expr_Acc; Cur : Env)
   with
     Ghost,
     Annotate => (GNATprove, Automatic_Instantiation),
     Post => Eval (Expr'(Kind  => Node,
                         Op    => Op,
                         Left  => New_Const (Unit (Op)),
                         Right => Right),
                   Cur)
           = Eval (Right.all, Cur);

   procedure Lemma_Eval_Unit_Right (Op : Oper; Left : Expr_Acc; Cur : Env)
   with
     Ghost,
     Annotate => (GNATprove, Automatic_Instantiation),
     Post => Eval (Expr'(Kind  => Node,
                         Op    => Op,
                         Left  => Left,
                         Right => New_Const (Unit (Op))),
                   Cur)
           = Eval (Left.all, Cur);

   function Optimize (E : Expr) return Expr
   with
     Subprogram_Variant => (Structural => E);

   function Optimize (E : Expr) return Expr is
     (case E.Kind is
         when Const | Var => E,
         when Node =>
           (declare
              U  : constant Big_Natural := Unit (E.Op);
              E0 : constant Expr := Optimize (E.Left.all);
              E1 : constant Expr := Optimize (E.Right.all);
            begin
              (if E0.Kind = Const and then E0.Value = U then E1
               elsif E1.Kind = Const and then E1.Value = U then E0
               else Expr'(Kind  => Node,
                          Op    => E.Op,
                          Left  => New_Expr (E0),
                          Right => New_Expr (E1)))));

   procedure Lemma_Optimize_Correct (E : Expr; Cur : Env)
   with
     Ghost,
     Subprogram_Variant => (Structural => E),
     Post => Eval (Optimize (E), Cur) = Eval (E, Cur);

end Abstract_Syntax_Trees;
