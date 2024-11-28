<!--  calculos_congelacion.jsp -->

<!-- pls write here -->

<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<html>
<head>
    <title>Cálculos de Congelación</title>
</head>
<body>

<%
    String unidadIdStr = request.getParameter("unidad_id");
    String liquidoConcretoIdStr = request.getParameter("liquido_concreto_id");
    String tiempoStr = request.getParameter("tiempo");

    if (unidadIdStr == null || liquidoConcretoIdStr == null || tiempoStr == null) {
%>
        <p>Error: Por favor, selecciona la unidad de congelación, el líquido concreto y el tiempo.</p>
<%
    } else {
        int unidadId = Integer.parseInt(unidadIdStr);
        int liquidoConcretoId = Integer.parseInt(liquidoConcretoIdStr);
        double tiempo = Double.parseDouble(tiempoStr);

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://db:5432/mydatabase";
            String username = "myuser";
            String password = "mypassword";
            conn = DriverManager.getConnection(url, username, password);

            // Retrieve unidad_de_congelamiento data
            String sqlUnidad = "SELECT cop, potencia_entrada FROM unidad_de_congelamiento WHERE id = ?";
            pstmt = conn.prepareStatement(sqlUnidad);
            pstmt.setInt(1, unidadId);
            rs = pstmt.executeQuery();
            double cop = 0;
            double potenciaEntrada = 0;
            if (rs.next()) {
                cop = rs.getDouble("cop");
                potenciaEntrada = rs.getDouble("potencia_entrada");
            }
            rs.close();
            pstmt.close();

            // Retrieve liquido_concreto and liquidos data
            String sqlLiquido = "SELECT lc.temperatura_inicial, lc.temperatura_final, l.densidad, l.calor_latente, l.calor_especifico " +
                                "FROM liquido_concreto lc " +
                                "JOIN liquidos l ON lc.liquido_id = l.id " +
                                "WHERE lc.id = ?";
            pstmt = conn.prepareStatement(sqlLiquido);
            pstmt.setInt(1, liquidoConcretoId);
            rs = pstmt.executeQuery();
            double densidad = 0;
            double calorLatente = 0;
            double tempInicial = 0;
            double tempFinal = 0;
            if (rs.next()) {
                tempInicial = rs.getDouble("temperatura_inicial");
                tempFinal = rs.getDouble("temperatura_final");
                densidad = rs.getDouble("densidad");
                calorLatente = rs.getDouble("calor_latente");
            }
            rs.close();
            pstmt.close();

            // Perform calculations
            double W = potenciaEntrada * 1000 * tiempo * 3600; // W in Joules
            double Q_L = cop * W; // Heat removed in Joules
            double masaProducida = Q_L / calorLatente; // kg
            double volumenProducido = masaProducida / densidad; // m³
            double energiaConsumida = W / 3600000; // kWh

            // Insert calculation into calculos_congelacion
            String sqlInsert = "INSERT INTO calculos_congelacion " +
                               "(unidad_id, liquido_concreto_id, tiempo, volumen_producido, masa_producida, energia_consumida, ql) " +
                               "VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sqlInsert);
            pstmt.setInt(1, unidadId);
            pstmt.setInt(2, liquidoConcretoId);
            pstmt.setDouble(3, tiempo);
            pstmt.setDouble(4, volumenProducido * 1000); // liters
            pstmt.setDouble(5, masaProducida);
            pstmt.setDouble(6, energiaConsumida);
            pstmt.setDouble(7, Q_L);
            pstmt.executeUpdate();
            pstmt.close();

            // Display results
            DecimalFormat df = new DecimalFormat("#.##");
%>
            <h2>Resultados del Cálculo de Congelación</h2>
            <p>Unidad de Congelación ID: <%= unidadId %></p>
            <p>Líquido Concreto ID: <%= liquidoConcretoId %></p>
            <p>Tiempo: <%= df.format(tiempo) %> horas</p>
            <p>Energía Consumida: <%= df.format(energiaConsumida) %> kWh</p>
            <p>Calor Removido (Q<sub>L</sub>): <%= df.format(Q_L) %> Joules</p>
            <p>Masa de hielo producida: <%= df.format(masaProducida) %> kg</p>
            <p>Volumen de hielo producido: <%= df.format(volumenProducido * 1000) %> litros</p>
<%
        } catch (Exception e) {
            out.println("<p>Error al realizar el cálculo: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    }
%>

</body>
</html>