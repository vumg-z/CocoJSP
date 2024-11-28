<!-- this script  unidades_potencia_selector.jsp will load in a selector, for the user to choose, should retrieve from the table: "loquidos concretos" -->

<!-- the user chooses  -->

<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<label for="liquido_concreto_id">Selecciona el Líquido Concreto:</label>
<select name="liquido_concreto_id" id="liquido_concreto_id" required>
    <option value="">--Selecciona--</option>
    <%
        // Renamed variables to prevent duplication
        Connection connLiquidos = null;
        PreparedStatement pstmtLiquidos = null;
        ResultSet rsLiquidos = null;

        try {
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://db:5432/mydatabase";
            String username = "myuser";
            String password = "mypassword";
            connLiquidos = DriverManager.getConnection(url, username, password);

            String sql = "SELECT lc.id, l.nombre, lc.volumen, lc.temperatura_inicial, lc.temperatura_final " +
                         "FROM liquido_concreto lc " +
                         "JOIN liquidos l ON lc.liquido_id = l.id";
            pstmtLiquidos = connLiquidos.prepareStatement(sql);
            rsLiquidos = pstmtLiquidos.executeQuery();

            DecimalFormat df = new DecimalFormat("#.##");

            while (rsLiquidos.next()) {
                int id = rsLiquidos.getInt("id");
                String liquidoNombre = rsLiquidos.getString("nombre");
                double volumen = rsLiquidos.getDouble("volumen");
                double tempInicial = rsLiquidos.getDouble("temperatura_inicial");
                double tempFinal = rsLiquidos.getDouble("temperatura_final");

                String displayText = liquidoNombre + " - Temp: " + df.format(tempInicial) + "°C to " + df.format(tempFinal) + "°C";
    %>
                <option value="<%= id %>"><%= displayText %></option>
    <%
            }
        } catch (Exception e) {
            out.println("<option value=''>Error al cargar líquidos concretos</option>");
            e.printStackTrace();
        } finally {
            if (rsLiquidos != null) try { rsLiquidos.close(); } catch (SQLException ignored) {}
            if (pstmtLiquidos != null) try { pstmtLiquidos.close(); } catch (SQLException ignored) {}
            if (connLiquidos != null) try { connLiquidos.close(); } catch (SQLException ignored) {}
        }
    %>
</select>
