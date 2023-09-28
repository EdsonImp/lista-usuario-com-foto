import 'package:flutter/material.dart';
import 'package:lista_usuario_com_foto/model/user_model.dart';
import '../repository/user_repository.dart';
import 'foto_page.dart';
import 'dart:io';

class ListaUsuarios extends StatefulWidget {
  @override
  State<ListaUsuarios> createState() => _ListaUsuariosState();
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  UserRepository repository = UserRepository();
  String _nome = '';
  String _email = '';
  String? _idUser;
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  var users = [];
  var pathImage;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    pegarLista();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Usuario usuario = Usuario(nome: _nome, imageUrl: "", email: _email);
      repository.salvaUsuario(usuario);
      setState(() {
        pegarLista();
      });
      _nomeController.clear();
      _emailController.clear();

    }
  }

  //método para navegar para a pagina de foto e trazer o path
  void _navigateToFotoPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FotoPage()),
    );

    if (result != null && result is String) {
      await repository.atualizaFotoUsuario(_idUser!, result);
      setState(() {
        pegarLista();
      });
    }
  }

  Future<void> pegarLista() async {
    var user1 = await repository.carregarUsuarios();
    setState(() {
      users = user1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Usuários"),
        centerTitle: true,
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                      color: Colors.white,
                      child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(children: <Widget>[
                              const Text(
                                "Cadastro de Usuários",
                                style: TextStyle(fontSize: 20),
                              ),
                              TextFormField(
                                controller: _nomeController,
                                decoration:
                                    const InputDecoration(labelText: 'Nome'),
                                validator: (value) {
                                  if (value!.length < 10) {
                                    return 'O nome deve ter mais de 10 caracteres.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _nome = value!;
                                },
                              ),
                              TextFormField(
                                controller: _emailController,
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                                validator: (value) {
                                  if (!RegExp(
                                          r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                      .hasMatch(value!)) {
                                    return 'Por favor, insira um endereço de email válido.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _email = value!;
                                },
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Voltar'),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      _submitForm();
                                    },
                                    child: const Text('Salvar'),
                                  ),
                                ],
                              ),
                            ]),
                          ))),
                );
              },
            );
          },
          child: const Icon(Icons.person_add),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:users.isEmpty
                ? const Center(
              child: CircularProgressIndicator(),
            ) :

            ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  if (users[index]['imageurl'] != "") {
                    final newPath = users[index]['imageurl'];
                    pathImage = newPath;

                  }
                  return  Dismissible(
                      key: UniqueKey(),
                  onDismissed: (DismissDirection dismissDirection) async {
                   await repository.deletaUsuario(users[index]['objectId'].toString());
                   setState(() {
                     pegarLista();
                   });

                  },
                  background: Container(color:Colors.red),


                   child: Card(
                      child: ListTile(
                          title: Text(users[index]['nome']),
                          subtitle: Text(users[index]['email']),
                          leading: users[index]['imageurl'] == ""
                              ? GestureDetector(
                                  onTap: () {
                                    _idUser = users[index]['objectId'];
                                    _navigateToFotoPage();
                                  },
                                  child: const CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/images/avatar.png"),
                                    radius: 50,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    _idUser = users[index]['objectId'];
                                    _navigateToFotoPage();
                                  },
                                  child: Container(
                                    width: 60.0,
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: FileImage(File(pathImage))
                                                )
                                        )
                                    ),
                                  )
                                  ),
                                )
                  );
                }),
          ),
        ));
  }
}
