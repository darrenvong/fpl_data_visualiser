# -*- coding: utf-8 -*-

"""
This module models the "Clean sheets" attribute in a player profile or head-to-head
comparator's page table and provides functions for getting data of all the relevant
metrics available to "Clean sheets".
@author: Darren Vong
"""
import attribute

attr = "cleanSheets"

def get_over_time_data(col, player_name, start, end):
    return attribute.get_over_time_data(col, player_name, start, end, attr)

def get_home_vs_away_data(col, player_name, start, end):
    return attribute.get_home_vs_away_data(col, player_name, start, end, attr)

def get_cumulative_total_data(col, player_name, start, end):
    return attribute.get_cumulative_total_data(col, player_name, start, end, attr)
