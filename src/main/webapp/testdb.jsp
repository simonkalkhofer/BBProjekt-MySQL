<%@ page import="java.sql.*" %>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/ausbildung",
                "root",
                "passme"
        );

        out.println("✅ DB VERBINDUNG FUNKTIONIERT!");

        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM Person");

        if (rs.next()) {
            out.println("<br>Datensätze in Person: " + rs.getInt(1));
        }

        con.close();

    } catch (Exception e) {
        out.println("❌ FEHLER: " + e.getMessage());
    }
%>