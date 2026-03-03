using Pkg
Pkg.add("Combinatorics")
Pkg.add("Luxor")

include("Pong.jl")

# Simulate a tournament
# 6 teams per group, 18 teams, 5 tables
groupsize = 4
nteams = 24
ntables = 6

Teams = alphabetical_teams(nteams)
Groups, Matches = generate_groups(Teams, groupsize)
group_stage, group_numbers = create_schedule(Groups, Matches, ntables, groupsize)
results = create_matches(group_stage, play=true)
rankings = calculate_group_rankings(results, group_numbers, groupsize, Groups)

# Print group standings
for (k, group) in enumerate(Groups)
    println("\n\n Group $k\n")
    names      = [t.name for t in group]
    pts        = rankings[k][1]
    cups       = rankings[k][2]
    cups_diff  = rankings[k][3]

    # Sort by points, then cup differential, then cups scored
    order = sortperm(collect(zip(pts, cups_diff, cups)), rev=true)

    println(lpad("Team", 6), lpad("Pts", 6), lpad("Cups", 6), lpad("+/-", 6))
    println("-"^24)
    for i in order
        println(lpad(names[i], 6), lpad(pts[i], 6), lpad(cups[i], 6), lpad(cups_diff[i], 6))
    end
end

# Visualize group stage
draw_group_phase_from_data(6.5, results, group_numbers)