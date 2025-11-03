Questão 1

A segunda ocorrência de P (em {P X-1}) é um identificador livre no escopo do corpo. A declaração proc {P X} ... end liga P ao escopo externo, onde o procedimento é definido. Como P é usado no corpo mas não é declarado lá, ele é livre nesse contexto e refere-se ao P externo, permitindo a recursão.

Questão 2

Adicionar N -> 3 é necessário devido ao escopo lexical (estático). MulByN é um closure que captura o ambiente onde foi definido, incluindo o binding para seu identificador livre N. O N no ambiente da chamada é irrelevante; o procedimento usa o N do seu ambiente de definição (o "ambiente contextual"). Mesmo que N não exista na chamada ou tenha um valor diferente (ex: N=100), o procedimento usará confiavelmente o N=3 que capturou.

Questão 4

(a) O if pode ser definido com case tratando o booleano como padrão: if C then S1 else S2 end é equivalente a case C of true then S1 [] false then S2 end.

(b) Inversamente, case pode ser definido com ifs encadeados que testam a estrutura do valor. case X of label1(feat:V1) then S1 [] label2 then S2 else SE end seria como:

if {Label X} == label1 andthen {HasFeature X feat} then 
   local V1 = X.feat in S1 end 
else 
   if {Label X} == label2 then 
      S2 
   else 
      SE 
   end 
end


usando Label, HasFeature e . para inspecionar X.

Questão 5

As predições seguem a ordem das cláusulas case: {Test [b c a]} e {Test [c a b]} correspondem à cláusula 4 (Y|Z). {Test f(b(3))}, {Test f(a(3))} e {Test f(d)} correspondem à cláusula 5 (f(Y)), falhando a cláusula 2 (f(a)) por ser mais específica. {Test f(a)} acerta a cláusula 2. {Test [a b c]} e {Test a|a} correspondem à primeira cláusula (a|Z) por terem cabeça a. Finalmente, {Test ´|´(a b c)} não é uma lista, mas um record ´|´ com aridade 3, falhando todos os padrões e caindo no else (resultado case(6)).

Questão 7

O Browse exibirá [4 5] devido ao escopo lexical. {SpecialMax 3 Max3} cria um closure ligado a Max3 que captura Value=3. {SpecialMax 5 Max5} cria outro closure, ligado a Max5, que captura Value=5

Questão 8

(a) Sim, {AndThen fun {$} E1 end fun {$} E2 end} replica E1 andthen E2. Como BP1 e BP2 são procedimentos, BP2 (contendo E2) só é executado se BP1 (avaliando E1) retornar true. Se BP1 retornar false, BP2 não é chamado. 

(b) fun {OrElse BP1 BP2} if {BP1} then true else {BP2} end end. De forma análoga, BP1 (com E1) é sempre avaliado. Se retornar true, o resultado é true e BP2 (com E2) não é avaliado. Se BP1 retornar false, BP2 é chamado e seu resultado é retornado.

Questão 9

(a) Sum2 é uma recursão em cauda porque sua chamada recursiva é a operação final no kernel. Sum1 não é, pois tem outra operação após a chamada recursiva. 

(b) {Sum1 10} faz a pilha crescer linearmente para gerenciar operações pendentes. {Sum2 10 0} usa otimização de recursãode cauda e reutiliza o frame da pilha, ou seja, a pilha cresce em (O(1)). (c) Portanto, {Sum1 100000000} falhará com stack overflow, enquanto {Sum2 100000000 0} funcionará.

Questão 10

proc {SMerge Xs Ys Out}
   local T in
      T = '#'(Xs Ys)
      
      % case T of nil#Ys
      if T.1 == nil then
         Out = T.2
      else
         % case T of Xs#nil
         if T.2 == nil then
            Out = T.1
         else
            % case T of (X|Xr)#(Y|Yr)
            if {Label T.1} == '|' andthen {Label T.2} == '|' then
               local X Xr Y Yr C in
                  X = T.1.1
                  Xr = T.1.2
                  Y = T.2.1
                  Yr = T.2.2
                  
                  C = (X =< Y) % C é 'true' ou 'false'
                  
                  if C then
                     local Res in
                        Out = '|'(X Res)
                        {SMerge Xr Ys Res}
                     end
                  else
                     local Res in
                        Out = '|'(Y Res)
                        {SMerge Xs Yr Res}
                     end
                  end
            else
               % Padrão não corresponde - falha
               skip
            end
         end
      end
   end
end


Questão 11

{IsOdd N} e {IsEven N} executam com otimização de recursão na cauda. Na kernel langguage, o {IsOdd X-1} (em IsEven) e {IsEven X-1} (em IsOdd) são ambas últimas chamadas e, por isso a stack é reutilizada, em vez de empilhar frames (IsOdd sobre IsEven). Portanto, a execução alterna entre os dois, reutilizando o mesmo espaço na pilha.