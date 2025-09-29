% 7. Explicit state. This exercise compares variables and cells. We give two code
% fragments. The ﬁrst uses variables:
local X in
    X=23
    local X in
        X=44
    end
    {Browse X}
end
% The second uses a cell:
local X in
    X={NewCell 23}
    X:=44
    {Browse @X}
end
% In the ﬁrst, the identiﬁer X refers to two diﬀerent variables. In the second, X refers
% to a cell. What does Browse display in each fragment? Explain.
%
% Resposta:
%   No primeiro fragmento, o Browse exibe 23. Isso ocorre porque a variável X
% dentro do escopo interno é uma nova variável que não afeta a variável X do
% escopo externo. Portanto, quando o Browse é chamado, ele exibe o valor da
% variável X do escopo externo, que é 23.
%   No segundo fragmento, o Browse exibe 44. Isso ocorre porque X é uma célula.
% Ou seja, é um identificador que aponta para uma variável valor em sigma. Esta
% variável, por sua vez, aponta para a célula em mi. Na qual aponta, inicialmente, para
% o valor 23. Quando fazemos a atribuição X:=44, estamos alterando o valor
% armazenado na célula (em mi) para 44, enquanto o identificador X continua
% apontando para a mesma variável valor em sigma.