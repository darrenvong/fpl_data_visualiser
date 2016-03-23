# -*- coding: utf-8 -*-

"""
@author: Darren Vong
"""
from string import capwords

import helpers

def get_profile_contents(player_name, col):
    query = {"normalised_name": player_name}
    projection = {"_id": 0, "web_name": 1,"total_points": 1, "now_cost": 1, "goals_scored": 1,
                  "assists": 1, "clean_sheets": 1,
                  "net_transfers": {"$subtract": ["$transfers_in_event", "$transfers_out_event"]},
                  "minutes": 1, "yellow_cards": 1, "chance_of_playing_next_round": 1,
                  "fixture_history": 1, "type_name": 1, "photo": 1, "selected_by_percent": 1}
    pipeline = [{"$match": query}, {"$project": projection}]
    cursor = col.aggregate(pipeline)
    profile_contents = cursor.next()
    profile_contents["current_gw"] = profile_contents["fixture_history"][-1]["gameweek"]
    return profile_contents

def get_player_names(col):
    cursor = col.find({}, {"_id": 0, "normalised_name": 1})
    player_names = [custom_capitalise(player_obj["normalised_name"]) for player_obj in cursor]
    return player_names

def custom_capitalise(s):
    """Capitalises every word in @param: string, as opposed to only the first word in the string
    in the default Python implementation. This is purely for aesthetic purpose only for
    when the names are suggested to the user in the autocomplete widget."""
    
    return capwords(s, " ")

if __name__ == '__main__':
    client, players = helpers.connect()
    print get_profile_contents(u"Mahrez", players)
    client.close()