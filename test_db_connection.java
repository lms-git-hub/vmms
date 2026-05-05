import java.sql.*;

public class test_db_connection {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/vmms?serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=utf8&useSSL=false&allowPublicKeyRetrieval=true";
        String user = "root";
        String password = "root";
        
        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            System.out.println("数据库连接成功！");
            
            // 测试查询
            String sql = "SELECT * FROM orders WHERE id = 23";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    System.out.println("查询到工单：" + rs.getInt("id") + " - " + rs.getString("numbering"));
                } else {
                    System.out.println("未查询到工单 ID 23");
                }
            }
        } catch (SQLException e) {
            System.err.println("数据库连接失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}