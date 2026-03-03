# Ich brauche eine Funktion die mir alle Paare von collect(1:n) zurückgibt, wobei die Zahlen in Mengen 
# der größe floor(Int64, n/2) aufgeteilt werden und innerhalb jeder dieser Mengen jede 
# Zahl nur maximal einmal vorkommen soll, also beispielsweise für n = 4
# [1, 2]
# [3, 4];
# [2, 4]
# [1, 3];
# [2, 3]
# [1, 4]
# Das Kopfgeld ist ein Döner
#
# Pairs gibt alle diese Paare zurück aber natürlich unsortiert, meine bisherigen Lösungsversuche haben nur bis 10 ohne 7 und 9 funktioniert.
# Theoretisch kann ich das Problem für gerade n lösen aber n = 10 dauert schon 5 minuten und 12 1 1/2 Stunden da ich n! permutationen betrachte. 
# Ich bin kurz davor ein Rekursives Monster fertigzustellen aber ich glaube nicht, dass ich damit Erfolg haben werde :D

function remove!(A, item)
    deleteat!(A, findall(x -> x==item, A))
end

function Pairs(n)
    M1 = collect(Iterators.product(1:n,1:n))
    for i in axes(M1,1), j in 1:i
        M1[i,j] = (0,0) 
    end
    M2 = M1[1,:]
    s = size(M1,1)
    for i in 2:s
        M2 = cat(M2, M1[i,:], dims=1)
    end
    for i in 1:length(n)
        remove!(M2, (0,0))
    end
    return M2
end

# Translation:
#
# I need a function that returns all pairs of collect(1:n), where the numbers are divided into sets
# of size floor(Int64, n/2) and within each of these sets every number may only appear at most once,
# for example for n = 4:
# [1, 2]
# [3, 4];
# [2, 4]
# [1, 3];
# [2, 3]
# [1, 4]
#
# The bounty is a Döner kebab.
#
# Pairs returns all these pairs but unsorted of course, my previous attempts only worked up to 10 excluding 7 and 9.
# Theoretically I can solve the problem for even n but n = 10 already takes 5 minutes and 12 takes 1.5 hours since I consider n! permutations.
# I'm close to finishing a recursive monster but I don't think I'll succeed with it :D