CREATE TABLE unidad_de_congelamiento (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    cop DOUBLE PRECISION,            
    potencia_entrada DOUBLE PRECISION, 
    descripcion TEXT
);

CREATE TABLE refrigeradores_concretos (
    id SERIAL PRIMARY KEY,
    unidad_id INT NOT NULL,          
    marca VARCHAR(255) NOT NULL,      
    modelo VARCHAR(255),
    capacidad DOUBLE PRECISION,       
    dimensiones VARCHAR(255),         
    consumo_energetico DOUBLE PRECISION, 
    FOREIGN KEY (unidad_id) REFERENCES unidad_de_congelamiento(id)
);

-- //  liquidos missing punto de congelacion?

CREATE TABLE liquidos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,    
    densidad DOUBLE PRECISION,        
    calor_latente DOUBLE PRECISION,   
    calor_especifico DOUBLE PRECISION 
);

CREATE TABLE liquido_concreto (
    id SERIAL PRIMARY KEY,
    liquido_id INT NOT NULL,          
    volumen DOUBLE PRECISION NOT NULL, 
    temperatura_inicial DOUBLE PRECISION, 
    temperatura_final DOUBLE PRECISION,   
    FOREIGN KEY (liquido_id) REFERENCES liquidos(id)
);

CREATE TABLE calculos_congelacion (
    id SERIAL PRIMARY KEY,
    unidad_id INT NOT NULL,                 
    liquido_concreto_id INT NOT NULL,       
    tiempo DOUBLE PRECISION,                
    volumen_producido DOUBLE PRECISION,     
    masa_producida DOUBLE PRECISION,       
    energia_consumida DOUBLE PRECISION,     
    ql DOUBLE PRECISION,                   
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (unidad_id) REFERENCES unidad_de_congelamiento(id),
    FOREIGN KEY (liquido_concreto_id) REFERENCES liquido_concreto(id)
);

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, 
    role VARCHAR(50) NOT NULL -
);

INSERT INTO usuarios (username, password, role) VALUES
('admin', 'admin', 'admin'),
('user', 'user', 'user');

INSERT INTO unidad_de_congelamiento (nombre, cop, potencia_entrada, descripcion)
VALUES ('Congelador Estandar', 7, 1, 'Congelador con COP de 7 y potencia de entrada de 1kW');

INSERT INTO liquidos (nombre, densidad, calor_latente, calor_especifico)
VALUES ('Agua', 1000, 334000, 4186);

INSERT INTO liquido_concreto (liquido_id, volumen, temperatura_inicial, temperatura_final)
VALUES (1, 0, 0, 0);  

INSERT INTO liquido_concreto (liquido_id, volumen, temperatura_inicial, temperatura_final)
VALUES (1, 0, 20, 0);  
