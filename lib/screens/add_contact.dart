import 'dart:async';
import 'package:address_book/classes/contact.dart';
import 'package:flutter/material.dart';
import './../database/address_book_database.dart';

class AggiungiContatto extends StatefulWidget {
  AggiungiContatto({super.key});

  @override
  State<AggiungiContatto> createState() => _AggiungiContattoState();
}

class _AggiungiContattoState extends State<AggiungiContatto> {
  final TextEditingController _textControllerNome = TextEditingController();

  final TextEditingController _textControllerCognome = TextEditingController();

  final TextEditingController _textControllerNumero = TextEditingController();

  final TextEditingController _textControllerEmail = TextEditingController();

  Color controllerCheckEmail = Colors.transparent;
  Color controllerCheckNumber = Colors.transparent;

  bool iconCheck = true;

  @override
  void dispose() {
    _textControllerNome.dispose();
    _textControllerCognome.dispose();
    _textControllerNumero.dispose();
    _textControllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 97, 97, 119),
      appBar: AppBar(
        title: Text(
          'Aggiungi il contatto',
          style: TextStyle(fontFamily: "letter"),
        ),
        backgroundColor: Color(0xff7C809B),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Center(
              child: Container(
                height: 500,
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Aggiungi il contatto',
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: "all_fonts",
                            color: Colors.white,
                            letterSpacing: 2.7,
                            shadows: [
                              Shadow(
                                color: Colors.grey.withOpacity(0.5),
                                offset: Offset(2, 2),
                                blurRadius: 2,
                              ),
                            ],
                            decorationColor:
                                const Color.fromARGB(255, 193, 54, 244),
                            decorationThickness: 1.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    TextFormField(
                      controller: _textControllerNome,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 2)),
                          fillColor: Color.fromARGB(255, 181, 182, 194),
                          filled: true,
                          labelText: "Inserisci il nome",
                          labelStyle:
                              TextStyle(fontFamily: "letter", fontSize: 18),
                          prefixIcon: Icon(Icons.people)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _textControllerCognome,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 2)),
                          fillColor: Color.fromARGB(255, 181, 182, 194),
                          filled: true,
                          labelText: "Inserisci il cognome",
                          labelStyle:
                              TextStyle(fontFamily: "letter", fontSize: 18),
                          prefixIcon: Icon(Icons.people)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _textControllerNumero,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: controllerCheckNumber, width: 2)),
                          fillColor: Color.fromARGB(255, 181, 182, 194),
                          filled: true,
                          labelText: "Inserisci il numero",
                          labelStyle:
                              TextStyle(fontFamily: "letter", fontSize: 18),
                          prefixIcon: Icon(Icons.call)),
                    ),
                    Transform.translate(
                      offset: Offset(-54, 3),
                      child: Text(
                        "Ex: +393491983298 max(15num)",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: "all_fonts"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _textControllerEmail,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: controllerCheckEmail, width: 2)),
                          fillColor: Color.fromARGB(255, 181, 182, 194),
                          filled: true,
                          labelText: "Inserisci l'email",
                          labelStyle:
                              TextStyle(fontFamily: "letter", fontSize: 18),
                          prefixIcon: Icon(Icons.mail)),
                    ),
                    Transform.translate(
                      offset: Offset(-87, 3),
                      child: Text("Ex: michele@gmail.com",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: "all_fonts")),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(
                                    0xff7C809B)), // Imposta il colore di sfondo
                            minimumSize:
                                MaterialStateProperty.all<Size>(Size(100, 50)),
                          ),
                          onPressed: () async {
                            final nome = _textControllerNome.text;
                            final cognome = _textControllerCognome.text;
                            final numero = _textControllerNumero.text;
                            final email = _textControllerEmail.text;

                            await DatabaseManager.instance.insertContact(
                                Contact(
                                    nome: nome,
                                    cognome: cognome,
                                    numero: numero,
                                    email: email));

                            final newContact = Contact(
                                nome: nome,
                                cognome: cognome,
                                numero: numero,
                                email: email);

                            if (nome.isEmpty &&
                                cognome.isEmpty &&
                                numero.isEmpty &&
                                email.isEmpty) {
                              iconCheck = false;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text(
                                "Contatto vuoto, digita qualcosa",
                                style: TextStyle(color: Colors.red),
                              )));
                              return;
                            }

                            if (nome.isEmpty ||
                                cognome.isEmpty ||
                                numero.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text(
                                "Devi inserire almeno un carattere nei campi",
                                style: TextStyle(color: Colors.red),
                              )));
                              return;
                            }

                            final bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(email);

                            if (emailValid) {
                              setState(() {
                                controllerCheckEmail = Colors.greenAccent;
                              });
                            } else {
                              setState(() {
                                controllerCheckEmail = Colors.red;
                              });

                              if (email.isNotEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                  "Rispetta il formato dell'email",
                                  style: TextStyle(color: Colors.red),
                                )));
                                return;
                              } else {
                                controllerCheckEmail = Colors.transparent;
                              }
                            }

                            final String numberPhoneReg =
                                r'(^(?:[+0]9)?[0-9]{10,12}$)';
                            RegExp regExp = new RegExp(numberPhoneReg);

                            if (!regExp.hasMatch(numero)) {
                              setState(() {
                                controllerCheckNumber = Colors.greenAccent;
                              });
                            } else {
                              setState(() {
                                controllerCheckNumber = Colors.red;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Inserisci correttamente il numero, include anche il prefisso")));
                              return;
                            }

                            if (numero.replaceFirst("+", "").length > 15) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text(
                                "Non puoi superare i 15 numeri",
                                style: TextStyle(color: Colors.red),
                              )));
                              controllerCheckNumber = Colors.red;
                              return;
                            } else {
                              controllerCheckNumber = Colors.greenAccent;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              "Contatto creato correttamente!",
                              style: TextStyle(color: Colors.greenAccent),
                            )));

                            setState(() {
                              iconCheck = false;
                            });

                            Timer((Duration(seconds: 2)), () {
                              setState(() {
                                iconCheck = false;
                              });
                              Navigator.pop(context, newContact);
                            });
                          },
                          child: iconCheck
                              ? Text(
                                  'Salva',
                                  style: TextStyle(
                                      fontSize: 23, fontFamily: "all_fonts"),
                                )
                              : Icon(Icons.check),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xff7C809B)),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(100, 50)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Annulla",
                              style: TextStyle(
                                  fontSize: 23, fontFamily: "all_fonts"),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
