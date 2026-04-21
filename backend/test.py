import nflreadpy as nfl
import pandas as pd
pbp = nfl.load_pbp()
pbp_pandas = pbp.to_pandas()

pd.set_option('display.max_columns', None)

# Loads SeasonStats for each player

def load_player_stats(season):
    player_stats = nfl.load_player_stats(season)
    player_stats = player_stats.to_pandas()
    for stat in list(player_stats.columns):
        print(stat)

    columns = ['player_id','player_display_name',
           'position','headshot_url','season','week','team',
           'passing_yards','passing_tds','passing_interceptions',
           'rushing_yards','rushing_tds','receiving_yards','receiving_tds',
           'def_sacks','def_interceptions','def_fumbles_forced',
           'fantasy_points_ppr','passing_epa','rushing_epa','receiving_epa']
    player_stats = player_stats[columns].fillna(0)
    # Group by season
    print(f"Weekly agg: {len(player_stats)}")

    player_stats = player_stats.groupby(["player_id","season"]).agg({
        "player_display_name": "first",
        "position": "first",
        "headshot_url": "first",
        "team": "first",
        "week": "count", # Number of weeks played
        "passing_yards":"sum",
        "passing_tds":"sum",
        "passing_interceptions":"sum",
        "rushing_yards":"sum",
        "rushing_tds":"sum",
        "receiving_yards":"sum",
        "receiving_tds":"sum",
        "def_sacks":"sum",
        "def_interceptions":"sum",
        "def_fumbles_forced":"sum",
        "fantasy_points_ppr":"sum",
        "passing_epa": "mean",
        "rushing_epa": "mean",
        "receiving_epa": "mean",
        })
    player_stats = player_stats.reset_index()
    player_stats['player_id'] = player_stats['player_id'].astype(str)
    
    print(player_stats['team'])

                           
    print(f"Season agg: {len(player_stats)}")
    unique_players = player_stats["player_id"].nunique()
    
    print(f"Unique players for stats: {unique_players}")

    player_stats.to_pickle("player_season_info.pkl")
    
# Load base information about each player


def load_player_info():
    stats_df = pd.read_pickle("player_season_info.pkl").reset_index()

# Load all players
    all_players = nfl.load_players().to_pandas()
    all_players.rename(columns={'gsis_id':'player_id'}, inplace=True)
    all_players.rename(columns={'display_name':'player_display_name'}, inplace=True)
    all_players.rename(columns={'headshot':'headshot_url'}, inplace=True)
    all_players.rename(columns={'latest_team':'team'}, inplace=True)
    print(all_players.columns)
    print(all_players["teams"])

# Only keep players who are in stats_df OR season
    active_players = all_players[all_players['player_id'].isin(stats_df['player_id'].unique())]
    active_players['player_id'] = active_players['player_id'].astype(str)
    active_players = active_players.fillna("")

    print(f"Total historical players: {len(all_players)}")
    print(f"Active players (2023-2025): {len(active_players)}")

    active_players.to_pickle("players.pkl")





