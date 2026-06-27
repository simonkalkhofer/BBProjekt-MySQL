package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/spracheWaehlen")
public class SprachAuswahlServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Daten aus dem Formular der index.jsp auslesen
        String kundennummer = request.getParameter("kundennummer");
        String sprache = request.getParameter("sprache");

        // Validierung: Prüfen, ob die Felder ausgefüllt wurden
        if (kundennummer == null || kundennummer.trim().isEmpty() ||
                sprache == null || sprache.trim().isEmpty()) {

            // Wenn etwas fehlt, zurück zur Startseite mit einer Fehlermeldung
            response.sendRedirect("index.jsp?error=EingabeFehlt");
            return;
        }

        // 2. HTTP-Session holen oder neu erstellen
        // Hier beginnt die geforderte Zustandshaltung für die darauffolgenden Seiten
        HttpSession session = request.getSession(true);

        // 3. Die Daten in die Session schreiben
        // Diese Daten bleiben nun so lange aktiv, bis der Browser geschlossen oder die Session beendet wird
        session.setAttribute("session_kundennummer", kundennummer.trim());
        session.setAttribute("session_sprache", sprache.trim());

        // 4. Weiterleitung zu Schritt 2 (seminare.jsp)
        // Auf dieser Seite werden dann die passenden Seminare geladen
        response.sendRedirect("seminare.jsp");
    }
}