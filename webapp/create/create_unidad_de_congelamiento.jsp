<%@ page contentType="text/html; charset=UTF-8" %>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Crear Unidad de Congelamiento</title>
</head>
<body>
    <h1>Crear Unidad de Congelamiento</h1>

    <form action="/createUnidadDeCongelamiento" method="post">
        <label for="nombre">Nombre:</label>
        <input type="text" name="nombre" id="nombre" required>

        <label for="cop">Coeficiente de Rendimiento (COP):</label>
        <input type="number" name="cop" id="cop" step="0.01" required>

        <label for="potencia_entrada">Potencia de Entrada (kW):</label>
        <input type="number" name="potencia_entrada" id="potencia_entrada" step="0.01" required>

        <label for="descripcion">Descripción:</label>
        <textarea name="descripcion" id="descripcion" rows="4" required></textarea>

        <button type="submit">Crear Unidad de Congelamiento</button>
    </form>

    <p><a href="/index.jsp">Volver al Inicio</a></p>
</body>
</html>
