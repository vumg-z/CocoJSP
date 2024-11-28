<%-- unidades_potencia_selector.jsp --%>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page contentType="text/html; charset=UTF-8" %>


<label for="liquido_concreto_id">Selecciona el Líquido Concreto:</label>
<select name="liquido_concreto_id" id="liquido_concreto_id" required>
    <option value="">--Selecciona--</option>
    <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Load PostgreSQL JDBC driver
            Class.forName("org.postgresql.Driver");

            // Database connection parameters
            String url = "jdbc:postgresql://db:5432/mydatabase"; // 'db' is the service name in docker-compose
            String username = "myuser";
            String password = "mypassword";

            // Establish connection
            conn = DriverManager.getConnection(url, username, password);

            // Query to retrieve liquido_concreto
            String sql = "SELECT lc.id, l.nombre, lc.volumen, lc.temperatura_inicial, lc.temperatura_final " +
                         "FROM liquido_concreto lc " +
                         "JOIN liquidos l ON lc.liquido_id = l.id";

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            // Prepare a formatter for temperatures
            DecimalFormat df = new DecimalFormat("#.##");

            // Populate the dropdown
            while (rs.next()) {
                int id = rs.getInt("id");
                String liquidoNombre = rs.getString("nombre");
                double volumen = rs.getDouble("volumen");
                double tempInicial = rs.getDouble("temperatura_inicial");
                double tempFinal = rs.getDouble("temperatura_final");

                // Format the display text
                String displayText = liquidoNombre + " - Temp: " + df.format(tempInicial) + "°C to " + df.format(tempFinal) + "°C";
    %>
                <option value="<%= id %>"><%= displayText %></option>
    <%
            }
        } catch (Exception e) {
            out.println("<option value=''>Error al cargar líquidos concretos</option>");
            e.printStackTrace();
        } finally {
            // Close resources
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    %>
</select>
