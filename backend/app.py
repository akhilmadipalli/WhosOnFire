from flask import Flask, jsonify
import pandas as pd
from test import load_player_info

app = Flask(__name__)

load_player_info()
player_df = pd.read_pickle("./player_info.pkl")

# @app.route("/player/<name>")
# def home():




@app.route("/sync")
def sync_all():
    """
    Send player data over 
    """
    if(player_df.empty):
        return jsonify({"Error. no player data found"}, 500)
    
    return jsonify(player_df.to_dict(orient='records'))
    
if __name__ == "__main__":
    print("Running backend server")
    app.run(host='0.0.0.0', port=5001, debug=True)

