import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart';



class FotoPage extends StatefulWidget {
  @override
  _FotoPageState createState() => _FotoPageState();
}

class _FotoPageState extends State<FotoPage> {
  File? _image;

  Future<void> _tirarFoto(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    print("1 ${image?.path.toString()}");

    if (image != null) {

      setState(() {
        _image = File(image.path);
      });

      //salvar permanentemente
      final directory = await getApplicationDocumentsDirectory();
      final newPath = '${directory.path}/foto.png';
      print(newPath);
      await _image!.copy(newPath);

    }
  }
  Future<void> _loadImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final newPath = '${directory.path}/foto.png';
    setState(() {
      _image = File(newPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tirar Foto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(
              _image!,
              height: 250,
              width: 250,
            )
                : const Text('Nenhuma foto selecionada'),
            ElevatedButton(
              onPressed: () => _tirarFoto(ImageSource.camera),
              child: const Text('Tirar Foto da Câmera'),
            ),
            ElevatedButton(
              onPressed: () => _tirarFoto(ImageSource.gallery),
              child: const Text('Escolher da Galeria'),
            ),
            ElevatedButton(
              onPressed: () => _loadImage(),
              child: const Text('pega foto'),
            ),
          ],
        ),
      ),
    );
  }
}