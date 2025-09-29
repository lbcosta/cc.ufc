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