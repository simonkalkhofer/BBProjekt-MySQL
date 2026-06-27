package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/buchen")
public class BuchungsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Datenbank-Verbindungsdaten
    private static final String DB_URL = "jdbc:mysql://localhost:3306/ausbildung_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Kajetank1"; // <-- HIER DEIN PASSWORT EINTRAGEN

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Zugriff auf die bestehende Session (Zustandshaltung)
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("session_kundennummer") == null) {
            // Falls keine Session existiert oder abgelaufen ist, zurück zum Start
            response.sendRedirect("index.jsp?error=SessionAbgelaufen");
            return;
        }

        // 2. Daten aus der Session auslesen
        String kNummer = (String) session.getAttribute("session_kundennummer");
        String seminarIdStr = (String) session.getAttribute("session_seminar_id");

        // JDBC-Treiber explizit laden (wichtig für Tomcat)
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("MySQL JDBC Treiber nicht gefunden!", e);
        }

        Connection conn = null;
        PreparedStatement stmtGetSvnr = null;
        PreparedStatement stmtInsert = null;
        ResultSet rs = null;

        try {
            // Verbindung zur MySQL-Datenbank herstellen
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // 3. DATENBANK-LESEZUGRIFF: SVNr über die Kundennummer ermitteln
            // Da RESERVIERUNG die SVNr braucht, wir in der Session aber die Kundennummer haben
            String sqlGetSvnr = "SELECT SVNr FROM TEILNEHMER WHERE Kundennummer = ?";
            stmtGetSvnr = conn.prepareStatement(sqlGetSvnr);
            stmtGetSvnr.setString(1, kNummer);
            rs = stmtGetSvnr.executeQuery();

            String svNr = null;
            if (rs.next()) {
                svNr = rs.getString("SVNr");
            }

            if (svNr == null) {
                // Sicherheitscheck, falls eine ungültige Kundennummer eingegeben wurde
                response.sendRedirect("index.jsp?error=UngueltigeKunde");
                return;
            }

            // 4. DATENBANK-SCHREIBZUGRIFF: Eintrag in RESERVIERUNG erstellen
            String sqlInsert = "INSERT INTO RESERVIERUNG (TeilnehmerSVNr, SeminarID) VALUES (?, ?)";
            stmtInsert = conn.prepareStatement(sqlInsert);
            stmtInsert.setString(1, svNr);
            stmtInsert.setInt(2, Integer.parseInt(seminarIdStr));

            // Ausführen des Inserts
            stmtInsert.executeUpdate();

            // 5. Session aufräumen (die Buchungsdaten löschen, damit man nicht doppelt bucht)
            session.removeAttribute("session_seminar_id");

            // Weiterleitung zur Erfolgsseite
            response.sendRedirect("erfolg.jsp");

        } catch (SQLException e) {
            // Fehlerbehandlung: Falls z.B. Constraints verletzt werden (Ungültige Daten-Test!)
            e.printStackTrace();
            response.sendRedirect("bestaetigung.jsp?error=DatenbankFehler&msg=" + e.getMessage());
        } finally {
            // Ressourcen sauber schließen
            try { if (rs != null) rs.close(); } catch (SQLException e) { }
            try { if (stmtGetSvnr != null) stmtGetSvnr.close(); } catch (SQLException e) { }
            try { if (stmtInsert != null) stmtInsert.close(); } catch (SQLException e) { }
            try { if (conn != null) conn.close(); } catch (SQLException e) { }
        }
    }
}