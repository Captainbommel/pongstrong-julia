# Pongstrong 

A tournament management tool for beer pong, written in Julia. Or at least the attempt of making one.

It generates group-stage schedules, assigns matches to tables across rounds, scores games, ranks teams, and produces visual match-card displays using [Luxor.jl](https://github.com/JuliaGraphics/Luxor.jl).

## Functions

- **Group generation** - Splits any number of teams into equally sized groups.
- **Optimal pairing** - A combinatorial algorithm schedules all intra-group matches so that no team plays twice in the same round.
- **Table-aware scheduling** - Distributes matches across a configurable number of tables per round.
- **Scoring system** - Supports normal wins, overtime, and deathcup scenarios with a point-based ranking.
- **Group rankings** - Ranks teams by points, cups scored, cup differential, and head-to-head record.
- **Visualization** - Renders each round as styled match cards on a DIN-A4-sized page via Luxor.jl.


## Quick Start

Have a look at [Demo.jl](src/Demo.jl)

The demo will simulate a full group stage, prints standings for each group, and generates a visual schedule. I also have generated some example PNGs and put them into `/examples`.

## Cookbook

There is a Julia language cheat sheet I put together while working on this project. Check out the seperate [Readme](cookbook/README.md) I made for this as well as the implementation in [cookbook.jl](cookbook/cookbook.jl).
