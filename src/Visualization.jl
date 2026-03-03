using Luxor, Random


struct Team
    name::String
    member1::String
    member2::String
end

mutable struct Match 
    team_1::Team
    team_2::Team

    score_1::Int64 # deathcup -1, deathcup overtime -2
    score_2::Int64 
end


function random_teams(n)
    return [Team(randstring(1), randstring(4), randstring(4)) for i in 1:n]
end

function random_matches(n)
    Matches = Vector{Match}(undef, n)
    
    for i in 1:length(Matches)
        
        Matches[i] = Match(random_teams(1)[1], random_teams(1)[1], rand(1:19), rand(1:19))
    end

    return Matches
end

function draw_match_card(match::Match, table_color::String, x, y, boxsize) # x and y position
    
    width = boxsize*16
    height = boxsize*8

    # Draw colored and white rectangles
    sethue(table_color)
    rect(x, y, width, height, :fill) 
    sethue("white")
    rect(x, y + height/2, width, height, :fill)

    # Outline both in black
    sethue("black") 
    setline(boxsize/4.2)
    rect(x, y, width, height, :stroke)

    # Fill with text
    fontsize(boxsize*3.9)
    fontface("Georgia Bold")
    
    text("$(match.team_1.name) vs $(match.team_2.name)", x + floor(width/2) , y + 3.42*(height/8), halign=:center)
    text("$(match.score_1)", x + 9*(width/12), y + 7.5*(height/8), halign=:center)
    text("$(match.score_2)", x + 3*(width/12), y + 7.5*(height/8), halign=:center)
    text("-", x + width/2, y + 7.2*(height/8), halign=:center)

end

function draw_round(x, y, boxsize; column_gap=30, width=0)
    
    # Placeholder parameters (to be replaced with real data) #
    matches = random_matches(10)
    k = 1
    colors = ["royalblue3", "plum2", "yellowgreen", "yellow", "darkgoldenrod3", "purple3", "red", "lightseagreen","magenta2"] 
    l = 1 
    groupnum = [9, 9, 1, 1, 2, 2, 3, 3, 5, 6] 
    ###################################

    N_groups = unique(groupnum)
    n = length(N_groups) # number of groups

    offsetx = - (boxsize*16*n/2 + column_gap*n/2 - column_gap/2)
    if width > 0 && offsetx < - width / 2 + abs(x)   
        println("adjusting boxsize to fit boundaries") 
        while offsetx < - width / 2 + abs(x) + column_gap / 3
            boxsize -= 0.1
            offsetx = - (boxsize*16*n/2 + column_gap*n/2 - column_gap/2)
        end
    end


    offsety = 0
    for i in 1:n

        fontface("Georgia Bold")
        fontsize(boxsize*2.9)
        text("Group $(N_groups[i])", x + offsetx + boxsize*8, y - column_gap/7, halign=:center)  

        # Draw one group
        offsety = 0
        for j in 1:count(x -> x == N_groups[i], groupnum)

            draw_match_card(matches[k], colors[l], x + offsetx, y + offsety, boxsize)

            offsety += boxsize*8 + column_gap/5
            l == length(colors) ? l = 1 : l += 1 # k and l coincide since each round is sized to the table count
            k = l 
        end

        offsetx += boxsize * 16 + column_gap 
    end
    
end

function draw_group_phase(boxsize,n) 
    
    # Dimensions for a DIN A4 sheet 
    width = 1000 
    height = floor(width*sqrt(2))
    Drawing(width, height)
    background("white")
    origin(Point(floor(width/2), 0)) 

    for i in 0:n-1
        draw_round(0, (height / n) * i + 50 * (3.5/n), boxsize, width=width) 
    end

    finish()
    preview()

end

function draw_round_from_data(x, y, boxsize, matches, groupnum; column_gap=30, width=0)
    
    colors = ["royalblue3", "plum2", "yellowgreen", "yellow", "darkgoldenrod3", "purple3", "red"] 

    N_groups = unique(groupnum)
    n = length(N_groups) # number of groups

    offsetx = - (boxsize*16*n/2 + column_gap*n/2 - column_gap/2)
    if width > 0 && offsetx < - width / 2 + abs(x)   
        println("adjusting boxsize to fit boundaries") 
        while offsetx < - width / 2 + abs(x) + column_gap / 3
            boxsize -= 0.1
            offsetx = - (boxsize*16*n/2 + column_gap*n/2 - column_gap/2)
        end
    end

    k = l = 1
    offsety = 0
    for i in 1:n

        fontface("Georgia Bold")
        fontsize(boxsize*2.9)
        text("Group $(N_groups[i])", x + offsetx + boxsize*8, y - column_gap/7, halign=:center)  

        # Draw one group  
        offsety = 0
        for j in 1:count(x -> x == N_groups[i], groupnum)

            draw_match_card(matches[k], colors[l], x + offsetx, y + offsety, boxsize)

            offsety += boxsize*8 + column_gap/5
            l == length(colors) ? l = 1 : l += 1 # k and l coincide since each round is sized to the table count
            k = l 
        end

        offsetx += boxsize * 16 + column_gap 
    end
    
end

function draw_group_phase_from_data(boxsize, matches, groupnum) 
    
    # Dimensions for a DIN A4 sheet 
    width = 1000 
    height = floor(width*sqrt(2))
    Drawing(width, height)
    background("white")
    origin(Point(floor(width/2), 0)) 


    for i in eachindex(matches)
        draw_round_from_data(0, (height / length(matches)) * (i-1) + 50 * (3.5/length(matches)), boxsize, matches[i], groupnum[i], width=width) 
    end

    finish()
    preview()
end

# Note: these functions modify line width etc. 