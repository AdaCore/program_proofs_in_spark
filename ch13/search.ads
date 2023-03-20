package Search is

   type Value is new Natural;

   subtype Index is Natural range 0 .. Natural'Last-1;
   type Arr is array (Index range <>) of Value;

   subtype Row is Natural;
   subtype Col is Natural;
   type Matrix is array (Row range <>, Col range <>) of Value;

   procedure Slope_Search
     (A   : Matrix;
      Key : Value;
      M   : out Row;
      N   : out Col)
   with
     Pre =>
       (for all I in A'Range(1) =>
          (for all J1 in A'Range(2) => (for all J2 in A'Range(2) =>
             (if J1 <= J2 then A(I,J1) <= A(I,J2)))))
         and then
       (for all I1 in A'Range(1) => (for all I2 in A'Range(1) =>
          (for all J in A'Range(2) =>
             (if I1 <= I2 then A(I1,J) <= A(I2,J)))))
         and then
       (for some I in A'Range(1) => (for some J in A'Range(2) =>
           A(I,J) = Key)),
     Post =>
       M in A'Range(1) and then N in A'Range(2) and then A(M,N) = Key;

   function Dist (X, Y : Value) return Value is (abs (X - Y));

   function Is_Sorted (A : Arr) return Boolean is
     (for all I1 in A'Range => (for all I2 in A'Range =>
        (if I1 <= I2 then  A(I1) <= A(I2))));

   function Canyon_Search (A, B : Arr) return Value
   with
     Pre => A'Length > 0
       and then B'Length > 0
       and then Is_Sorted (A)
       and then Is_Sorted (B),
     Post =>
       (for some I in A'Range => (for some J in B'Range =>
          Canyon_Search'Result = Dist (A(I), B(J))))
         and then
       (for all I in A'Range => (for all J in B'Range =>
          Canyon_Search'Result <= Dist (A(I), B(J))));

end Search;
