import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? filePath;

  Future<void> pickFile() async {
    // Abrir el selector de archivos
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        filePath = result.files.single.path; // Ruta del archivo seleccionado
      });
    } else {
      // Usuario canceló la selección
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No seleccionaste ningún archivo")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lector de PDFs"),
      ),
      body: Center(
        child: filePath == null
            ? Text("Selecciona un archivo PDF")
            : ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewerPage(filePath: filePath!),
                    ),
                  );
                },
                child: Text("Abrir PDF"),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFile,
        child: Icon(Icons.file_open),
        tooltip: "Seleccionar PDF",
      ),
    );
  }
}

class PDFViewerPage extends StatelessWidget {
  final String filePath;

  PDFViewerPage({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visualizador de PDF"),
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: true,
      ),
    );
  }
}
