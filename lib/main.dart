import 'package:flutter/material.dart';
import 'package:lista_usuario_com_foto/pages/foto_page.dart';
import 'package:lista_usuario_com_foto/pages/lista_user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista com foto',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  ListaUsuarios(

        ),

    );
  }
}
