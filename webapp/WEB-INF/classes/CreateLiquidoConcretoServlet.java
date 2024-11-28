import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/createLiquidoConcreto")
public class CreateLiquidoConcretoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form data
        String liquidoIdStr = request.getParameter("liquido_id");
        String volumenStr = request.getParameter("volumen");
        String temperaturaInicialStr = request.getParameter("temperatura_inicial");
        String temperaturaFinalStr = request.getParameter("temperatura_final");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Convert form data to appropriate types
            int liquidoId = Integer.parseInt(liquidoIdStr);
            double volumen = Double.parseDouble(volumenStr);
            double temperaturaInicial = Double.parseDouble(temperaturaInicialStr);
            double temperaturaFinal = Double.parseDouble(temperaturaFinalStr);

            // Database connection
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://db:5432/mydatabase";
            String username = "myuser";
            String password = "mypassword";
            conn = DriverManager.getConnection(url, username, password);

            // Insert into liquido_concreto table
            String sql = "INSERT INTO liquido_concreto (liquido_id, volumen, temperatura_inicial, temperatura_final) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, liquidoId);
            pstmt.setDouble(2, volumen);
            pstmt.setDouble(3, temperaturaInicial);
            pstmt.setDouble(4, temperaturaFinal);
            pstmt.executeUpdate();

            // Redirect to a success page or back to the form
            response.sendRedirect("/create/success.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/create/error.jsp");
        } finally {
            // Close resources
            if (pstmt != null) try { pstmt.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    }
}
