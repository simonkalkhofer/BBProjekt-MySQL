<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Seminarbuchung - Schritt 1</title>
</head>
<body>
<h2>Schritt 1: Kundennummer & Kurssprache wählen</h2>

<%-- Einfache Fehlermeldung anzeigen, falls die Validierung fehlschlägt --%>
<% if("EingabeFehlt".equals(request.getParameter("error"))) { %>
<p style="color:red;">Bitte geben Sie eine Kundennummer ein und wählen Sie eine Sprache!</p>
<% } else if("SessionAbgelaufen".equals(request.getParameter("error"))) { %>
<p style="color:red;">Ihre Sitzung ist abgelaufen. Bitte starten Sie von vorn.</p>
<% } %>

<%-- Das Formular schickt die Daten an das Servlet --%>
<form action="spracheWaehlen" method="POST">
    <label for="kNr">Ihre Kundennummer:</label><br>
    <input type="text" id="kNr" name="kundennummer" placeholder="z.B. KD-9901" required><br><br>

    <label for="lang">Gewünschte Seminarsprache:</label><br>
    <select id="lang" name="sprache" required>
        <option value="">-- Bitte wählen --</option>
        <option value="Deutsch">Deutsch</option>
        <option value="Englisch">Englisch</option>
    </select><br><br>

    <button type="submit">Weiter zu den Seminaren</button>
</form>
</body>
</html>