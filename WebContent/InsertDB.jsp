<!-- -->
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
	a{
		color:black;
		text-decoration:none;
	}	
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Soccer Statistics</title>
</head>
<body>
	<%
	String driverName = "com.mysql.jdbc.Driver";
	String url = "jdbc:mysql://localhost:3306/soccer";
	String id = "root";
	String pw = "rudfurqks12";
	ArrayList<Integer> player_list = new ArrayList<Integer>();
	int home_team_score;
	int away_team_score;
	int index = 0;
	
	request.setCharacterEncoding("utf-8");
	
	try{
		Class.forName(driverName);
	}catch(ClassNotFoundException e){
		System.out.println("no driver");
		e.printStackTrace();
		return;
	}
	
	Connection conn = DriverManager.getConnection(url, id, pw);

	String player_list_sql = "select * from player as p inner join match_schedule as ms on p.team_name = ms.home_team or p.team_name = ms.away_team where ms.match_id = " + request.getParameter("match_id");
	Statement player_list_stmt = conn.createStatement();
	ResultSet player_list_rs = player_list_stmt.executeQuery(player_list_sql);
	
	while(player_list_rs.next()){
		player_list.add(index, player_list_rs.getInt("player_id"));
		index++;
	}
	
	
	// match_player_result 테이블에 정보를 입력하는 부분
	for(int v=0; v < player_list.size() ; v++){
		int currentPlayerId = player_list.get(v);
		
		String insert_sql = "Insert into match_player_result values ("
						+ request.getParameter("match_id") + ", "
						+ currentPlayerId + ", "
						+ request.getParameter("goal" + currentPlayerId) + ", "
						+ request.getParameter("assist" + currentPlayerId) + ", "
						+ request.getParameter("pass_success_rate" + currentPlayerId) + ", "
						+ request.getParameter("rating" + currentPlayerId)
						+ ")";

		Statement insert_stmt = conn.createStatement();
		player_list_stmt.executeUpdate(insert_sql);
		insert_stmt.close();
	}
	
	Statement update_stmt = conn.createStatement();
	// match_schedule 테이블을 업데이트하는 부분
	String home_team_score_update_query = "update match_schedule as ms1 set ms1.home_team_score = ( select * from ( select score from match_schedule as ms inner join (select mpr.match_id, sum(mpr.goal) as score, p.team_name from match_player_result as mpr inner join player as p on mpr.player_id = p.player_id group by mpr.match_id, p.team_name) as mr on ms.match_id = mr.match_id where mr.match_id = " + request.getParameter("match_id") + " and mr.team_name = ms.home_team ) as test) where ms1.match_id = " + request.getParameter("match_id");
	String away_team_score_update_query = "update match_schedule as ms1 set ms1.away_team_score = ( select * from ( select score from match_schedule as ms inner join (select mpr.match_id, sum(mpr.goal) as score, p.team_name from match_player_result as mpr inner join player as p on mpr.player_id = p.player_id group by mpr.match_id, p.team_name) as mr on ms.match_id = mr.match_id where mr.match_id = " + request.getParameter("match_id") + " and mr.team_name = ms.away_team ) as test) where ms1.match_id = " + request.getParameter("match_id");

	update_stmt.executeUpdate(home_team_score_update_query);
	update_stmt.executeUpdate(away_team_score_update_query);
	
	
	// player 테이블을 업데이트하는 부분
	String player_goal_update_query = "update player as p inner join (select sum(mpr.goal) as score, mpr.player_id from match_player_result as mpr group by mpr.player_id) as buffer on p.player_id = buffer.player_id set p.goal = buffer.score";
	String player_assist_update_query = "update player as p inner join (select sum(mpr.assist) as help, mpr.player_id from match_player_result as mpr group by mpr.player_id) as buffer on p.player_id = buffer.player_id set p.assist = buffer.help";
	String player_pass_success_rate_update_query = "update player as p inner join (select sum(mpr.pass_success_rate)/count(mpr.pass_success_rate) as pass, mpr.player_id from match_player_result as mpr group by mpr.player_id) as buffer on p.player_id = buffer.player_id set p.pass_success_rate = buffer.pass";
	String player_rating_update_query = "update player as p inner join (select sum(mpr.rating)/count(mpr.rating) as number, mpr.player_id from match_player_result as mpr group by mpr.player_id) as buffer on p.player_id = buffer.player_id set p.rating = buffer.number";
	
	update_stmt.executeUpdate(player_goal_update_query);
	update_stmt.executeUpdate(player_assist_update_query);
	update_stmt.executeUpdate(player_pass_success_rate_update_query);
	update_stmt.executeUpdate(player_rating_update_query);
	
	// 홈팀 점수와 원정팀 점수를 가져오는 부분 : 각 팀 점수는 team 테이블 update할 때 사용
	String match_result_query = "select * from match_schedule where match_id = " + request.getParameter("match_id");
	Statement match_result_stmt = conn.createStatement();
	ResultSet match_result_rs = match_result_stmt.executeQuery(match_result_query);
	
	match_result_rs.next();
	home_team_score = match_result_rs.getInt("home_team_score");
	away_team_score = match_result_rs.getInt("away_team_score");
	
	// 홈팀 점수와 원정팀 점수를 바탕으로 승, 무, 패를 정해 team 테이블을 업데이트하는 부분 
	String home_team_result_update_query;
	String away_team_result_update_query;
	
	if(home_team_score > away_team_score){
		home_team_result_update_query = "update team set team.win = team.win+1 where team_name = (select home_team from match_schedule where match_id = "+ request.getParameter("match_id") + ")";
		away_team_result_update_query = "update team set team.loss = team.loss+1 where team_name = (select away_team from match_schedule where match_id = "+ request.getParameter("match_id") + ")";
	}

	else if(home_team_score == away_team_score){
		home_team_result_update_query = "update team set team.draw = team.draw+1 where team_name = (select home_team from match_schedule where match_id = "+ request.getParameter("match_id") + ")";
		away_team_result_update_query = "update team set team.draw = team.draw+1 where team_name = (select away_team from match_schedule where match_id = "+ request.getParameter("match_id") + ")";
	}
	
	else{
		home_team_result_update_query = "update team set team.loss = team.loss+1 where team_name = (select home_team from match_schedule where match_id = "+ request.getParameter("match_id") + ")";
		away_team_result_update_query = "update team set team.win = team.win+1 where team_name = (select away_team from match_schedule where match_id = "+ request.getParameter("match_id") + ")";
	}
	
	String home_team_goals_for_update_query = "update team set goals_for = goals_for + " + home_team_score + " where team_name = (select home_team from match_schedule where match_id = " + request.getParameter("match_id") + ")";
	String home_team_goals_against_update_query = "update team set goals_against = goals_against + " + away_team_score + " where team_name = (select home_team from match_schedule where match_id = " + request.getParameter("match_id") + ")";
	String away_team_goals_for_update_query = "update team set goals_for = goals_for + " + away_team_score + " where team_name = (select away_team from match_schedule where match_id = " + request.getParameter("match_id") + ")";
	String away_team_goals_against_update_query = "update team set goals_against = goals_against + " + home_team_score + " where team_name = (select away_team from match_schedule where match_id = " + request.getParameter("match_id") + ")";
	
	update_stmt.executeUpdate(home_team_result_update_query);
	update_stmt.executeUpdate(away_team_result_update_query);
	update_stmt.executeUpdate(home_team_goals_for_update_query);
	update_stmt.executeUpdate(home_team_goals_against_update_query);
	update_stmt.executeUpdate(away_team_goals_for_update_query);
	update_stmt.executeUpdate(away_team_goals_against_update_query);
	
	// league_table 테이블을 업데이트하는 부분
	String played_update_query = "update league_table as lt inner join team as t on lt.team_name = t.team_name set lt.played = t.win + t.draw + t.loss";
	String points_update_query = "update league_table as lt inner join team as t on lt.team_name = t.team_name set lt.points = (t.win * 3) + (t.draw * 1)";
	String goal_difference_update_query = "update league_table as lt inner join team as t on lt.team_name = t.team_name set lt.goal_difference = t.goals_for - t.goals_against";
	
	update_stmt.executeUpdate(played_update_query);
	update_stmt.executeUpdate(points_update_query);
	update_stmt.executeUpdate(goal_difference_update_query);
	
	update_stmt.close();
	
	%>
	<h1>Insert complete~!</h1>
	<a href="Main.jsp">Go Home</a>
	
	<%
	player_list_rs.close();
	player_list_stmt.close();
	conn.close();
	%>
	
</body>
</html>