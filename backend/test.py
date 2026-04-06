import nflreadpy as nfl
import pandas as pd
pd.set_option('display.max_columns', None)

def load_player_info():
    players = nfl.load_players()
    player_stats = nfl.load_player_stats([2024])

    player_stats = player_stats.to_pandas()
    players = players.to_pandas()
    players.rename(columns={'gsis_id':'player_id'},inplace=True)

    player_info = player_stats.merge(
        players, 
        on='player_id', 
        how='left'
    )
    columns = ['player_id','player_display_name',
           'position_x','headshot_url','season','week','team',
           'draft_year','draft_pick','years_of_experience',
           'passing_yards','passing_tds','passing_interceptions',
           'completions','attempts','rushing_yards','rushing_tds',
           'carries','receiving_yards','receiving_tds','targets',
           'def_sacks','def_interceptions','def_fumbles_forced',
           'def_tackles_for_loss','def_pass_defended',
           'fantasy_points_ppr','passing_epa','rushing_epa','receiving_epa',
           'passing_cpoe','wopr']
    player_info = player_info[columns]
    player_info = player_info.fillna(0)
    player_info.to_pickle("player_info.pkl")
    # player_name = "Patrick Mahomes"
# filtered_df = df[df['player_display_name'] == player_name]
# print(list(filtered_df.columns))
