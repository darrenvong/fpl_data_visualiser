"""
@author: Darren Vong
"""

from bottle import Bottle, static_file, template, redirect, response
import home, helpers
import json

class Router(Bottle):
    """This class is responsible for directing requests to callback handler functions
    and subsequently return the appropriate contents."""

    def __init__(self, *args, **kwargs):
        """Starts the visualiser application."""
        
        super(Router, self).__init__(*args, **kwargs)
        self.client, self.players_col = helpers.connect()
        self._route()
    
    def _route(self):
        """A pseudo-private method for binding callback functions to the different
        end points (i.e. URL paths) of the application."""
        
        self.route("/", callback=self.re_route)
        self.route("/index", callback=self.root)
        self.route("/profiles", callback=self.profiles)
        self.post("/player_names", callback=self.get_player_names)
        self.route("<path:path>", callback=lambda path: self.get_resources(path))
    
    def root(self):
        hot_players = home.get_hot_players(self.players_col)
        pound_stretchers = home.pound_stretchers(self.players_col)
        popular_players = home.most_popular(self.players_col)
        return template("index", hot_players=hot_players, pound_stretchers=pound_stretchers,
                        popular_players=popular_players)
    
    def re_route(self):
        """Redirects the 'true' root to the /index end point where a root page is
        actually defined."""
        redirect("/index")

    def get_player_names(self):
        cursor = self.players_col.find({}, {"_id": 0, "web_name": 1})
        player_names = [player_obj["web_name"] for player_obj in cursor]
        response.content_type = "application/json"
        return json.dumps(player_names)
    
    def profiles(self):
        return template("profiles_home")
    
    def get_resources(self, path):
        return static_file(path, root="./")

if __name__ == "__main__":
    visualiser = Router()
    visualiser.run(host='localhost', port=80, reloader=True, debug=True)