import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:desafio_dio_projeto_final/repositories/contatos_repository.dart';
import 'package:desafio_dio_projeto_final/view/widgets/dialog_sucesso_erro_cadastro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CadastroContatoPage extends StatefulWidget {
  const CadastroContatoPage({super.key});

  @override
  State<CadastroContatoPage> createState() => _CadastroContatoPageState();
}

class _CadastroContatoPageState extends State<CadastroContatoPage> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String pathPhoto = "";
  File? _image;
  var isLoading = false;
  dynamic validadorNome = "";
  dynamic validadorTelefone = "";
  dynamic validadorEmail = "";
  dynamic _errorNome;
  dynamic _errorTelefone;
  dynamic _errorEmail;


  String? _validarNome(String? value) {
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (value?.isEmpty == true || !nameExp.hasMatch(value!)) {
      setState(() {
        _errorNome = 'Digite um nome válido!';
      });
      return "not ok";
    }
    setState(() {
      _errorNome = "";
    });
    return 'ok';
  }

  String? _validarTelefone(String? value) {
    final RegExp nameExp = RegExp(r'\(\d{2}\) \d{4,5}-\d{4}');
    if (value?.isEmpty == true || !nameExp.hasMatch(value!)) {
      setState(() {
        _errorTelefone = 'Digite um telefone válido! (xx)xxxx-xxxx ou (xx)xxxxx-xxxx';
      });
      return "not ok";
    }
    setState(() {
      _errorTelefone = "";
    });
    return "ok";
  }

  String? _validarEmail(String? value) {
    final RegExp nameExp =
        RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-zA-Z]{2,})$');
    if (value?.isEmpty == true || !nameExp.hasMatch(value!)) {
      
      setState(() {
        _errorEmail = 'Digite um e-mail válido!';
      });
      return "not ok";
      
    }
    setState(() {
      _errorEmail = "";
    });
    return "ok";
  }

  cameraPhoto() async {
    final XFile? imgFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (imgFile == null) return;

    setState(() {
      pathPhoto = imgFile.path;
      _image = File(imgFile.path);
    });
  }

  galeriaPhoto() async {
    final XFile? imgFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imgFile == null) return;

    setState(() {
      pathPhoto = imgFile.path;
      _image = File(imgFile.path);
    });
  }

  sucessoerroDialog(String texto, bool backToHome) {
    mostrarDialogCadastroAtt(texto, context, backToHome);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('Criar Contato '),
          ],
        ),
        backgroundColor: const Color(0xff4A5043),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image != null
                      ? ClipOval(
                          child: Image.file(
                          _image!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ))
                      : const CircleAvatar(
                          radius: 75,
                          backgroundColor: Color(0xff9AC2C9),
                          child: Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.white,
                          ),
                        ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xff9AC2C9))),
                      onPressed: () {
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
                                    leading: const Icon(Icons.camera),
                                    title: const Text('Câmera'),
                                    onTap: () {
                                      cameraPhoto();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo),
                                    title: const Text('Galeria'),
                                    onTap: () {
                                      galeriaPhoto();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: const Row(
                        children: [
                          Text('Editar'),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.edit),
                        ],
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: nomeController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    label: const Text('Nome*'), border: const OutlineInputBorder(),
                    floatingLabelStyle: const TextStyle(color: Colors.black54),
                    errorText: _errorNome != "" ? _errorNome : null, 
                    labelStyle: TextStyle(color: _errorNome == "" ? Colors.red: Colors.black54),
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: cidadeController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    label: Text('Cidade'), border: OutlineInputBorder(),),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
                controller: telefoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    label: const Text('Telefone*'), border: const OutlineInputBorder(),
                    floatingLabelStyle: const TextStyle(color:Colors.black54),
                    errorText: _errorTelefone != "" ? _errorTelefone : null, 
                    labelStyle: TextStyle(color: _errorTelefone == "" ? Colors.red: Colors.black54),
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    label: const Text('E-mail*'), border: const OutlineInputBorder(),
                    floatingLabelStyle: const TextStyle(color:Colors.black54),
                    errorText: _errorEmail != "" ? _errorEmail : null,  
                    labelStyle: TextStyle(color: _errorEmail == "" ? Colors.red: Colors.black54),
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            dynamic response;
                            

                            validadorNome = _validarNome(nomeController.text);
                            validadorTelefone =
                                _validarTelefone(telefoneController.text);
                            validadorEmail =
                                _validarEmail(emailController.text);


                            if (validadorNome == "ok" &&
                                validadorTelefone == "ok" &&
                                validadorEmail == "ok") {
                              setState(() {
                                isLoading = true;
                              });
                              response = await ContatosRepository()
                                  .criarContato(
                                      pathPhoto,
                                      nomeController.text,
                                      cidadeController.text,
                                      telefoneController.text,
                                      emailController.text);
                              if (response == 201) {
                                setState(() {
                                  isLoading = false;
                                });
                                sucessoerroDialog('Criado com sucesso!', true);
                              } else {
                                setState(() {
                                  isLoading = false;
                                });

                                return sucessoerroDialog(
                                    'Erro ao criar contato', false);
                              }
                            }
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xff4A5043))),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Salvar ",
                                style: TextStyle(fontSize: 18),
                              ),
                              Icon(Icons.save_sharp)
                            ],
                          ))),
                ],
              ),
              isLoading == true
                  ? const CircularProgressIndicator(color: Color(0xffFFCB47))
                  : const Text("")
            ]),
          ),
        ],
      ),
    );
  }
}
