<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.*, javax.servlet.http.*" %>
<%
    // Variables para mensajes de error
    String errorMessage = null;

    // Obtener la acción del formulario
    String action = request.getParameter("action");

    // Manejar el cierre de sesión
    if ("logout".equals(action)) {
        session.invalidate();
        response.sendRedirect("index.jsp");
        return;
    }

    // Manejar el inicio de sesión
    if ("login".equals(action)) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            errorMessage = "Por favor, ingrese usuario y contraseña.";
        } else {
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                // Configurar la conexión a la base de datos
                // Cambia los parámetros según tu configuración
                Class.forName("org.postgresql.Driver");
                String dbURL = "jdbc:postgresql://db:5432/mydatabase";
                String dbUser = "myuser";
                String dbPassword = "mypassword";
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                String sql = "SELECT username, role FROM usuarios WHERE username = ? AND password = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, password); // En producción, utiliza contraseñas hasheadas
                rs = ps.executeQuery();

                if (rs.next()) {
                    // Autenticación exitosa
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("role", rs.getString("role"));
                    response.sendRedirect("index.jsp");
                    return;
                } else {
                    // Credenciales inválidas
                    errorMessage = "Usuario o contraseña incorrectos.";
                }

            } catch (Exception e) {
                e.printStackTrace();
                errorMessage = "Error en el servidor. Por favor, inténtalo más tarde.";
            } finally {
                // Cerrar recursos
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        }
    }

    // Verificar si el usuario está autenticado
    String loggedInUser = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("role");
%>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Cálculo de Congelación</title>
  <link rel="stylesheet" href="./css/styles.css">
</head>
<body>

  <header>
    <h1>Cálculo de Congelación</h1>
    <nav>
      <% if (loggedInUser != null) { %>
        <p>Bienvenido, <strong><%= loggedInUser %></strong> | 
          <a href="index.jsp?action=logout">Cerrar Sesión</a>
        </p>
      <% } else { %>
        <p><a href="#login">Iniciar Sesión</a></p>
      <% } %>
    </nav>
  </header>

  <main>

    <% if (loggedInUser == null) { %>
      <!-- Formulario de inicio de sesión -->
      <section id="login">
        <h2>Iniciar Sesión</h2>
        <% if (errorMessage != null) { %>
          <p style="color:red;"><%= errorMessage %></p>
        <% } %>
        <form action="index.jsp" method="post">
          <input type="hidden" name="action" value="login">
          <div>
            <label for="username">Usuario:</label>
            <input type="text" name="username" id="username" required>
          </div>
          <div>
            <label for="password">Contraseña:</label>
            <input type="password" name="password" id="password" required>
          </div>
          <div>
            <input type="submit" value="Ingresar">
          </div>
        </form>
      </section>
    <% } else { %>
      <% if ("admin".equals(userRole)) { %>
        <!-- Sección para administradores -->
        <section class="create-section">
          <%@ include file="create/create_liquido_concreto.jsp" %>
        </section>
        <section class="create-section">
          <%@ include file="create/create_unidad_de_congelamiento.jsp" %>
        </section>
      <% } %>

      <% if ("admin".equals(userRole) || "user".equals(userRole)) { %>
        <!-- Sección de cálculo disponible para todos los usuarios autenticados -->
        <section class="calculation-section">
          <form action="calculos_congelacion.jsp" method="post">
            <%@ include file="unidades_congeladoras_selector.jsp" %>
            <%@ include file="liquidos_selector.jsp" %>
            <div>
              <label for="tiempo">Tiempo (en horas):</label>
              <input type="number" name="tiempo" id="tiempo" step="any" required>
            </div>
            <div>
              <input type="submit" value="Calcular">
            </div>
          </form>
        </section>
      <% } %>
    <% } %>

  </main>

</body>
</html>
