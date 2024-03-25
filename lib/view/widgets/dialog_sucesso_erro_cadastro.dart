import 'package:flutter/material.dart';

mostrarDialogCadastroAtt(String texto, BuildContext context, bool backToHome) {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black87,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text(texto)),
            actions: [
              Center(
                child: ElevatedButton(
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff4A5043))),
                    onPressed: () {
                      Navigator.pop(context);
                      if(backToHome == true){
                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      }
                      
                    },
                    child: const Text('Fechar')),
              ),
            ],
          );
        });
  }