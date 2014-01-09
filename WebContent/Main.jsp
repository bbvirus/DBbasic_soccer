<!--
	2014. 1. 9.
	작성자 : 박세훈
	
	처음 접속할 때 보이는 페이지이다.
	DB에 접속해 team테이블과 league_table테이블을 join하여 팀 순위를 출력해준다.
	팀 명을 클릭하면 해당 팀의 선수단을 볼 수 있는 Team.jsp 페이지로 이동할 수 있다.
	리그 향후 일정을 확인할 수 있는  Match_List.jsp 페이지로 이동 할 수 있다.
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

	.team_name{
		width:200px;
		text-align:center;
	}

	.number{
		width:40px;
		text-align:center;
	}
	
	#match_list_link{
		margin:20px;
		width:400px;
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
	// team, league_table을 대상으로 inner join한 결과를 불러온다.
	String sql = "select * from league_table as lt inner join team as t on lt.team_name = t.team_name order by lt.points desc, lt.goal_difference desc, t.goals_against desc";
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery(sql);
	%>

	<h1>English Premier League</h1>
	
	<table>
	 	<tr>
			<td class=team_name>팀 이름</td>
			<td class=number>경기</td>
			<td class=number>승</td>
			<td class=number>무</td>
			<td class=number>패</td>
			<td class=number>승점</td>
			<td class=number>득</td>
			<td class=number>실</td>
			<td class=number>득실</td>
		</tr>
	</table>
	
	<table>
		<%
		while(rs.next()){
			String team_name = rs.getString("team_name");
			String played = rs.getString("played");
			String win = rs.getString("win");
			String draw = rs.getString("draw");
			String loss = rs.getString("loss");
			String points = rs.getString("points");
			String goals_for = rs.getString("goals_for");
			String goals_against = rs.getString("goals_against");
			String goal_difference = rs.getString("goal_difference");
	 	%>
	 	<tr>
	 		<!-- 팀 이름을 클릭하면 해당 팀 이름을 GET방식으로 전달하면서 Team.jsp 페이지로 넘어가게 한다. -->
			<td class=team_name><a href = "Team.jsp?team=<%=team_name%>"><%=team_name %></a></td>
			<td class=number><%=played %></td>
			<td class=number><%=win %></td>
			<td class=number><%=draw %></td>
			<td class=number><%=loss %></td>
			<td class=number><%=points %></td>
			<td class=number><%=goals_for %></td>
			<td class=number><%=goals_against %></td>
			<td class=number><%=goal_difference %></td>
		</tr>
		<%}%>
	</table>
	<div id = match_list_link>
		<a href = "Match_List.jsp" >Scheduled Match</a>
	</div>
	<%
	rs.close();
	stmt.close();
	conn.close();
	%>
</body>
</html>