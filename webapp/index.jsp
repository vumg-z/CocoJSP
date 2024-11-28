<%@ page contentType="text/html; charset=UTF-8" %>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Cálculo de Congelación</title>
</head>
<body>

  <h1>Cálculo de Congelación</h1>

  <form action="calculos_congelacion.jsp" method="post">

    <%@ include file="unidades_congeladoras_selector.jsp" %>

    <%@ include file="liquidos_selector.jsp" %>

    <label for="tiempo">Tiempo (en horas):</label>
    <input type="number" name="tiempo" id="tiempo" step="any" required>

    <br><br>
    <input type="submit" value="Calcular">
  </form>

</body>
</html>
