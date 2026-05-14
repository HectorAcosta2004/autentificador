const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'lista_tareas'
});

db.connect(err => {
    if(err){
        console.log(err);
    }else{
        console.log("Conectado a MySQL");
    }
});

app.get('/tareas', (req, res) => {
    db.query("SELECT * FROM tareas", (err, result) => {
        if(err){
            res.status(500).json(err);
        }else{
            res.json(result);
        }
    });
});

app.post('/tareas', (req, res) => {

    const {titulo, materia, descripcion, fecha_limite} = req.body;

    const sql = "INSERT INTO tareas (titulo, materia, descripcion, fecha_limite) VALUES (?, ?, ?, ?)";

    db.query(sql, [titulo, materia, descripcion, fecha_limite], (err, result) => {
        if(err){
            res.status(500).json(err);
        }else{
            res.json({mensaje: "Tarea agregada"});
        }
    });

});

app.put('/tareas/:id', (req, res) => {

    const id = req.params.id;
    const {titulo, materia, descripcion, fecha_limite} = req.body;

    const sql = "UPDATE tareas SET titulo=?, materia=?, descripcion=?, fecha_limite=? WHERE id=?";

    db.query(sql, [titulo, materia, descripcion, fecha_limite, id], (err, result) => {

        if(err){
            console.log(err);
            res.status(500).json(err);
        }else{
            res.json({mensaje: "Tarea actualizada"});
        }

    });

});

app.delete('/tareas/:id', (req, res) => {

    const id = req.params.id;

    db.query("DELETE FROM tareas WHERE id = ?", [id], (err, result) => {
        if(err){
            res.status(500).json(err);
        }else{
            res.json({mensaje: "Tarea eliminada"});
        }
    });

});


app.listen(3000, () => {
    console.log("Servidor corriendo en puerto 3000");
});