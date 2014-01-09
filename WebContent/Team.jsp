<!--
	2014. 1. 9.
	작성자 : 박세훈
	
	팀의 선수단 목록과 상세 정보들을 볼 수 있는 페이지이다.
	DB에 접속해 player테이블에서 해당 팀에 소속된 선수들 정보만을 가져온다.
	팀의 일정을 확인할 수 있는 Schedule.jsp 페이지로 이동할 수 있다.
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
	
	.player_name {
		width:200px;
		text-align:center;
	}
	
	.player_info{
		width:60px;
		text-align:center;
	}
	
	#schedule_link{
		margin:20px;
		width:500px;
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
	// 해당 팀 소속 선수들의 정보를 player 테이블에서 가져온다.
	String sql = "select * from player where team_name ='" + request.getParameter("team") + "' order by rating desc";
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery(sql);
	
	%>
	<h1>Team Squad</h1>
	<div id=go_home><a href="Main.jsp">Go Home</a></div>

	<table>
	 	<tr>
			<td class=player_name>선수 이름</td>
			<td class=player_info>포지션</td>
			<td class=player_info>나이</td>
			<td class=player_info>키</td>
			<td class=player_info>체중</td>
			<td class=player_info>골</td>
			<td class=player_info>어시</td>
			<td class=player_info>패스</td>
			<td class=player_info>평점</td>
		</tr>
	</table>
	
	<table>
		<%
		while(rs.next()){
			String player_name = rs.getString("player_name");
			String position = rs.getString("position");
			String age = rs.getString("age");
			String height = rs.getString("height");
			String weight = rs.getString("weight");
			String goal = rs.getString("goal");
			String assist = rs.getString("assist");
			String pass_success_rate = rs.getString("pass_success_rate");
			String rating = rs.getString("rating");
	 	%>
	 	<tr>
			<td class=player_name><%=player_name %></td>
			<td class=player_info><%=position %></td>
			<td class=player_info><%=age %></td>
			<td class=player_info><%=height %></td>
			<td class=player_info><%=weight %></td>
			<td class=player_info><%=goal %></td>
			<td class=player_info><%=assist %></td>
			<td class=player_info><%=pass_success_rate %></td>
			<td class=player_info><%=rating %></td>
		</tr>
		<%}%>
	</table>
	<div id=schedule_link>
		<a href="Schedule.jsp?team=<%=request.getParameter("team")%>">Team Schedule</a>
	</div>
	<%
	rs.close();
	stmt.close();
	conn.close();

	%>
</body>
</html>