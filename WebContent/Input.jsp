<!--
	2014. 1. 9.
	작성자 : 박세훈
	
	경기 결과를 입력할 수 있는 페이지이다.
	해당 경기를 치른 팀 선수들의 정보를 입력하면 DB의 match_player_result 테이블에 저장된다.
-->
<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
	#go_home{
		color:black;
		text-decoration:none;
		margin-left:40px;
		margin-top:10px;
		margin-bottom:15px;
	}
	
	.player_name {
		width:200px;
		text-align:center;
	}
	
	.team_name{
		width:200px;
		text-align:center;
	}
	.box{
		width:55px;
		text-align:center;
	}
	
	#submit{
		margin-top:15px;
		margin-left:300px;
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
	String sql = "select * from player as p inner join match_schedule as ms on ms.home_team = p.team_name or ms.away_team = p.team_name where ms.match_id = " + request.getParameter("match_id") + " order by p.team_name";
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery(sql);
	

	%>
	<h1>Insert Match Result</h1>
	<div id=go_home><a href="Main.jsp">Go Home</a></div>
	
	<table>
	 	<tr>
			<td class=team_name>팀 이름</td>
			<td class=player_name>선수 이름</td>
			<td class=box>골</td>
			<td class=box>어시</td>
			<td class=box>psr</td>
			<td class=box>평점</td>
		</tr>
	</table>
	
	<form action="InsertDB.jsp" method="POST">
		<table>
			<%
			while(rs.next()){
				int player_id = rs.getInt("player_id");
				String team_name = rs.getString("team_name");
				String player_name = rs.getString("player_name");
		 	%>
		 	<tr>
				<td class=team_name><%=team_name %></td>
				<td class=player_name><%=player_name %></td>
				<td><input type=text name=goal<%=player_id %> size=3px value="0"></input></td>
				<td><input type=text name=assist<%=player_id %> size=3px value="0"></input></td>
				<td><input type=text name=pass_success_rate<%=player_id %> size=3px value="0"></input></td>
				<td><input type=text name=rating<%=player_id %> size=3px value="0"></input></td>
			</tr>
			<%}%>
		</table>
		<input type=hidden name=match_id value=<%=request.getParameter("match_id") %>></input>
		<input type=submit value=send id=submit></input>
	</form>
	<%
	rs.close();
	stmt.close();
	conn.close();
	%>
</body>
</html>