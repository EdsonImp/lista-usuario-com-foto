class Usuario {
  String? objectId;
  String nome;
  String imageUrl;
  String email;

  Usuario({
    required this.nome,
    required this.imageUrl,
    required this.email

  });

  @override
  String toString() {
    return 'Usuario{objectId: $objectId, nome: $nome, imageUrl: $imageUrl, email: $email}';
  }
}