<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Seminarbuchung - Schritt 2</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f2f2f2; }
        tr:hover { background-color: #f5f5f5; }
        button { background-color: #008CBA; color: white; border: none; padding: 8px 12px; cursor: pointer; }
        button:hover { background-color: #007B9A; }
    </style>
</head>
<body>
<%
    // 1. Daten aus der Session holen (Zustandshaltung)
    String sprache = (String) session.getAttribute("session_sprache");
    String kundennummer = (String) session.getAttribute("session_kundennummer");

    // Sicherheits-Check: Wenn die Session abgelaufen ist, zurück zu Schritt 1
    if (sprache == null || kundennummer == null) {
        response.sendRedirect("index.jsp?error=SessionAbgelaufen");
        return;
    }

    // Falls der Benutzer ein Seminar angeklickt hat, speichern wir die ID in der Session
    String gewaehltesSeminar = request.getParameter("seminarId");
    if (gewaehltesSeminar != null) {
        session.setAttribute("session_seminar_id", gewaehltesSeminar);
        response.sendRedirect("bestaetigung.jsp");
        return;
    }
%>

<h2>Schritt 2: Verfügbare Seminare für Sprache: <%= sprache %></h2>
<p>Angemeldet als Kunde: <strong><%= kundennummer %></strong></p>

<table>
    <thead>
    <tr>
        <th>Seminar ID</th>
        <th>Kursname</th>
        <th>Datum</th>
        <th>Uhrzeit</th>
        <th>Veranstaltungsort (Adresse)</th>
        <th>Aktion</th>
    </tr>
    </thead>
    <tbody>
    <%
        // 2. Datenbank-Verbindungsdaten
        String dbUrl = "jdbc:mysql://localhost:3306/ausbildung_db";
        String dbUser = "root";
        String dbPassword = "Kajetank1"; // <-- HIER DEIN ECHTES PASSWORT EINTRAGEN

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // MySQL Treiber laden
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            // SQL-Abfrage passend zum SEMINAR-Schema
            String sql = "SELECT DISTINCT s.SeminarID, s.Kursname, s.Datum, s.Uhrzeit, s.PLZ, s.Straße, s.Hausnummer " +
                    "FROM SEMINAR s " +
                    "JOIN KANN_ABHALTEN k ON s.Kursname = k.Kurs_Name " +
                    "WHERE k.Sprache_Bez = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, sprache);
            rs = stmt.executeQuery();

            boolean hatSeminare = false;
            while (rs.next()) {
                hatSeminare = true;
                int id = rs.getInt("SeminarID");

                // Adresse sauber formatieren aus den Feldern, die in der DB existieren
                String formatierteAdresse = "PLZ: " + rs.getString("PLZ") + ", " + rs.getString("Straße") + " " + rs.getString("Hausnummer");
    %>
    <tr>
        <td><%= id %></td>
        <td><%= rs.getString("Kursname") %></td>
        <td><%= rs.getDate("Datum") %></td>
        <td><%= rs.getTime("Uhrzeit") %></td>
        <td><%= formatierteAdresse %></td>
        <td>
            <form method="POST" action="seminare.jsp" style="margin:0;">
                <input type="hidden" name="seminarId" value="<%= id %>">
                <button type="submit">Auswählen</button>
            </form>
        </td>
    </tr>
    <%
            }
            if (!hatSeminare) {
                out.println("<tr><td colspan='6' style='text-align:center; color:orange;'>Keine aktuellen Seminare für diese Sprache in der Datenbank gefunden.</td></tr>");
            }
        } catch (Exception e) {
            out.println("<tr><td colspan='6' style='color:red; font-weight:bold;'>Fehler beim Laden der Seminare: " + e.getMessage() + "</td></tr>");
            e.printStackTrace();
        } finally {
            // Ressourcen sauber schließen
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
    </tbody>
</table>

<br><br>
<a href="index.jsp">← Zurück zu Schritt 1 (Sprachauswahl)</a>
</body>
</html>