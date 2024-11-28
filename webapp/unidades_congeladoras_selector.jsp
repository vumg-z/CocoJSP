<!-- this script  unidades_congeladoras_selector.jsp will load in a selector, for the user to choose, should retrieve from the table: "refrigeradores_concretos" -->

<!-- the user chooses  -->

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<label for="unidad_id">Selecciona la Unidad de Congelación:</label>
<select name="unidad_id" id="unidad_id" required>
    <option value="">--Selecciona--</option>
    <%
        Connection connUnidades = null;
        PreparedStatement pstmtUnidades = null;
        ResultSet rsUnidades = null;

        try {
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://db:5432/mydatabase";
            String username = "myuser";
            String password = "mypassword";
            connUnidades = DriverManager.getConnection(url, username, password);

            String sql = "SELECT id, nombre, cop, potencia_entrada FROM unidad_de_congelamiento";
            pstmtUnidades = connUnidades.prepareStatement(sql);
            rsUnidades = pstmtUnidades.executeQuery();

            while (rsUnidades.next()) {
                int id = rsUnidades.getInt("id");
                String nombre = rsUnidades.getString("nombre");
                double cop = rsUnidades.getDouble("cop");
                double potenciaEntrada = rsUnidades.getDouble("potencia_entrada");

                String displayText = nombre + " - COP: " + cop + ", Potencia: " + potenciaEntrada + "kW";
    %>
                <option value="<%= id %>"><%= displayText %></option>
    <%
            }
        } catch (Exception e) {
            out.println("<option value=''>Error al cargar unidades de congelación</option>");
            e.printStackTrace();
        } finally {
            if (rsUnidades != null) try { rsUnidades.close(); } catch (SQLException ignored) {}
            if (pstmtUnidades != null) try { pstmtUnidades.close(); } catch (SQLException ignored) {}
            if (connUnidades != null) try { connUnidades.close(); } catch (SQLException ignored) {}
        }
    %>
</select>

