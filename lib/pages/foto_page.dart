import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_usuario_com_foto/pages/lista_user.dart';


class FotoPage extends StatefulWidget {
  @override
  _FotoPageState createState() => _FotoPageState();
}

class _FotoPageState extends State<FotoPage> {
  File? _image;
  ListaUsuarios user = ListaUsuarios();


   Future<void> _tirarFoto( ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: source);
       if (image != null) {
         File? croppedFile = await ImageCropper().cropImage(
           sourcePath: image.path,
           aspectRatioPresets: [CropAspectRatioPreset.square],
           androidUiSettings: const AndroidUiSettings(
             toolbarTitle: 'Cropper',
             toolbarColor: Colors.deepOrange,
             toolbarWidgetColor: Colors.white,
             initAspectRatio: CropAspectRatioPreset.original,
             lockAspectRatio: false,
           ),
         );
         GallerySaver.saveImage(croppedFile!.path, albumName: 'appFlutterUser');
         Navigator.pop(context, croppedFile!.path);
       //setState(() {
       //_image = croppedFile;
      // });
    }

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
                 width: 170,
                 height: 170,

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

          ],
        ),
      ),
    );
  }
}