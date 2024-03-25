class Contatos {
  String objectId;
  String? fotoPerfil;
  String? nome;
  String? cidade;
  String? telefone;
  String? email;
  

  Contatos(
      {required this.objectId, this.fotoPerfil, this.nome, this.cidade, this.telefone, this.email});

  factory Contatos.fromMap(Map<String, dynamic> json){
    return Contatos(
      objectId: json['objectId'],
      fotoPerfil: json['foto_perfil'],
      nome: json['nome'],
      cidade: json['cidade'],
      telefone: json['telefone'],
      email: json['email']
    );
  }

}