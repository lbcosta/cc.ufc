% 9. Memory store. This exercise investigates another way of introducing state: a
% memory store. The memory store can be used to make an improved version of
% FastPascal that remembers previously calculated rows.
%
% (a) A memory store is similar to the memory of a computer. It has a series
% of memory cells, numbered from 1 up to the maximum used so far. There are
% four functions on memory stores: NewStore creates a new store, Put puts a
% new value in a memory cell, Get gets the current value stored in a memory
% cell, and Size gives the highest-numbered cell used so far. For example:
declare
S={NewStore}
{Put S 2 [22 33]}
{Browse {Get S 2}}
{Browse {Size S}}
% This stores [22 33] in memory cell 2, displays [22 33], and then displays 2.
% Load into the Mozart system the memory store as deﬁned in the supplements
% ﬁle on the book’s Web site. Then use the interactive interface to understand
% how the store works.
%
% Resposta:
% Foi feito colocando o código de em "https://webperso.info.ucl.ac.be/~pvr/ds/booksuppl.oz"
% no arquivo ~/.ozrc
%
% (FastPascal apenas como referencia)
declare fun {ShiftLeft L}
    case L of H|T then
        H|{ShiftLeft T}
    else [0] end
end

declare fun {ShiftRight L} 0|L end

declare fun {AddList L1 L2}
    case L1 of H1|T1 then
        case L2 of H2|T2 then
            H1+H2|{AddList T1 T2}
        end
    else nil end
end

declare fun {FastPascal N}
    if N==1 then [1]
    else L in
        L={FastPascal N-1}
        {AddList {ShiftLeft L} {ShiftRight L}}
    end
end

{Browse {FastPascal 10}}
% (b) Now use the memory store to write an improved version of FastPascal,
% called FasterPascal, that remembers previously calculated rows. If a call asks
% for one of these rows, then the function can return it directly without having
% to recalculate it. This technique is sometimes called memoization since the
% function makes a “memo” of its previous work. This improves its performance.
% Here’s how it works:
% 1. First make a store S available to FasterPascal.
% 2. For the call {FasterPascal N}, let m be the number of rows stored in
%    S, i.e., rows 1 up to m are in S.
% 3. If n > m, then compute rows m + 1 up to n and store them in S.
% 4. Return the nth row by looking it up in S.
% Viewed from the outside, FasterPascal behaves identically to FastPascal
% except that it is faster.
%
% Resposta:
declare S = {NewStore}
{Put S 1 [1]}
declare fun {FasterPascal N}
    M = {Size S} in
    if N > M then
        for I in M+1..N do
            Lprev = {Get S I-1}
            Lnew = {AddList {ShiftLeft Lprev} {ShiftRight Lprev}}
        in
            {Put S I Lnew}
        end
    end
    {Get S N}
end
{Browse {FasterPascal 10}}
%