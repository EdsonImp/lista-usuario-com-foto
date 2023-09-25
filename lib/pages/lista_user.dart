
import 'package:flutter/material.dart';
import '../repository/user_repository.dart';
import 'foto_page.dart';
import 'dart:io';


class ListaUsuarios extends StatefulWidget {
  @override
  State<ListaUsuarios> createState() => _ListaUsuariosState();
}

class _ListaUsuariosState extends State<ListaUsuarios> {
  UserRepository repository = UserRepository();

   var users = [];
   var avatar;
  @override
  void initState() {
    super.initState();
    pegarLista();
  }

   Future<void> pegarLista ()async{
     var user1 = await repository.carregarUsuarios();
    // print(user1);
     setState(() {
       users = user1;
     });
}


  @override
  Widget build(BuildContext context)  {

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) =>  FotoPage(),),);

      },),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index){
                if(users[index]['imageurl'] != "") {
                  final newPath = users[index]['imageurl'];
                  avatar = File(newPath);

                }
                return Card(
                  child: ListTile(
                  title: Text(users[index]['nome']),
                    leading: users[index]['imageurl'] == ""? const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/avatar.png"),
                      radius: 50,
                    ) : Container(
                      width: 50,
                      height: 50,
                        child: Image.file(
                        avatar!,

                      ),
                    )
                  )
                );
                 }
                        ),
        ),
      )
    );
  }
}

