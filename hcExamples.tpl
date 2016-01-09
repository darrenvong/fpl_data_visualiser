<!DOCTYPE HTML>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>Highcharts Example</title>

		<script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>
		<style type="text/css">
${demo.css}
		</style>
        <script src="js/highcharts.js"></script>
        <script src="js/highcharts-more.js"></script>
        <script src="js/modules/exporting.js"></script>
        <script src="js/math.min.js"></script>
        % from scrapper import getPoints
        % import json
        % playData = {}
        % for points, weeks, name in getPoints():
        %   playData[name] = map(list, zip(weeks, points))
        % end
        <script type="text/javascript">
        var playersData = {{!json.dumps(playData)}};
        </script>
		<script type="text/javascript" src="js/fpl_graphs.js"></script>
	</head>
	<body>
        <label for="players">Player's name:</label>
        <select id="players" name="players">
            % for player in playData:
            <option value={{player}}>{{player}}</option>
            % end
        </select>
        <button id="drawline">Draw line</button>


        <button id="drawbox">Draw box</button><br>
        <!-- <label for="players2">Player 2's name:</label>
        <select id="players2" name="players2">
            <option value="Mahrez" selected>Mahrez</option>
            <option value="Lukaku">Lukaku</option>
            <option value="Ozil">Ozil</option>
            <option value="Vardy">Vardy</option>
        </select>
        <button id="correlate">Correlate players!</button> -->
    <div id="container" style="min-width: 310px; margin: 0 auto"></div>

	</body>
</html>
