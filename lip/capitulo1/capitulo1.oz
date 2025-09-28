% % 1.1 A calculator
% % using the system to do calculations

% % {} are for procedure or function calls
% % Browse is a procedure with one argument
% {Browse 9999*9999}

% % declaring a variable
% declare 
% V = 9999*9999
% {Browse V*V}

declare
fun {Fact N}
    if N==0 then 1 else N*{Fact N-1} end
end
% {Browse {Fact 10}}
declare
fun {Comb N K}
    {Fact N} div ({Fact K}*{Fact N-K})
end
{Browse {Comb 10 3}}

{Browse [5 6 7 8]}

declare
H=5
T=[6 7 8]
{Browse H|T}

declare
L=[5 6 7 8]
{Browse L.1}
{Browse L.1.2}

declare
L=[5 6 7 8]
case L of H|T then {Browse H} {Browse T} end

% LAZY EVALUATION
declare
fun lazy {Ints N}
    N|{Ints N+1}
end
declare L={Ints 0}
{Browse L}

{Browse L.1}

case L of A|B|C|_ then {Browse A+B+C} end