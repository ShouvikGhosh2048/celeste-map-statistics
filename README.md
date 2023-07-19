# celeste-map-statistics
A visualization of various statistics of maps from Celeste mods. The mods used were from [this list](https://docs.google.com/spreadsheets/d/1_fYM8JABpChRmwvyydB3a6C5AkiFRqYLus4NWHJbJpU/edit#gid=831454936]).

This project is inspired by [this video](https://www.youtube.com/watch?v=I9ieN1ACfP4).

## Files
- download_mods.jl: A script to download the mods from GameBanana. You'll have to download the .xlsx file from the list mentioned above into this folder before running the script. (Note that all mods can't be downloaded together due to GameBanana API limits. You can run the script again after running it once, and it will start downloading the remaining mods. You can also run the notebook on the subset of mods downloaded.)
- map_statistics.ipynb: A Jupyter notebook with the results.

## Explaination
![map](https://github.com/ShouvikGhosh2048/celeste-map-statistics/assets/91585022/68af6e68-21bc-43cb-86f1-4bf9364da53a)

I represent the map as a grid of squares - the length of the square's side is about half of Madeline's(player) height. We represent the various values in terms of this side length. We place the player, foreground tiles and spinners on this grid.

For map dimensions I consider the height, width and the height to width ratio of the bounding box around the map. The assumption is that maps with a higher height to width ratio will have the player mainly moving upwards/downwards rather that left/right.

For map size, I first just consider the rooms (no obstacles/foreground tiles). The total area taken up by the rooms is called the map size. I then place foreground tiles and spinners (obstacles) and consider the remaining empty space. The ratio of this empty space to map size tells the us the fraction of the map which is empty.

For distances, I consider the euclidean distance (straight line path) between the player and the completion trigger area / heart position. Since we have a grid, we can also perform BFS (we consider squares as adjacent if they share a side) from the player to the completion trigger area / heart position. The ratio between the BFS distance and the euclidean distance (straight line path) gives us an idea about the path - a lower ratio might indicate a straight path, while a larger ratio might indicate a path with many turns/large turns.

## Limitations
- I don't currently consider other obstacles/entities.
- Certains maps may have a path from the start to end, but my method doesn't detect them - this can occur when a player performs an action which causes the spinners to change their position - my method doesn't consider this and so BFS may not give us a path.
- The start/end detected can sometimes be wrong - the method used isn't 100% accurate.
- I don't consider the game physics.
- The current BFS distance isn't the best distance choice - it doesn't consider diagonal movement.
