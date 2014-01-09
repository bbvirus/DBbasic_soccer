<!--
	2014. 1. 9.
	작성자 : 박세훈
	
	팀의 경기 일정과 결과를 볼 수 있는 페이지이다.
	DB에 접속해 match_schedule테이블에서 해당 팀의 정보를 가져온다.
	각 경기의 세부사항을 볼 수 있는 Match_Result.jsp 페이지로 이동할 수 있다.
	경기 결과를 입력할 수 있는 Input.jsp 페이지로 이동할 수 있다.
-->
<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
	a{
		color:black;
		text-decoration:none;
		margin-right:40px;
	}
	
	#go_home{
		margin-left:20px;
		margin-top:10px;
		margin-bottom:10px;
	}
	
	.match_date{
		width:120px;
		text-align:center;
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
	String sql = "select * from match_schedule where home_team ='" + request.getParameter("team") + "' or away_team = '" + request.getParameter("team") + "'";
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery(sql);
	
	%>
	<h1>Match Schedule</h1>
	<div id=go_home><a href="Main.jsp">Go Home</a></div>
	
	<table>
	 	<tr>
			<td class=match_date>경기 일자</td>
			<td class=home_team>홈팀</td>
			<td class=match_score></td>
			<td class=match_score></td>
			<td class=away_team>원정팀</td>
			<td width=140px>경기 통계</td>
			<td>경기 결과 입력</td>
		</tr>
	</table>
	
	<table>
		<%
		while(rs.next()){
			String match_id = rs.getString("match_id");
			String match_date = rs.getString("match_date");
			String home_team = rs.getString("home_team");
			String away_team = rs.getString("away_team");
			int home_team_score = rs.getInt("home_team_score");
			int away_team_score = rs.getInt("away_team_score");
	 	%>
	 	<tr>
			<td class=match_date><%=match_date %></td>
			<td class=home_team><%=home_team %></td>
			<td class=match_score><%=home_team_score %></td>
			<td class=match_score><%=away_team_score %></td>
			<td class=away_team><%=away_team %></td>
			<td><a href="Match_Result.jsp?match_id=<%=match_id %>">Match report</a></td>
			<td><a href="Input.jsp?match_id=<%=match_id %>">Insert Match Result</a></td>
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