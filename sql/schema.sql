CREATE TABLE unidad_de_congelamiento (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    cop DOUBLE PRECISION,            -- Coefficient of Performance
    potencia_entrada DOUBLE PRECISION, -- Power input in kW
    descripcion TEXT
);

CREATE TABLE refrigeradores_concretos (
    id SERIAL PRIMARY KEY,
    unidad_id INT NOT NULL,           -- Foreign key to unidad_de_congelamiento
    marca VARCHAR(255) NOT NULL,      -- Brand, e.g., Samsung
    modelo VARCHAR(255),
    capacidad DOUBLE PRECISION,       -- Capacity in liters
    dimensiones VARCHAR(255),         -- Dimensions (e.g., "60x60x180 cm")
    consumo_energetico DOUBLE PRECISION, -- Energy consumption in kWh
    FOREIGN KEY (unidad_id) REFERENCES unidad_de_congelamiento(id)
);

CREATE TABLE liquidos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,     -- Name of the liquid
    densidad DOUBLE PRECISION,        -- Density in kg/m³
    calor_latente DOUBLE PRECISION,   -- Latent heat in J/kg
    calor_especifico DOUBLE PRECISION -- Specific heat capacity in J/(kg·K)
);

CREATE TABLE liquido_concreto (
    id SERIAL PRIMARY KEY,
    liquido_id INT NOT NULL,          -- Foreign key to liquidos
    volumen DOUBLE PRECISION NOT NULL, -- Volume in liters
    temperatura_inicial DOUBLE PRECISION, -- Initial temperature in °C
    temperatura_final DOUBLE PRECISION,   -- Final temperature in °C
    FOREIGN KEY (liquido_id) REFERENCES liquidos(id)
);

CREATE TABLE calculos_congelacion (
    id SERIAL PRIMARY KEY,
    unidad_id INT NOT NULL,                 -- Foreign key to unidad_de_congelamiento
    liquido_concreto_id INT NOT NULL,       -- Foreign key to liquido_concreto
    tiempo DOUBLE PRECISION,                -- Time in hours
    volumen_producido DOUBLE PRECISION,     -- Volume of ice produced in liters
    masa_producida DOUBLE PRECISION,        -- Mass of ice produced in kg
    energia_consumida DOUBLE PRECISION,     -- Energy consumed in kWh
    ql DOUBLE PRECISION,                    -- Heat removed in Joules
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (unidad_id) REFERENCES unidad_de_congelamiento(id),
    FOREIGN KEY (liquido_concreto_id) REFERENCES liquido_concreto(id)
);

-- Insert initial data
INSERT INTO unidad_de_congelamiento (nombre, cop, potencia_entrada, descripcion)
VALUES ('Congelador Estandar', 7, 1, 'Congelador con COP de 7 y potencia de entrada de 1kW');

INSERT INTO liquidos (nombre, densidad, calor_latente, calor_especifico)
VALUES ('Agua', 1000, 334000, 4186);

INSERT INTO liquido_concreto (liquido_id, volumen, temperatura_inicial, temperatura_final)
VALUES (1, 0, 0, 0);  -- Volume is zero since it's to be calculated
