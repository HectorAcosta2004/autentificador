import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class Tarea {
  final int id;
  final String titulo;
  final String materia;
  final String descripcion;
  final String fecha;

  const Tarea({
    required this.id,
    required this.titulo,
    required this.materia,
    required this.descripcion,
    required this.fecha,
  });

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['id'],
      titulo: json['titulo'],
      materia: json['materia'],
      descripcion: json['descripcion'],
      fecha: json['fecha_limite'],
    );
  }
}

Future<List<Tarea>> fetchTareas() async {
  final response = await http.get(Uri.parse('http://localhost:3000/tareas'));

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((t) => Tarea.fromJson(t)).toList();
  } else {
    throw Exception('Error al cargar tareas');
  }
}

Future<void> agregarTarea(
  String titulo,
  String materia,
  String descripcion,
  String fecha,
) async {
  String fechaFormateada = fecha.split("T")[0];
  await http.post(
    Uri.parse('http://localhost:3000/tareas'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "titulo": titulo,
      "materia": materia,
      "descripcion": descripcion,
      "fecha_limite": fechaFormateada,
    }),
  );
}

Future<void> editarTarea(
  int id,
  String titulo,
  String materia,
  String descripcion,
  String fecha,
) async {
  String fechaFormateada = fecha.split("T")[0];

  final response = await http.put(
    Uri.parse('http://localhost:3000/tareas$id'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "titulo": titulo,
      "materia": materia,
      "descripcion": descripcion,
      "fecha_limite": fechaFormateada,
    }),
  );
  print(response.body);
}

Future<void> eliminarTarea(int id) async {
  await http.delete(Uri.parse('http://localhost:3000/tareas$id'));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Tarea>> futureTareas;

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController materiaController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();

  int? tareaEditandoId;

  @override
  void initState() {
    super.initState();
    futureTareas = fetchTareas();
  }

  void recargar() {
    setState(() {
      futureTareas = fetchTareas();
    });
  }

  void cargarTareaParaEditar(Tarea tarea) {
    tituloController.text = tarea.titulo;
    materiaController.text = tarea.materia;
    descripcionController.text = tarea.descripcion;
    fechaController.text = tarea.fecha;

    tareaEditandoId = tarea.id;

    setState(() {});
  }

  void limpiarFormulario() {
    tituloController.clear();
    materiaController.clear();
    descripcionController.clear();
    fechaController.clear();
    tareaEditandoId = null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de tareas',
      home: Scaffold(
        appBar: AppBar(title: const Text('Lista de tareas')),
        body: Center(
          child: FutureBuilder<List<Tarea>>(
            future: futureTareas,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final tareas = snapshot.data!;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextField(
                          controller: tituloController,
                          decoration: const InputDecoration(
                            labelText: "Título de la tarea",
                          ),
                        ),

                        TextField(
                          controller: materiaController,
                          decoration: const InputDecoration(
                            labelText: "Materia",
                          ),
                        ),

                        TextField(
                          controller: descripcionController,
                          decoration: const InputDecoration(
                            labelText: "Descripción",
                          ),
                        ),

                        TextField(
                          controller: fechaController,
                          decoration: const InputDecoration(
                            labelText: "Fecha de entrega",
                          ),
                        ),

                        const SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: () async {
                            if (tareaEditandoId == null) {
                              await agregarTarea(
                                tituloController.text,
                                materiaController.text,
                                descripcionController.text,
                                fechaController.text,
                              );
                            } else {
                              await editarTarea(
                                tareaEditandoId!,
                                tituloController.text,
                                materiaController.text,
                                descripcionController.text,
                                fechaController.text,
                              );
                            }

                            limpiarFormulario();
                            recargar();
                          },

                          child: Text(
                            tareaEditandoId == null
                                ? "Agregar tarea"
                                : "Actualizar tarea",
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: tareas.length,
                      itemBuilder: (context, index) {
                        final tarea = tareas[index];

                        return ListTile(
                          title: Text(tarea.titulo),
                          subtitle: Text(
                            "${tarea.materia} - ${tarea.fecha.split("T")[0]}",
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  cargarTareaParaEditar(tarea);
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await eliminarTarea(tarea.id);
                                  recargar();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
