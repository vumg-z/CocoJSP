package com.fisica.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/createUnidadDeCongelamiento")
public class CreateUnidadDeCongelamientoServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:postgresql://db:5432/mydatabase";
    private static final String DB_USERNAME = "myuser";
    private static final String DB_PASSWORD = "mypassword";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form parameters
        String nombre = request.getParameter("nombre");
        String copStr = request.getParameter("cop");
        String potenciaEntradaStr = request.getParameter("potencia_entrada");
        String descripcion = request.getParameter("descripcion");

        // Validate input
        if (nombre == null || nombre.trim().isEmpty() ||
            copStr == null || copStr.trim().isEmpty() ||
            potenciaEntradaStr == null || potenciaEntradaStr.trim().isEmpty() ||
            descripcion == null || descripcion.trim().isEmpty()) {
            response.sendRedirect("/create/error.jsp?message=Todos los campos son obligatorios.");
            return;
        }

        double cop;
        double potenciaEntrada;

        try {
            cop = Double.parseDouble(copStr);
            potenciaEntrada = Double.parseDouble(potenciaEntradaStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("/create/error.jsp?message=COP y Potencia de Entrada deben ser números válidos.");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Load PostgreSQL JDBC Driver
            Class.forName("org.postgresql.Driver");

            // Establish connection
            conn = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);

            // Insert into unidad_de_congelamiento table
            String sql = "INSERT INTO unidad_de_congelamiento (nombre, cop, potencia_entrada, descripcion) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nombre);
            pstmt.setDouble(2, cop);
            pstmt.setDouble(3, potenciaEntrada);
            pstmt.setString(4, descripcion);

            int rowsInserted = pstmt.executeUpdate();

            if (rowsInserted > 0) {
                response.sendRedirect("/create/success.jsp?entity=Unidad de Congelamiento");
            } else {
                response.sendRedirect("/create/error.jsp?message=No se pudo crear la unidad de congelamiento.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/create/error.jsp?message=Error en el servidor: " + e.getMessage());
        } finally {
            // Close resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception ignored) {}
        }
    }
}
