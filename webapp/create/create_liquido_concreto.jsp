<%-- create_liquido_concreto.jsp this is inside webapp/create/--%>


<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Crear Líquido Concreto</title>
</head>
<body>
    <h1>Crear Líquido Concreto</h1>

    <form action="/createLiquidoConcreto" method="post">
        <%-- // servlet form action  --%>

        <label for="liquido_id">Selecciona el Líquido:</label>
        <select name="liquido_id" id="liquido_id" required>
            <option value="">--Selecciona--</option>
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("org.postgresql.Driver");
                    String url = "jdbc:postgresql://db:5432/mydatabase";
                    String username = "myuser";
                    String password = "mypassword";
                    conn = DriverManager.getConnection(url, username, password);

                    String sql = "SELECT id, nombre FROM liquidos";
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String nombre = rs.getString("nombre");
            %>
                        <option value="<%= id %>"><%= nombre %></option>
            <%
                    }
                } catch (Exception e) {
                    out.println("<option value=''>Error al cargar líquidos</option>");
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
            %>
        </select>

        <br><br>

        <label for="volumen">Volumen (en litros):</label>
        <input type="number" name="volumen" id="volumen" step="any" required>

        <br><br>

        <label for="temperatura_inicial">Temperatura Inicial (°C):</label>
        <input type="number" name="temperatura_inicial" id="temperatura_inicial" step="any" required>

        <br><br>

        <label for="temperatura_final">Temperatura Final (°C):</label>
        <input type="number" name="temperatura_final" id="temperatura_final" step="any" required>

        <br><br>

        <button type="submit">Crear Líquido Concreto</button>
    </form>
</body>
</html>

