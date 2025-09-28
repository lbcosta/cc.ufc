% Questão 1
% item a
declare
Pow2=2*2
Pow4=Pow2*Pow2
Pow8=Pow4*Pow4
Pow16=Pow8*Pow8
Pow32=Pow16*Pow16
Pow64=Pow32*Pow32
Pow100=Pow64*Pow32*Pow4
{Browse Pow100}

% item b
declare
F10=1*2*3*4*5*6*7*8*9*10
F20=F10*11*12*13*14*15*16*17*18*19*20
F30=F20*21*22*23*24*25*26*27*28*29*30
F40=F30*31*32*33*34*35*36*37*38*39*40
F50=F40*41*42*43*44*45*46*47*48*49*50
F60=F50*51*52*53*54*55*56*57*58*59*60
F70=F60*61*62*63*64*65*66*67*68*69*70
F80=F70*71*72*73*74*75*76*77*78*79*80
F90=F80*81*82*83*84*85*86*87*88*89*90
F100=F90*91*92*93*94*95*96*97*98*99*100
{Browse F100}

% Questão 2
% item a
declare
fun {ProductDescending From To}
	if From<To then 1
	elseif From==To then From
	else From*{ProductDescending From-1 To}
	end
end
fun {CombNumeratorDenominator N K}
	if K==0 then 1
	else
		local Numerator Denominator in
			Numerator={ProductDescending N N-K+1}
			Denominator={ProductDescending K 1}
			Numerator div Denominator
		end
	end
end
{Browse {CombNumeratorDenominator 10 3}}
{Browse {CombNumeratorDenominator 10 0}}

% item b
declare
fun {CombWithSymmetry N K}
	local Half ReducedK in
		Half=N div 2
		ReducedK=if K>Half then N-K else K end
		{CombNumeratorDenominator N ReducedK}
	end
end
{Browse {CombWithSymmetry 10 3}}
{Browse {CombWithSymmetry 10 7}}

% Questão 3
% todo

% Questão 4
% A sessão 1.7 afirma que algoritmos com complexidade O(2^n) são impraticáveis
% para n grandes, enquanto algoritmos com complexidade O(n^2) são práticos
% mesmo para n grandes. Falando de uma maneira mais geral, algoritmos em que
% a curva de complexidade cresce mais rapidamente de acordo com n são menos
% práticos. Ou seja, um algoritmo com complexidade O(n^3) é menos prático que
% um algoritmo com complexidade O(n^2), mas ainda é mais prático que um
% algoritmo com complexidade O(2^n).

% Questão 5
% O programa tentará calcular a soma de todos os elementos da lista infinita
% gerada pela função Ints. Como a lista é infinita, a soma nunca terminará
% e o programa irá ser cancelado no momento em que o limite da memória heap
% for atingido.

% Questão 6



