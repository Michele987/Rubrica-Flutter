class Contact {
  int? id;
  String nome;
  String cognome;
  String numero;
  String email;

  Contact({
    this.id,
    required this.nome,
    required this.cognome,
    required this.numero,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cognome': cognome,
      'numero': numero,
      'email': email
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      nome: map['nome'],
      cognome: map['cognome'],
      numero: map['numero'],
      email: map['email'],
    );
  }
}
