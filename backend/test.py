import nflreadpy as nfl
import pandas as pd
pbp = nfl.load_pbp()
pbp_pandas = pbp.to_pandas()


print(pbp_pandas)

#player_stats = nfl.load_player_stats([2022, 2023])
