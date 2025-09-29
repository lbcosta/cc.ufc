% Questão 10
declare
proc {TwoIncrementsAndShow}
    local C Done1 Done2 in
        C = {NewCell 0}        
        thread
            {Delay 20}
            C := 1
            Done1 = unit
        end
        thread
            {Delay 10}
            C := 2
            Done2 = unit
        end
        {Wait Done1}
        {Wait Done2}
        {Browse @C}
    end
end
{TwoIncrementsAndShow}

% (a) Try executing this example several times. What results do you get? Do
%     you ever get the result 1? Why could this be?
% Resposta: Ao executar repetidas vezes, os resultados possíveis são 1 ou 2.
% (b) Modify the example by adding calls to Delay in each thread. This changes
%     the thread interleaving without changing what calculations the thread does.
%     Can you devise a scheme that always results in 1?
% Resposta: Adicionando Delay maior na primeira thread, o resultado sempre é 1.
