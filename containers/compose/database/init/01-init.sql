CREATE TABLE IF NOT EXISTS projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO projects (name, description) VALUES 
('DevOps Lab', 'Meu primeiro projeto DevOps'),
('Docker Setup', 'Configuração inicial');