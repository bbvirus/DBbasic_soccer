import java.sql.*;



public class DBController {

	String driverName = "com.mysql.jdbc.Driver";
	String url = "jdbc:mysql://localhost:3306/soccer";
	String id = "root";
	String pw = "rudfurqks12";
	public Connection connection;
	Statement stmt;
	ResultSet rs;
	
	public DBController(){
		try{
			Class.forName(driverName);
		}catch(ClassNotFoundException e){
			System.out.println("no driver");
			e.printStackTrace();
		}
		
		try {
			Connection conn = DriverManager.getConnection(url, id, pw);
			connection = conn;
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void connectDatabase(){
		
		try{
			Class.forName(driverName);
		}catch(ClassNotFoundException e){
			System.out.println("no driver");
			e.printStackTrace();
		}
		
		try {
			Connection conn = DriverManager.getConnection(url, id, pw);
			connection = conn;
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public ResultSet getResult(String sql) throws SQLException{
		stmt = connection.createStatement();
		rs = stmt.executeQuery(sql);
		return rs;
	}
	
	public void close() throws SQLException{
		rs.close();
		stmt.close();
		connection.close();
	}
	
	
	
}