using Random, Combinatorics
using Base.Iterators
include("Visualization.jl") 

# Scoring constants: [normal_win, overtime, deathcup, deathcup_overtime]
# Row 1 = winner points, Row 2 = loser points
const POINTS_TABLE = [[3, 2, 4, 3],
                      [0, 1, 0, 1]]

# Teams #

function random_teams(n)
    return [Team(randstring(2), randstring(3), randstring(3)) for i in 1:n]
end

function alphabetical_teams(n)
    if n > 29 
        throw(ErrorException("a maximum of 29 teams is supported"))
    end
    ABC = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","Ä","Ö","Ü"]
    return [Team(ABC[i], randstring(3), randstring(3)) for i in 1:n]
end


# Match logic #

function random_matches(n)
    Matches = Vector{Match}(undef, n)
    
    for i in 1:length(Matches)
        
        Matches[i] = Match(random_teams(1)[1], random_teams(1)[1], rand(1:19), rand(1:19))
    end

    return Matches
end

function winner(match::Match)
    
    # deathcups 
    if match.score_1 < 0 
        return match.team_1
    elseif match.score_2 < 0
        return match.team_2
    end

    # normal win
    if match.score_1 > match.score_2
        return match.team_1
    elseif match.score_2 > match.score_1
        return match.team_2
    end

    # invalid argument
    if match.score_1 == match.score_2 # needs to be more general
        throw(ArgumentError)
    end
end

function loser(match::Match)
    
    # deathcups 
    if match.score_1 < 0 
        return match.team_2
    elseif match.score_2 < 0
        return match.team_1
    end

    # normal win
    if match.score_1 > match.score_2
        return match.team_2
    elseif match.score_2 > match.score_1
        return match.team_1
    end

    # invalid argument
    if match.score_1 == match.score_2 # needs to be more general
        throw(ArgumentError)
    end
end

function points(match::Match)

    # deathcup 
    if match.score_1 == -1 
        return POINTS_TABLE[1][3], POINTS_TABLE[2][3]
    elseif match.score_2 == -1 
        return POINTS_TABLE[2][3], POINTS_TABLE[1][3]
    
    # deathcup overtime
    elseif match.score_1 == -2
        return POINTS_TABLE[1][4], POINTS_TABLE[2][4]
    elseif match.score_2 == -2 
        return POINTS_TABLE[2][4], POINTS_TABLE[1][4]

    # normal win
    elseif match.score_1 == 10 &&  match.score_2 < 10 
        return POINTS_TABLE[1][1], POINTS_TABLE[2][1]
    elseif match.score_2 == 10 &&  match.score_1 < 10
        return POINTS_TABLE[2][1], POINTS_TABLE[1][1]
    
    # overtime   
    elseif match.score_1 >= 10 && match.score_1 > match.score_2 
        return POINTS_TABLE[1][2], POINTS_TABLE[2][2]
    elseif match.score_2 >= 10 && match.score_2 > match.score_1
        return POINTS_TABLE[2][2], POINTS_TABLE[1][2]
    else 
        throw(ArgumentError)
    end
end


# Group generation #

function generate_groups(Teams::Vector{Team}, groupsize::Integer) 

    if length(Teams) % groupsize > 0 
        return throw(ErrorException("number of teams does not match group size"))
    end
    
    # Build groups
    Groups = [Teams[i:i+groupsize-1] for i in 1:groupsize:length(Teams)] 
    # Find pairings

    Pairs_help = generate_pairings(groupsize)
    Pairs = cat( [Pairs_help[i] for i in eachindex(Pairs_help)]..., dims=1)
    
    # Assign all group-stage matches
    Matches = Vector{Vector{Team}}(undef, sum(1:groupsize-1)*length(Groups) ) 

    m = 1
    n = 1
    i = 0
    while i < sum(1:groupsize-1)*length(Groups) 

        if i % length(Groups) == 0 && i != 0
                n += 1
        end

        Matches[i+1] = [Groups[m][Pairs[n][1]], Groups[m][Pairs[n][2]]] 

        m = mod(m, length(Groups)) + 1 
        i += 1
    end
        
    return Groups, Matches
end

function create_schedule(Groups::Vector{Vector{Team}}, Matches::Vector{Vector{Team}}, ntables::Integer, groupsize::Integer)

    # Sort all matches by group
    Matches_copy = copy(Matches)
    group_matches = Vector{Vector}()
    npairs = sum(1:groupsize-1)
    for i in 1:length(Groups)

        G = Vector{Vector{Team}}(undef, npairs) 
        for j in 1:npairs  
            # Search through all matches
            for k in eachindex(Matches_copy)
                if Matches_copy[k][1] in Groups[i] 
                    G[j] = Matches_copy[k]
                    Matches_copy[k] = random_teams(2) 
                    break
                end
            end
        end
        push!(group_matches, G)
    end
    

    nround = ceil(Int64, length(group_matches[1])*length(group_matches) / ntables ) # number of rounds 
    npergroup = floor(Int64, groupsize/2)                                          # matches per group per round
    group_stage = [[] for i in 1:nround]
    group_numbers = [[] for i in 1:nround]

    l = 1      # round
    m = 1      # group
    n = 1      # match within group
    sub_round_index = 1
    while l < nround + 1
        
        j = 1 # table

        while j < ntables + 1

            push!(group_stage[l], group_matches[m][n]) 
            push!(group_numbers[l], m)
            
            if n < npergroup * sub_round_index
                n += 1 
            elseif n == npergroup * sub_round_index
                n = 1 + npergroup * (sub_round_index - 1)
                m += 1
            end
            
            if m == length(group_matches) + 1 
                m = 1
                sub_round_index += 1
                n = 1 + npergroup * (sub_round_index - 1)
            end

            if n > length(group_matches[1]) break end

            j += 1
        end

        l += 1
    end
     
    return group_stage, group_numbers
end

# Pairing algorithm #
function generate_pairings(n::Int64)
    if n == 1 return nothing end
    if n == 2 return [Int8.((1,2))] end
    n_group = Int16(sum(1:n-1) / floor(Int16, n/2))

    N_pairs = collect( Iterators.product(Int8.(1:n), Int8.(1:n)) )
    for i in axes(N_pairs, 1), j in 1:i
        N_pairs[i,j] = (0,0) 
    end

    if isodd(n)
        VN_configs = initial_pair_configs(N_pairs, n) 
        i_con = 1
        VN_pairs = VN_configs[i_con] 

    else
        N_pairs = N_pairs[1:end-1, 2:end]

        # Pack N_pairs into nested vector, excluding (0,0) # 
        VN_pairs = [[Int16.((0,0)) for j in 1:i] for i in n-1:-1:1]
        for i in axes(N_pairs, 2)
            VN_pairs[i] = N_pairs[i, i:i+length(VN_pairs[i])-1] 
        end
    end

    # Index array # 
    pair_matrix = zeros(Int8, n_group, 2n-2) 

    # Initial condition # 
    for i in 1:length(VN_pairs[1])
        pair_matrix[i, 1:2] .= VN_pairs[1][i] 
    end

    # Compute relevant permutations # 
    Permutations = [collect(permutations( Int8.([k for k in 1:l]) )) for l in 1:n-2]  # permutations( Int8.([k for k in 1:l]) )   ### rest(iter, state) ###
    perm_indices   = [1 for i in 1:length(VN_pairs)]

    i = 2       
    while i < length(VN_pairs) + 1

        # Determine relevant indices #
        Ind = Int16.([])
        for j in 1:n_group
            if !(i in pair_matrix[j, 1:2(i-1)]) 
                push!(Ind, j)
            end
        end

        while perm_indices[i] < length(Permutations[length(Ind)]) + 1

            permute!(Ind, Permutations[length(Ind)][perm_indices[i]]) 
        
            # Fill with current permutation, pad remainder with (0,0)
            for (k,l) in enumerate(Ind) 
                if k > length(VN_pairs[i])
                    pair_matrix[l, 2i-1:2i] .= (0,0)
                else
                    pair_matrix[l, 2i-1:2i] .= VN_pairs[i][k] 
                end
            end
     
            # Check if a partial solution was found
            sol = true
            for k in 1:n, l in axes(N_pairs, 1)
                if length(findall(x -> x == k, pair_matrix[l, :])) > 1
                    sol = false 
                    break
                end
            end
            if sol
                break 
            end

            perm_indices[i] += 1 
            if perm_indices[i] == length(Permutations[length(Ind)]) + 1 && i == 2
                # Switch to next starting configuration
                i_con += 1
                VN_pairs = VN_configs[i_con]
            elseif perm_indices[i] == length(Permutations[length(Ind)]) + 1          
                # No solution found, backtrack
                perm_indices[i] = 1
                perm_indices[i-1] += 1
                pair_matrix[:,2(i-1)-1:end] .= 0
                i -= 2
                break 
            end

        end
        i += 1
    end

    return matrix_to_tuples(pair_matrix, n)
end

function matrix_to_tuples(pair_matrix::Matrix{Int8}, n::Int64)
    Pairs = Vector{Vector{Tuple{Int8, Int8}}}(undef, Int16(size(pair_matrix, 1))) 
    Pair = [Int8.((0,0)) for i in 1:size(pair_matrix, 2)] 
    for i in 1:length(Pairs)
        for j in 1:2:size(pair_matrix, 2)
            Pair[Int16((j+1)/2)] = (pair_matrix[i, j], pair_matrix[i, j+1])
        end
        Pairs[i] = remove!(unique(Pair), (0,0)) # Remove zeros
    end

    return Pairs
end

function initial_pair_configs(N_pairs, n)
    
    VN_configs = Vector{Matrix{Tuple{Int8, Int8}}}(undef, sum(1:n-1) - (n-1))
    V_pairs = Vector{Tuple{Int8, Int8}}(undef, sum(1:n-1) - (n-1))

    i = 1
    k = size(N_pairs,1)
    for m in 2:k, n in axes(N_pairs,2)
        if N_pairs[m,n] != (0,0)
            V_pairs[i] = N_pairs[m,n]
            i += 1
        end
    end

    for i in 1:length(V_pairs)
        VN_pairs = copy(N_pairs)
        for m in 1:size(N_pairs,1), n in 1:size(N_pairs,2)
            if VN_pairs[m,n] == V_pairs[i]
                VN_pairs[m,n] = (0,0)
                VN_pairs[1,1] = V_pairs[i]
                break
            end
        end
        VN_configs[i] = copy(VN_pairs)
    end

    VN_configs2 = [[] for i in 1:length(VN_configs)] 
    for j in 1:length(VN_configs)
        VN_configs2[j] = [[Int8.((0,0)) for j in 1:n], ( [[Int8.((0,0)) for j in 1:i] for i in n-2:-1:1]... )]
        VN_configs2[j][1] = VN_configs[j][1,:]
        for i in 2:size(VN_configs[j],2)-1
            VN_configs2[j][i] = VN_configs[j][i,i+1:end]
        end
    end

    return VN_configs2
end

# Utility #

function remove!(a, item)
    deleteat!(a, findall(x -> x == item, a))
end


# Group stage evaluation #

function pair_to_match(P)
    M = Vector{Match}(undef, length(P))

    for i in eachindex(P)
        M[i] = Match(P[i][1], P[i][2], 0, 0)
    end

    return M
end

function simulate_matches!(G)

    # All valid score combinations (normal, overtime, last-cup scenarios)
    Scores1 = [[i, 10] for i in 0:9]
    Scores2 = [[10,i] for i  in 0:9]
    Scores3 = [[i,16] for i  in 10:15]
    Scores4 = [[16,i] for i  in 10:15]
    Scores5 = [[i,19] for i  in 16:18]
    Scores6 = [[19,i] for i  in 16:18]
    Scores = cat(Scores1, Scores2, Scores3, Scores4, Scores5, Scores6, dims=1) 

    for i in eachindex(G), j in eachindex(G[i])
        G[i][j].score_1, G[i][j].score_2 = rand(Scores) 
    end
end

function create_matches(G; play::Bool=false) # with play=true, returns a completed group stage with random scores 
    M = Vector{Vector{Match}}(undef,length(G))

    for i in eachindex(G)
        M[i] = pair_to_match(G[i])
    end

    if play 
        simulate_matches!(M)
    end

    return M
end

function calculate_group_rankings(G, Groupnum, groupsize, Groups)
    
    # Collect all matches (can later include knockout phase for statistics)
    All_M = cat(G..., dims=1)

    # Sort all matches by group
    n_groups = max( cat(Groupnum..., dims=1)... )
    grouped_matches = [[] for i in 1:n_groups] 

    for k in 1:n_groups 
        for i in eachindex(G), j in 1:length(G[i])
            if Groupnum[i][j] == k
                push!(grouped_matches[k], G[i][j])
            end
            if length(grouped_matches[k]) == sum(1:groupsize-1) break end 
        end
    end

    group_rankings = [[] for i in eachindex(grouped_matches)]

    for k in eachindex(grouped_matches)
        # Evaluate a single group

        Points_m = Array{Integer}(undef, sum(1:groupsize-1), 2)     # Points per match
        Points_sum = zeros(Integer, groupsize)                      # Total points
        Cups = zeros(Integer, groupsize)                            # Cups scored
        Cups_diff = zeros(Integer, groupsize)                       # Cup differential
        Teams = [Groups[k][i].name for i in 1:length(Groups[k])]    # Team names in this group
        Team_wins = Vector{Vector{Team}}(undef,length(Groups[k]))   # Head-to-head record  

        # Calculate points from matches
        for i in 1:sum(1:groupsize-1) 
            Points_m[i,:] .= points(grouped_matches[k][i]) 
        end

        # Accumulate match points into total points 
        for i in 1:sum(1:groupsize-1)
            for j in eachindex(Teams)

                if Teams[j] == grouped_matches[k][i].team_1.name 
                    Points_sum[j] += Points_m[i,1] 

                elseif Teams[j] == grouped_matches[k][i].team_2.name
                    Points_sum[j] += Points_m[i,2] 

                end
            end
        end

        # Count cups scored 
        for i in eachindex(Teams)
            for j in 1:length(grouped_matches[k])

                if Teams[i] == grouped_matches[k][j].team_1.name 
                    Cups[i] += grouped_matches[k][j].score_1 

                elseif Teams[i] == grouped_matches[k][j].team_2.name
                    Cups[i] += grouped_matches[k][j].score_2 

                end
            end
        end

        # Calculate cup differential 
        for i in eachindex(Teams)
            for j in 1:length(grouped_matches[k])

                if Teams[i] == grouped_matches[k][j].team_1.name 
                    Cups_diff[i] += ( grouped_matches[k][j].score_1 - grouped_matches[k][j].score_2 )

                elseif Teams[i] == grouped_matches[k][j].team_2.name
                    Cups_diff[i] += ( grouped_matches[k][j].score_2 - grouped_matches[k][j].score_1 ) 

                end
            end
        end

        # Head-to-head record: Team_wins[i] lists the teams defeated by Groups[k][i]
        for i in 1:length(Groups[k]) 
            win_index = findall(x -> winner(x).name == Teams[i], grouped_matches[k])
            Team_wins[i] = loser.(grouped_matches[k][win_index])
        end

        group_rankings[k] = [Points_sum, Cups, Cups_diff, Team_wins]
    end

    return group_rankings

end


# Main #

function run_tournament(groupsize, nteams, ntable)

    Teams = alphabetical_teams(nteams)
    Groups, Matches = generate_groups(alphabetical_teams(nteams), groupsize)
    group_stage, group_numbers = create_schedule(Groups, Matches, ntable, groupsize)
    group_stage_played = create_matches(group_stage, play=true)


    return group_stage_played, group_numbers, calculate_group_rankings(group_stage_played, group_numbers, groupsize, Groups)
end


