<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="player profiles">
    <meta name="author" content="Darren Vong">
    <link rel="icon" href="img/favicon.ico">

    <title>Fantasy Premier League player Data Visualiser</title>

    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- jQuery UI CSS -->
    <link rel="stylesheet" href="css/jquery-ui.min.css">

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="css/ie10-viewport-bug-workaround.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/general.css" rel="stylesheet">
    <link href="css/profile.css" rel="stylesheet">

    <!-- Polyfill fixes by Mozilla Developer Network (2016), https://developer.mozilla.org/ -->
    <script src="js/polyfills.js"></script>

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>
    % from views import general
    {{ !general.get_navbar() }}

    <!-- Main "body" of the page -->
    <div class="container profile-body">
      <div class="row">
        <div class="col-md-5">
          <form method="post">
            <label for="player-names">Player's name: </label>
            <input id="player-names" name="player_name" class="form-control" type="text" size="20">
            <button type="submit" class="btn btn-default">
              <span class="sr-only">Search</span>
              <span class="glyphicon glyphicon-search"></span>
            </button>
            <p class="help-block text-warning profile-page hidden"><span class="glyphicon glyphicon-alert"></span> Player not found!</p>
          </form>
          <figure>
            <img src={{u"faces/"+contents["photo"]}} class="img-responsive center-block" alt='{{contents["normalised_name"]}}'>
          </figure>
          <p id="player_name" class="text-center"><b>{{contents["web_name"]}}</b></p>
          <table class="table table-bordered table-hover">
            <caption class="profile_caption">Click on a row to reveal/hide more data for <b>Points</b> and <b>Price</b></caption>
            <thead>
              <tr class="thead-row-color">
                <th>Attribute</th>
                <th>Value</th>
              </tr>
            </thead>
            <tbody>
              <tr id="points">
                <td><span class="glyphicon glyphicon-chevron-right"></span> Points</td>
                <td>{{contents["total_points"]}}</td>
              </tr>
              <tr id="points_extra" class="no-extra-info hidden">
                <td><span class="extras">per minute</span></td>
                <td>{{round( contents["minutes"]/float(contents["total_points"]), 1 ) if contents["total_points"] != 0 else 0}}</td>
              </tr>
              <tr id="price">
                <td><span class="glyphicon glyphicon-chevron-right"></span> Price</td>
                <td>£{{unicode(contents["now_cost"]/10.0)}}M</td>
              </tr>
              <tr id="price_extra" class="no-extra-info hidden">
                <td><span class="extras">points per million</span></td>
                <td>{{round( contents["total_points"]/(contents["now_cost"]/10.0), 1 )}}</td>
              </tr>
              <tr id="goals" class="no-extra-info">
                <td>Goals</td>
                <td>{{contents["goals_scored"]}}</td>
              </tr>
              <tr id="assists" class="no-extra-info">
                <td>Assists</td>
                <td>{{contents["assists"]}}</td>
              </tr>
              % if contents["type_name"] == "Goalkeeper" or contents["type_name"] == "Defender":
              <tr id="cleanSheets" class="no-extra-info">
                <td>Clean sheets</td>
                <td>{{contents["clean_sheets"]}}</td>
              </tr>
              % end
              <tr id="netTransfers" class="no-extra-info">
                <td>Net transfers</td>
                <td>{{contents["net_transfers"]}}</td>
              </tr>
              <tr id="minutesPlayed" class="no-extra-info">
                <td>Minutes played</td>
                <td>{{contents["minutes"]}}</td>
              </tr>
              <tr id="selectedBy" class="no-extra-info">
                <td>Selected by</td>
                <td>{{contents["selected_by_percent"]}}%</td>
              </tr>
              <tr id="yellowCards" class="no-extra-info">
                <td>Yellow cards</td>
                <td>{{contents["yellow_cards"]}}</td>
              </tr>
              <tr id="chanceOfPlayingNextRound" class="no-extra-info">
                <td>Chance of playing</td>
                <td>{{0 if contents["chance_of_playing_next_round"] is None else contents["chance_of_playing_next_round"]}}%</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="col-md-7">
          <form class="form-inline">
            <div class="form-group" id="gameweek">
              <label for="startTime">From Game Week: </label>
              <select id="startTime" class="form-control sm-screen">
                % latest_gw, start_gw = contents["current_gw"], contents["start_gw"]
                % for wk in xrange(start_gw,latest_gw+1):
                %   if wk == start_gw:
                <option value={{wk}} selected>{{wk}}</option>
                %   else:
                <option value={{wk}}>{{wk}}</option>
                %   end
                % end
              </select>&nbsp;&nbsp;TO&nbsp;&nbsp;
              <select id="endTime" class="form-control sm-screen">
                % for wk in xrange(start_gw,latest_gw+1):
                  % if wk == latest_gw:
                <option value={{wk}} selected>{{wk}}</option>
                  % else:
                <option value={{wk}}>{{wk}}</option>
                  % end
                % end
              </select>
              <button type="button" class="btn btn-default" id="more_options">
                <span class="sr-only">More options</span>
                <span class="glyphicon glyphicon-chevron-down"></span>
              </button>
              <button type="button" class="btn btn-default" id="update_graph"><span class="glyphicon glyphicon-refresh"></span> Update graph</button>
            </div>
            <div class="performance_metrics hidden">
              <div class="form-group" id="points_group">
                <label class="labels">Points:</label>
                <select class="form-control sm-screen">
                  <option value="points-over_time">Over selected game weeks</option>
                  <option value="points-home_vs_away">Home vs Away</option>
                  <option value="points-consistency">Consistency</option>
                  <option value="points-cum_total">Cumulative total</option>
                  <option value="points-events_breakdown">Point scoring events breakdown</option>
                </select>
                <label class="checkbox-inline">
                  <input type="checkbox" class="points_switch" aria-label="Hides the 'Points' attribute from the graph"> Active
                </label>
                <a role="button" class="btn" data-toggle="popover" title="Points" data-content="Lorem ipsum..." data-trigger="hover" data-placement="right"><span class="glyphicon glyphicon-info-sign"></span></a>
              </div> <!-- #points_group -->
              <div class="form-group" id="price_group">
                <label class="labels">Price:</label>
                <select class="form-control sm-screen">
                  <option value="price-over_time">Over selected game weeks</option>
                  <option value="price-changes">Changes over selected game weeks</option>
                </select>
                <label class="checkbox-inline">
                  <input type="checkbox" class="price_switch" aria-label="Hides the 'Price' attribute from the graph"> Active
                </label>
                <a role="button" class="btn" data-toggle="popover" title="Price" data-content="Lorem ipsum..." data-trigger="hover" data-placement="right"><span class="glyphicon glyphicon-info-sign"></span></a>
              </div> <!-- #price_group -->
              <div class="form-group" id="goals_group">
                <label class="labels">Goals:</label>
                <select class="form-control sm-screen">
                    <option value="goals-over_time"> Over selected game weeks</option>
                    <option value="goals-home_vs_away"> Home vs Away</option>
                    <option value="goals-cum_total"> Cumulative total</option>
                </select>
                <label class="checkbox-inline">
                  <input type="checkbox" class="goals_switch" aria-label="Hides the 'Goals' attribute from the graph"> Active
                </label>
                <a role="button" class="btn" data-toggle="popover" title="Goals" data-content="Lorem ipsum..." data-trigger="hover" data-placement="right"><span class="glyphicon glyphicon-info-sign"></span></a>
              </div> <!-- #goals_group -->
              <div class="form-group" id="assists_group">
                <label class="labels">Assists:</label>
                <select class="form-control sm-screen">
                    <option value="assists-over_time"> Over selected game weeks</option>
                    <option value="assists-home_vs_away"> Home vs Away</option>
                    <option value="assists-cum_total"> Cumulative total</option>
                </select>
                <label class="checkbox-inline">
                  <input type="checkbox" class="assists_switch" aria-label="Hides the 'Assists' attribute from the graph"> Active
                </label>
                <a role="button" class="btn" data-toggle="popover" title="Assists" data-content="Lorem ipsum..." data-trigger="hover" data-placement="right"><span class="glyphicon glyphicon-info-sign"></span></a>
              </div> <!-- #assist_group -->
              % if contents["type_name"] == "Goalkeeper" or contents["type_name"] == "Defender":
              <div class="form-group" id="cleanSheets_group">
                <label class="labels">Clean sheets:</label>
                <select class="form-control sm-screen">
                    <option value="cleanSheets-over_time"> Over selected game weeks</option>
                    <option value="cleanSheets-home_vs_away"> Home vs Away</option>
                    <option value="cleanSheets-cum_total"> Cumulative total</option>
                </select>
                <label class="checkbox-inline">
                  <input type="checkbox" class="cleanSheets_switch" aria-label="Hides the 'Clean sheets' attribute from the graph"> Active
                </label>
                <a role="button" class="btn" data-toggle="popover" title="Clean Sheets" data-content="Lorem ipsum..." data-trigger="hover" data-placement="right"><span class="glyphicon glyphicon-info-sign"></span></a>
              </div> <!-- #cleanSheets_group -->
              % end
              <div class="form-group" id="netTransfers_group">
                <label class="labels">Net transfers:</label>
                <select class="form-control sm-screen">
                  <option value="netTransfers-over_time">Over selected game weeks</option>
                </select>
                <label class="checkbox-inline">
                  <input type="checkbox" class="netTransfers_switch" aria-label="Hides the 'Net transfers' attribute from the graph"> Active
                </label>
                <a role="button" class="btn" data-toggle="popover" title="Net Transfers" data-content="Lorem ipsum..." data-trigger="hover" data-placement="right"><span class="glyphicon glyphicon-info-sign"></span></a>
              </div> <!-- #netTransfers_group -->
              <div class="form-group" id="minutesPlayed_group">
                <label class="labels">Minutes played:</label>
                <select class="form-control sm-screen">
                  <option value="minutesPlayed-over_time">Over selected game weeks</option>
                </select>
                <label class="checkbox-inline">
                  <input type="checkbox" class="minutesPlayed_switch" aria-label="Hides the 'Minutes played' attribute from the graph"> Active
                </label>
                <a role="button" class="btn" data-toggle="popover" title="Minutes Played" data-content="Lorem ipsum..." data-trigger="hover" data-placement="right"><span class="glyphicon glyphicon-info-sign"></span></a>
              </div> <!-- #minutesPlayed_group -->
            </div>
          </form>
            <div class="alert alert-danger hidden" role="alert"><span class="glyphicon glyphicon-alert"></span>&nbsp;&nbsp;Invalid combination!</div>
            <div id="graph_container"></div>
        </div> <!-- end of col-md-7 (aka the right column) -->
      </div>

      {{!general.get_footer()}}
    </div> <!-- /container -->


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
    <script>window.jQuery || document.write('<script src="js/jquery-2.1.4.min.js"><\/script>')</script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/jquery-ui.min.js"></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="js/ie10-viewport-bug-workaround.js"></script>
    <script src="js/highcharts.js"></script>
    <script src="js/highcharts-more.js"></script>
    <script src="js/math.min.js"></script>
    <script src="js/accent_map.js"></script>
    <script src="js/unstick_buttons.js"></script>
    <script src="js/helpers.js"></script>
    <script src="js/profile_searchbar.js"></script>
    <script src="js/profile_graph.js"></script>
    <!-- Main method script -->
    <script src="js/profile.js"></script>
  </body>
</html>
