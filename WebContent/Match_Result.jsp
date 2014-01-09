<!--
	2014. 1. 9.
	작성자 : 박세훈
	
	경기 세부 내용을 볼 수 있는 페이지이다.
	DB에 접속해 match_result 테이블의 정보를 가져온다.
-->
<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
	a {
		color:black;
		text-decoration:none;
	}
	
	#go_home{
		margin-left:40px;
		margin-top:10px;
		margin-bottom:15px;
	}
	
	.team{
		margin-left:5px;
		margin-top:25px;
		margin-bottom:5px;
	}
	
	.home_team{
		width:160px;
		text-align:right;
	}
	
	.away_team{
		width:160px;
		text-align:left;
	}
	
	.match_score{
		width:30px;
		text-align:center;
	}
	
	.team_name {
		width:150px;
	}
	
	.player_name {
		width:200px;
		text-align:center;
	}
	
	.player_info{
		width:40px;
		text-align:center;
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
	
	request.setCharacterEncoding("utf-8");
	
	try{
		Class.forName(driverName);
	}catch(ClassNotFoundException e){
		System.out.println("no driver");
		e.printStackTrace();
		return;
	}
	
	Connection conn = DriverManager.getConnection(url, id, pw);
	
	// match_schedule 테이블에서 경기 정보를 불러온다.
	String match_result_sql = "select * from match_schedule where match_id = " + request.getParameter("match_id");
	Statement result_stmt = conn.createStatement();
	ResultSet result_rs = result_stmt.executeQuery(match_result_sql);
	
	// match_player_result 테이블에서 홈팀 선수들의 경기 스탯을 불러온다.
	String home_team_sql = "select * from player as p inner join (select * from match_player_result where match_id = " + request.getParameter("match_id") + ") as m on p.player_id = m.player_id where p.team_name = (select home_team from match_schedule where match_id = " + request.getParameter("match_id") + ")";
	Statement home_team_stmt = conn.createStatement();
	ResultSet home_team_rs = home_team_stmt.executeQuery(home_team_sql);
	
	// match_player_result 테이블에서 원정팀 선수들의 경기 스탯을 불러온다.
	String away_team_sql = "select * from player as p inner join (select * from match_player_result where match_id = " + request.getParameter("match_id") + ") as m on p.player_id = m.player_id where p.team_name = (select away_team from match_schedule where match_id = " + request.getParameter("match_id") + ")";
	Statement away_team_stmt = conn.createStatement();
	ResultSet away_team_rs = away_team_stmt.executeQuery(away_team_sql);
	
	%>
	<h1>Match Report</h1>
	<div id=go_home><a href="Main.jsp">Go Home</a></div>
	
	<table>
		<%
		while(result_rs.next()){
			String home_team_name = result_rs.getString("home_team");
			String home_team_goal = result_rs.getString("home_team_score");
			String away_team_name = result_rs.getString("away_team");
			String away_team_goal = result_rs.getString("away_team_score");
	 	%>
	 	<tr>
			<td class=home_team><%=home_team_name %></td>
			<td class=match_score><%=home_team_goal %></td>
			<td>vs</td>
			<td class=match_score><%=away_team_goal %></td>
			<td class=away_team><%=away_team_name %></td>
		</tr>
		<%}%>
	</table>
	
	<div class=team>Home Team</div>
	
	<table>
	 	<tr>
			<td class=player_name>선수 이름</td>
			<td class=player_info>골</td>
			<td class=player_info>어시</td>
			<td class=player_info>패스</td>
			<td class=player_info>평점</td>
		</tr>
	</table>
	
	<table>
		<%
		while(home_team_rs.next()){
			String home_player_name = home_team_rs.getString("player_name");
			String home_player_goal = home_team_rs.getString("goal");
			String home_player_assist = home_team_rs.getString("assist");
			String home_player_pass_success_rate = home_team_rs.getString("pass_success_rate");
			String home_player_rating = home_team_rs.getString("rating");
	 	%>
	 	<tr>
			<td class=player_name><%=home_player_name %></td>
			<td class=player_info><%=home_player_goal %></td>
			<td class=player_info><%=home_player_assist %></td>
			<td class=player_info><%=home_player_pass_success_rate %></td>
			<td class=player_info><%=home_player_rating %></td>
		</tr>
		<%}%>
	</table>

	<div class=team>Away Team</div>
	
	<table>
	 	<tr>
			<td class=player_name>선수 이름</td>
			<td class=player_info>골</td>
			<td class=player_info>어시</td>
			<td class=player_info>패스</td>
			<td class=player_info>평점</td>
		</tr>
	</table>
	
	<table>
		<%
		while(away_team_rs.next()){
			String away_player_name = away_team_rs.getString("player_name");
			String away_player_goal = away_team_rs.getString("goal");
			String away_player_assist = away_team_rs.getString("assist");
			String away_player_pass_success_rate = away_team_rs.getString("pass_success_rate");
			String away_player_rating = away_team_rs.getString("rating");
	 	%>
	 	<tr>
			<td class=player_name><%=away_player_name %></td>
			<td class=player_info><%=away_player_goal %></td>
			<td class=player_info><%=away_player_assist %></td>
			<td class=player_info><%=away_player_pass_success_rate %></td>
			<td class=player_info><%=away_player_rating %></td>
		</tr>
		<%}%>
	</table>
	
	<%
	home_team_rs.close();
	home_team_stmt.close();
	away_team_rs.close();
	away_team_stmt.close();
	conn.close();

	%>
</body>
</html>