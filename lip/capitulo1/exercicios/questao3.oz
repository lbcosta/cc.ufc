% Questão 3 
% Pascal(N,K) = C(N,K) (de N, escolha K)
% Base: Se K==0 ou K==N, a função retorna 1, como em C(N,0)=1 e C(N,N)=1.
% Passo: Para 0 < K < N, a função retorna {Pascal(N-1,K-1)} + {Pascal(N-1,K)}.
% Hipótese de indução:
%   {Pascal(N-1,K-1)} = C(N-1,K-1) e {Pascal(N-1,K)} = C(N-1,K).
% Logo, o resultado é C(N-1,K-1) + C(N-1,K) = C(N,K) (pela Regra de Pascal).
% Terminação: a cada chamada recursiva, o primeiro argumento N diminui em 1
% e eventualmente atinge um caso base (K==0 ou K==N). Portanto, o algoritmo termina.