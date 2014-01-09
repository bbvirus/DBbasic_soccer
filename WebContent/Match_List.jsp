<!--
	2014. 1. 9.
	작성자 : 박세훈
	
	리그 향후 일정을 볼 수 있는 페이지이다.
	DB의 match_schedule 테이블에서 아직 경기를 치르지 않은 경기 일정을 가져온다.
	팀 명을 클릭하면 해당 팀 선수단을 볼 수 있는 페이지로 이동한다.
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
	
	.team_name{
		width:200px;
		text-align:center;
	}
	
	.match_date{
		width:120px;
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
	String sql = "select * from match_schedule where match_date > now()";
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery(sql);
	
	%>
	<h1>Scheduled Match</h1>
	<div id=go_home><a href="Main.jsp">Go Home</a></div>
	
	<table>
	 	<tr>
			<td class=match_date>경기 일자</td>
			<td class=team_name>홈팀</td>
			<td class=team_name>원정팀</td>
		</tr>
	</table>
	
	<table>
		<%
		while(rs.next()){
			String match_id = rs.getString("match_id");
			String match_date = rs.getString("match_date");
			String home_team = rs.getString("home_team");
			String away_team = rs.getString("away_team");
	 	%>
	 	<tr>
			<td class=match_date><%=match_date %></td>
			<td class=team_name><a href = "Team.jsp?team=<%=home_team %>"><%=home_team %></a></td>
			<td class=team_name><a href = "Team.jsp?team=<%=away_team %>"><%=away_team %></a></td>
		</tr>
		<%}%>
	</table>
	<%
	rs.close();
	stmt.close();
	conn.close();

	%>
</body>
</html>