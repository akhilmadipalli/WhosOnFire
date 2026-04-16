from flask import Flask, jsonify, request
import pandas as pd
from test import load_player_info, load_player_stats

app = Flask(__name__)

# @app.route("/player/<name>")
# def home():

@app.route("/players", methods=["GET"])
def get_players():
    """
    Gets latest nfl player data and sends player data over 
    """
    
    load_player_info()
    player_df = pd.read_pickle("./players.pkl")

    if(player_df.empty):
        return jsonify({"Error. no player data found"}, 500)
    
    return jsonify(player_df.to_dict(orient='records'))
    
@app.route("/player_stats", methods=["POST"])
def get_player_stats():
    """
    Gets latest nfl 
    """
    body = request.get_json()
    seasons_list = body.get("seasons",[])
    load_player_stats(seasons_list)
    player_stats_df = pd.read_pickle("./player_season_info.pkl")
    if(player_stats_df.empty):
        return jsonify({"Error. no player season data found"}, 500)
    return jsonify(player_stats_df.to_dict(orient='records'))





if __name__ == "__main__":
    print("Running backend server")
    app.run(host='0.0.0.0', port=5001, debug=True)

