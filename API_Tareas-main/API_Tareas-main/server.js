const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const { createClient } = require('@supabase/supabase-js');

const app = express();
app.use(cors());
app.use(express.json());

// 1. CONFIGURACIÓN DE SUPABASE
// Reemplaza con tus credenciales de Supabase Dashboard -> Project Settings -> API
const SUPABASE_URL = 'https://edbjqkekzaimfrmdrulm.supabase.co.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_Q9s_rzciTf9Q5ReywolQAg_VLi48-ot';
const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// 2. CONFIGURACIÓN DE MYSQL
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',      // Tu usuario de MySQL
    password: '',      // Tu contraseña de MySQL
    database: 'lista_tareas' // Nombre de tu base de datos
});

db.connect((err) => {
    if (err) {
        console.error('Error conectando a la base de datos:', err);
        return;
    }
    console.log('Conectado a la base de datos MySQL');
});

// Este código verifica que el token que envía Flutter sea válido en Supabase
const authenticateToken = async (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Formato: Bearer TOKEN

    if (!token) {
        return res.status(401).json({ error: 'Acceso denegado. Token no proporcionado.' });
    }

    try {
        const { data: { user }, error } = await supabase.auth.getUser(token);

        if (error || !user) {
            return res.status(403).json({ error: 'Sesión inválida o expirada.' });
        }

        req.user = user; // Guardamos el usuario en el request para usar su ID si es necesario
        next();
    } catch (e) {
        res.status(500).json({ error: 'Error interno al validar sesión.' });
    }
};


// Obtener todas las tareas
app.get('/tareas', authenticateToken, (req, res) => {
    const query = 'SELECT * FROM tareas';
    db.query(query, (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

// Agregar una nueva tarea
app.post('/tareas', authenticateToken, (req, res) => {
    const { titulo, descripcion } = req.body;
    const query = 'INSERT INTO tareas (titulo, descripcion) VALUES (?, ?)';
    db.query(query, [titulo, descripcion], (err, result) => {
        if (err) return res.status(500).send(err);
        res.json({ id: result.insertId, titulo, descripcion });
    });
});

// Eliminar una tarea
app.delete('/tareas/:id', authenticateToken, (req, res) => {
    const { id } = req.params;
    const query = 'DELETE FROM tareas WHERE id = ?';
    db.query(query, [id], (err, result) => {
        if (err) return res.status(500).send(err);
        res.json({ message: 'Tarea eliminada correctamente' });
    });
});

// 5. INICIO DEL SERVIDOR
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor API corriendo en http://localhost:${PORT}`);
});