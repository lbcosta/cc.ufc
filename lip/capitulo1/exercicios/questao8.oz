% 8. Explicit state and functions. This exercise investigates how to use cells together
% with functions. Let us deﬁne a function {Accumulate N} that accumulates all its
% inputs, i.e., it adds together all the arguments of all calls. Here is an example:
{Browse {Accumulate 5}}
{Browse {Accumulate 100}}
{Browse {Accumulate 45}}
% This should display 5, 105, and 150, assuming that the accumulator contains zero
% at the start. Here is a wrong way to write Accumulate:
declare
fun {Accumulate N}
Acc in
    Acc={NewCell 0}
    Acc:=@Acc+N
    @Acc
end
%
% Resposta:
% Programa corrigido:
declare Acc
Acc={NewCell 0}
declare
fun {Accumulate N}
    Acc:=@Acc+N
    @Acc
end
%
% Explicação:
%   No código errado, a célula Acc é criada toda vez que a função Accumulate é chamada,
% o que faz com que o valor acumulado seja sempre reiniciado para 0.
%   No código corrigido, a célula Acc é criada uma única vez fora da função Accumulate,
% permitindo que o valor acumulado seja mantido entre as chamadas da função.
