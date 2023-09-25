import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';
import 'package:flutter/material.dart';

class UserRepository  {

  List<dynamic> usuarios = [];

  Future<http.Response> salvaUsuario(Usuario usuario) async{
    return await http.post(
        Uri.parse('https://parseapi.back4app.com/classes/endereco'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Parse-Application-Id': 'KTrYFVO3Ur8j0zyNhfNJI7zLDuJLhtGHJpZVvZYB',
          'X-Parse-REST-API-Key': 'n8NOOta9bmlDUoJ1LGQjp17R9F35TEneWiZoGVHS'
        },
        body: jsonEncode(<String, dynamic>{
          'nome': usuario.nome,
          'imageurl': usuario.imageUrl,
          'email': usuario.email,

        })

    );

  }


  Future<List<dynamic>> carregarUsuarios() async {
      final response = await http.get(
      Uri.parse('https://parseapi.back4app.com/classes/usuarios'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Parse-Application-Id': 'KTrYFVO3Ur8j0zyNhfNJI7zLDuJLhtGHJpZVvZYB',
        'X-Parse-REST-API-Key': 'n8NOOta9bmlDUoJ1LGQjp17R9F35TEneWiZoGVHS'
      },
    );
    if (response.statusCode == 200) {

        usuarios = json.decode(response.body)['results'];
               return usuarios;
    } else {
      throw Exception('Falha ao carregar os endereços');
    }
  }





  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}











