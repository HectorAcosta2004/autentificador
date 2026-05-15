import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

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
      titulo: json['titulo'] ?? '',
      materia: json['materia'] ?? '',
      descripcion: json['descripcion'] ?? '',
      fecha: json['fecha_limite'] ?? '',
    );
  }
}

// Función auxiliar para obtener el token de Supabase
Map<String, String> get _headers => {
  "Content-Type": "application/json",
  "Authorization":
      "Bearer ${Supabase.instance.client.auth.currentSession?.accessToken}",
};

const String baseUrl = 'http://192.168.0.20:3000/tareas';

Future<List<Tarea>> fetchTareas() async {
  try {
    final response = await http.get(Uri.parse(baseUrl), headers: _headers);

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((t) => Tarea.fromJson(t)).toList();
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('No se pudo conectar con el servidor');
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
    Uri.parse(baseUrl),
    headers: _headers,
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
  await http.put(
    Uri.parse('$baseUrl/$id'), // Corregido: añadida la barra /
    headers: _headers,
    body: jsonEncode({
      "titulo": titulo,
      "materia": materia,
      "descripcion": descripcion,
      "fecha_limite": fechaFormateada,
    }),
  );
}

Future<void> eliminarTarea(int id) async {
  await http.delete(Uri.parse('$baseUrl/$id'), headers: _headers); // Corregido
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Tarea>> futureTareas;

  final tituloController = TextEditingController();
  final materiaController = TextEditingController();
  final descripcionController = TextEditingController();
  final fechaController = TextEditingController();

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
    setState(() {
      tituloController.text = tarea.titulo;
      materiaController.text = tarea.materia;
      descripcionController.text = tarea.descripcion;
      fechaController.text = tarea.fecha.split("T")[0];
      tareaEditandoId = tarea.id;
    });
  }

  void limpiarFormulario() {
    tituloController.clear();
    materiaController.clear();
    descripcionController.clear();
    fechaController.clear();
    tareaEditandoId = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Gestor de Tareas Académicas'),
          actions: [
            IconButton(onPressed: recargar, icon: const Icon(Icons.refresh)),
          ],
        ),
        body: Column(
          children: [
            // FORMULARIO
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  TextField(
                    controller: tituloController,
                    decoration: const InputDecoration(labelText: "Título"),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: materiaController,
                          decoration: const InputDecoration(
                            labelText: "Materia",
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: fechaController,
                          decoration: const InputDecoration(
                            labelText: "Fecha (AAAA-MM-DD)",
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: descripcionController,
                    decoration: const InputDecoration(labelText: "Descripción"),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                    ),
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
                          ? "AGREGAR TAREA"
                          : "ACTUALIZAR TAREA",
                    ),
                  ),
                  if (tareaEditandoId != null)
                    TextButton(
                      onPressed: limpiarFormulario,
                      child: const Text("Cancelar edición"),
                    ),
                ],
              ),
            ),
            // LISTA
            Expanded(
              child: FutureBuilder<List<Tarea>>(
                future: futureTareas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError)
                    return Center(child: Text('${snapshot.error}'));
                  if (!snapshot.hasData || snapshot.data!.isEmpty)
                    return const Center(
                      child: Text('No hay tareas pendientes'),
                    );

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final tarea = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          title: Text(
                            tarea.titulo,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${tarea.materia}\n${tarea.descripcion}",
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => cargarTareaParaEditar(tarea),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  await eliminarTarea(tarea.id);
                                  recargar();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
