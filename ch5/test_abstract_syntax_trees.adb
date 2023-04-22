with Ada.Numerics.Big_Numbers.Big_Integers; use Ada.Numerics.Big_Numbers.Big_Integers;
with Ada.Text_IO; use Ada.Text_IO;
with Abstract_Syntax_Trees; use Abstract_Syntax_Trees;

procedure Test_Abstract_Syntax_Trees is
   Cur_Env : Env;
   Var_X : constant String_Acc := new String'("X");
   Simp : constant Expr := Expr'(Kind => Var, Name => Var_X);
   Comp : constant Expr :=
     Expr'(Kind => Node, Op => Mul,
           Left => New_Expr (Expr'(Kind => Node, Op => Add,
                                   Left => New_Expr (Simp),
                                   Right => New_Const (0))),
           Right => New_Const (1));
   Answer : Big_Integer := 42;
   Val : Big_Integer;
begin
   Cur_Env := Cur_Env.Add ("X", Answer);

   Val := Eval (Comp, Cur_Env);

   if Val = Answer then
      Put_Line ("correct answer");
   else
      Put_Line ("incorrect answer:" & Val'Img);
      Put_Line ("expected answer:" & Answer'Img);
   end if;

   Val := Eval (Optimize (Comp), Cur_Env);

   if Val = Answer then
      Put_Line ("correct answer");
   else
      Put_Line ("incorrect answer:" & Val'Img);
      Put_Line ("expected answer:" & Answer'Img);
   end if;

   if Optimize (Comp) = Simp then
      Put_Line ("correct optimization");
   else
      Put_Line ("incorrect optimization");
   end if;
end Test_Abstract_Syntax_Trees;
