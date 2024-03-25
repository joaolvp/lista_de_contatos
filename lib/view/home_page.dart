import 'dart:io';

import 'package:desafio_dio_projeto_final/model/contatos.dart';
import 'package:desafio_dio_projeto_final/repositories/contatos_repository.dart';
import 'package:desafio_dio_projeto_final/view/widgets/dialog_sucesso_erro_home.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic listaContatos;
  dynamic listaComContatos;
  buscarContatos() async {
    listaContatos = await ContatosRepository().buscarContatos();
    if (listaContatos.runtimeType == List<Contatos>) {
      listaComContatos = listaContatos;
    }
  }

  sucessoerroDialog(String texto) {
    Navigator.pop(context);
    mostrarDialogHome(texto, context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Contatos"),
        backgroundColor: const Color(0xff4A5043),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
            future: buscarContatos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (listaComContatos.length == 0) {
                  return const Center(
                    child: Text('Nenhum contato salvo :(', style: TextStyle(fontSize: 18),),
                  );
                }
                return ListView.builder(
                    itemCount: listaComContatos.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                builder: (context) {
                                  return Wrap(
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.edit),
                                        title: const Text('Editar'),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/atualizar',
                                              arguments: {
                                                "id": listaComContatos[index]
                                                    .objectId,
                                                "foto": listaComContatos[index]
                                                    .fotoPerfil,
                                                "nome": listaComContatos[index]
                                                    .nome,
                                                "cidade":
                                                    listaComContatos[index]
                                                        .cidade,
                                                "telefone":
                                                    listaComContatos[index]
                                                        .telefone,
                                                "email": listaComContatos[index]
                                                    .email
                                              });
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.delete),
                                        title: const Text('Excluir'),
                                        onTap: () async {
                                          var response =
                                              await ContatosRepository()
                                                  .removerContato(
                                                      (listaComContatos[index]
                                                          .objectId));
                                          if (response == 200) {
                                            sucessoerroDialog(
                                                'Removido com sucesso');
                                          } else {
                                            return sucessoerroDialog(
                                                'Erro ao remover');
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Card(
                              elevation: 5,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(10),
                                leading:
                                    File(listaComContatos[index].fotoPerfil)
                                                .existsSync() ==
                                            true
                                        ? ClipOval(
                                            child: Image.file(
                                            File(listaComContatos[index]
                                                .fotoPerfil),
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover,
                                          ))
                                        : const CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Color(0xff9AC2C9),
                                            child: Icon(
                                              Icons.person,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                title: Text(
                                  listaComContatos[index].nome,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(listaComContatos[index].email),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(listaComContatos[index].cidade),
                                    Text(listaComContatos[index].telefone),
                                  ],
                                ),
                              )),
                        ),
                      );
                    });
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Color(0xffFFCB47),
                ));
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: const Color(0xff9AC2C9),
        elevation: 30,
        onPressed: () {
          Navigator.pushNamed(context, '/cadastro');
        },
        backgroundColor: const Color(0xffFFCB47),
        child: const Icon(Icons.add),
      ),
    );
  }
}
