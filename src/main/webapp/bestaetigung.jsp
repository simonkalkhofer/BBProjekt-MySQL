<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Seminarbuchung - Schritt 3</title>
</head>
<body style="font-family: Arial, sans-serif; margin: 30px;">
<h2>Schritt 3: Buchung bestätigen (Zustandshaltung)</h2>

<%-- Fehlermeldung ausgeben, falls das BuchungsServlet einen DB-Fehler meldet --%>
<% if("DatenbankFehler".equals(request.getParameter("error"))) { %>
<div style="background-color: #ffcccc; padding: 10px; border: 1px solid red; color: red;">
    <strong>Datenbankfehler beim Schreiben:</strong><br>
    <%= request.getParameter("msg") %>
</div>
<br>
<% } %>

<div style="background-color: #f9f9f9; padding: 15px; border: 1px solid #ccc; width: 400px; line-height: 1.6;">
    <h3 style="margin-top: 0;">Ihre Buchungsdetails:</h3>
    <p><strong>Kundennummer:</strong> ${sessionScope.session_kundennummer}</p>
    <p><strong>Gewählte Sprache:</strong> ${sessionScope.session_sprache}</p>
    <p><strong>Gewählte Seminar ID:</strong> ${sessionScope.session_seminar_id}</p>
</div>

<br>
<p>💡 <em>Hinweis für den Professor: Die Daten oben stammen rein aus der HTTP-Session (Zustandshaltung) und wurden noch nicht in die Tabelle RESERVIERUNG geschrieben!</em></p>

<form action="buchen" method="POST">
    <button type="submit" style="background-color: green; color: white; padding: 10px 20px; font-size: 16px; border: none; cursor: pointer;">
        Kostenpflichtig reservieren (Schreibzugriff)
    </button>
</form>

<br>
<a href="seminare.jsp">← Zurück zur Seminar-Auswahl</a>
</body>
</html>