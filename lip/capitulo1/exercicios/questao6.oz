% 6. Higher-order programming. Section 1.9 explains how to use higher-order pro-
% gramming to calculate variations on Pascal’s triangle. The purpose of this exercise
% is to explore these variations.

declare fun {ShiftLeft L}
    case L of H|T then
        H|{ShiftLeft T}
    else [0] end
end

declare fun {ShiftRight L} 0|L end

declare fun {OpList Op L1 L2}
    case L1 of H1|T1 then
        case L2 of H2|T2 then
            {Op H1 H2}|{OpList Op T1 T2}
        end
    else nil end
end

declare fun {GenericPascal Op N}
    if N==1 then [1]
    else L in
        L={GenericPascal Op N-1}
        {OpList Op {ShiftLeft L} {ShiftRight L}}
    end
end

declare fun {Add X Y} X+Y end
% fun {FastPascal N} {GenericPascal Add N} end
% fun {Xor X Y} if X==Y then 0 else 1 end end

% (a) Calculate individual rows using subtraction, multiplication, and other
% operations. Why does using multiplication give a triangle with all zeros? Try
% the following kind of multiplication instead:
declare fun {Mul1 X Y} (X+1)*(Y+1) end
% What does the 10th row look like when calculated with Mul1?
%
% Resposta:
% -- A múltiplicação comum gera uma triangulo com todos os zeros porque
% -- qualquer número multiplicado por zero é zero. E o algoritmo se inicia
% -- com zeros nas bordas. Já a multiplicação Mul1 evita isso.

% {Browse {GenericPascal Mul1 10}}
% Resultado de Mul1 10:
% [10|
% 6235300|
% 160344312228246705825060|
% 49116946500844767398714340184254871599279813644844|
% 505756353132539355991535788904396967700352784465846135098293311191732044|
% 505756353132539355991535788904396967700352784465846135098293311191732044|
% 49116946500844767398714340184254871599279813644844|
% 160344312228246705825060|
% 6235300| 
% 10]

% (b) The following loop instruction will calculate and display 10 rows at a time:
for I in 1..10 do {Browse {GenericPascal Add I}} end
% Resultado:
% [1]
% [1 1]
% [1 2 1]
% [1 3 3 1]
% [1 4 6 4 1]
% [1 5 10 10 5 1]
% [1 6 15 20 15 6 1]
% [1 7 21 35 35 21 7 1]
% 1|8|28|56|70|56|28|8|1|nil
% 1|9|36|84|126|126|84|36|9|...|...
{Browse '---'}
% With Mul1:
for I in 1..10 do {Browse {GenericPascal Mul1 I}} end
% Resultado:
% [1]
% [2 2]
% [3 9 3]
% [4 40 40 4]
% [5 205 1681 205 5]
% [6 1236 346492 346492 1236 6]
% [7 8659 428611841 120057399049 428611841 8659 7]
% [8 69280 3711778551720 51458022952549550100 51458022952549550100 3711778551720 69280 8]
% [9|623529|257155729841782601|191000785909240345378379909273821|2647928126185116317725365841617509110201|191000785909240345378379909273821|257155729841782601|623529|9|nil]
% [10|6235300|160344312228246705825060|49116946500844767398714340184254871599279813644844|505756353132539355991535788904396967700352784465846135098293311191732044|505756353132539355991535788904396967700352784465846135098293311191732044|49116946500844767398714340184254871599279813644844|160344312228246705825060|6235300|...|...]