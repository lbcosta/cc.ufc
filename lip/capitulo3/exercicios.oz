% Questão 1
% A definição não funciona por conta da tipagem dos números Reais. Em Oz 0.0 != 0;

% Questão 2
declare
fun {CubeRoot X}
   X_Float = {Int.toFloat X}
   e = 0.00001
   fun {IsGoodEnough G1 G2}
      {Float.abs (G1 - G2)} < e
   end
   fun {Improve G}
      (X_Float / (G * G) + 2.0 * G) / 3.0
   end
   fun {CubeRootIter G}
      NewG = {Improve G}
   in
      if {IsGoodEnough G NewG} then
         NewG
      else
         {CubeRootIter NewG}
      end
   end
in
   {CubeRootIter 1.0}
end

% Questão 3
declare
fun {HalfInterval F A B}
   e = 0.00001
   A_F = {Int.toFloat A}
   B_F = {Int.toFloat B}

   fun {Search A B}
      M = (A + B) / 2.0
   in
      if (B - A) < e then
         M
      else
         FM = {F M}
         if FM > 0.0 then
            {Search A M}
         else
            {Search M B}
         end
      end
   end
in
   if {F A_F} < 0.0 andthen {F B_F} > 0.0 then
      {Search A_F B_F}
   else
      raise error(halfInterval(invalid_range)) end
   end
end

% Questão 4
declare
fun {Fact N}
   fun {FactIter I Acc}
      if I == 0 then
         Acc
      else
         {FactIter I-1 I*Acc}
      end
   end

in
   {FactIter N 1}
end

% Questão 5
declare
fun {SumList L}
   fun {SumListIter Lr Acc}
      case Lr of
         nil then Acc
      [] H|T then {SumListIter T H+Acc}
      end
   end
in
   {SumListIter L 0}
end

% Questão 7
% Colocar a recursão no segundo argumento irá fazer com que não haja
% a diminuição do problema, causando uma recursão infinita.

% Questão 8
declare
fun {IterCons L B}
   case L of
      nil then B
   [] H|T then
      {IterCons T H|B}
   end
end
fun {IterReverse L}
   {IterCons L nil}
end
fun {IterAppend Xs Ys}
   RevXs = {IterReverse Xs}
in
   {IterCons RevXs Ys}
end

% Questão 10
% O operador "\=" é um statement e não uma expressão, portanto não pode ser
% usado em definições de funções, pois estas esperam uma expressão como retorno.

% Questão 11
% Uma lista de diferença não é um valor, mas sim uma estrutura de dados incompleta, representada por um par: Lista#Cauda,
% onde Cauda é uma variável não ligada (um "buraco"). Por isso, ao tentar liga-la mais de uma vez, há uma falha na unificação.

% Questão 14
% item a)
% A fila fica num estado inválido: O contador é negativo, e a lista de diferença fica inconsistente
% item b)
% "==" compara duas variáveis não ligadas. Isso faria o programa parar a execução para esperar que as variáveis fossem ligadas.

% Questão 15
proc {Partition L X ?L1 ?L2}
   case L of
      nil then
         L1 = nil
         L2 = nil
   [] H|T then
      L1T L2T
   in
      {Partition T X L1T L2T}
      if H < X then
         L1 = H|L1T
         L2 = L2T
      else
         L1 = L1T
         L2 = H|L2T
      end
   end
end
fun {QSortD L T}
   case L of
      nil then
   [] X|R then
      L1 L2 S2H
   in
      {Partition R X L1 L2}
      S2H = {QSortD L2 T}
      {QSortD L1 X|S2H}
   end
end
fun {QSort L}
   {QSortD L nil}
end

% Questão 16
fun {IterCons L_ToAdd L_Base}
   case L_ToAdd of
      nil then L_Base
   [] H|T then
      {IterCons T H|L_Base}
   end
end
fun {IterReverse L}
   {IterCons L nil}
end
fun {ConvolveIter L1 L2_Rev Acc}
   case L1 of
      nil then Acc
   [] H1|T1 then
      case L2_Rev of
         nil then Acc
      [] H2|T2 then
         {ConvolveIter T1 T2 (H1#H2)|Acc}
      end
   end
end
fun {Convolve L1 L2}
   L2_Rev = {IterReverse L2}
   Res_Rev = {ConvolveIter L1 L2_Rev nil}
in
   {IterReverse Res_Rev}
end