# celeste-map-statistics
A visualization of various statistics of maps from Celeste mods. The mods used were from [this list](https://docs.google.com/spreadsheets/d/1_fYM8JABpChRmwvyydB3a6C5AkiFRqYLus4NWHJbJpU/edit#gid=831454936]).

The metrics focused on are:
- Map dimensions: Width, height and the height to width ratio of the bounding box around the rooms. The goal was to observe maps which utilize vertical movement.
- Map size/empty space: The space the rooms in the map take up, the empty space after removing foreground tiles, and the ratio between them.
- Player to heart distance: BFS distance and euclidean distance between the player and the heart and the ratio between them. A larger ratio could signify that the path from the player to the heart has many turns.

This project is inspired by [this video](https://www.youtube.com/watch?v=I9ieN1ACfP4).

## Files
- download_mods.jl: A script to download the mods from GameBanana. You'll have to download the .xlsx file from the list mentioned above into this folder before running the script. (Note that all mods can't be downloaded together due to GameBanana API limits. You can run the script again after running it once, and it will start downloading the remaining mods. You can also run the notebook on the subset of mods downloaded.)
- map_statistics.ipynb: A Jupyter notebook with the results.
