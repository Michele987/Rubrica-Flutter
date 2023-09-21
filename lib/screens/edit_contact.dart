import 'package:address_book/global.dart';
import 'package:flutter/material.dart';
import './../classes/contact.dart';
// import './../database/address_book_database.dart';

class ModificaContatto extends StatefulWidget {
  ModificaContatto(
      {super.key,
      required this.contact,
      required this.nameController,
      required this.surnameController,
      required this.numberController,
      required this.emailController,
      required this.editContact});

  final Contact contact;
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController numberController;
  final TextEditingController emailController;
  final Function editContact;

  @override
  State<ModificaContatto> createState() => _ModificaContattoState();
}

class _ModificaContattoState extends State<ModificaContatto> {
  Color controllerCheckEmail = Colors.transparent;
  Color controllerCheckNumber = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 97, 97, 119),
      appBar: AppBar(
        title: Text(
          "Modifica contatto",
          style: TextStyle(fontFamily: "letter"),
        ),
        backgroundColor: Color(0xff7C809B),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 600,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Modifica il contatto',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2.7,
                      fontFamily: "all_fonts",
                      shadows: [
                        Shadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: Offset(2, 2),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: widget.nameController,
                decoration: InputDecoration(
                  fillColor: Color.fromARGB(255, 181, 182, 194),
                  filled: true,
                  labelText: "Inserisci il Nome",
                  labelStyle: TextStyle(fontFamily: "letter", fontSize: 18),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: widget.surnameController,
                decoration: InputDecoration(
                  fillColor: Color.fromARGB(255, 181, 182, 194),
                  filled: true,
                  labelText: "Inserisci il Cognome",
                  labelStyle: TextStyle(fontFamily: "letter", fontSize: 18),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: widget.numberController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: controllerCheckNumber, width: 2),
                  ),
                  fillColor: Color.fromARGB(255, 181, 182, 194),
                  filled: true,
                  labelText: "Inserisci il Numero",
                  labelStyle: TextStyle(fontFamily: "letter", fontSize: 18),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: widget.emailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: controllerCheckEmail, width: 2)),
                  fillColor: Color.fromARGB(255, 181, 182, 194),
                  filled: true,
                  labelText: "Inserisci l'Email",
                  labelStyle: TextStyle(fontFamily: "letter", fontSize: 18),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.save),
                    label: Text(
                      "Save",
                      style: TextStyle(fontFamily: "letter", fontSize: 17),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(24),
                      backgroundColor: Color(0xff7C809B),
                    ),
                    onPressed: () async {
                      final editNome = widget.nameController.text;
                      final editCognome = widget.surnameController.text;
                      final editNumero = widget.numberController.text;
                      final editEmail = widget.emailController.text;

                      final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(editEmail);

                      if (emailValid) {
                        setState(() {
                          controllerCheckEmail = Colors.greenAccent;
                        });
                      } else {
                        setState(() {
                          controllerCheckEmail = Colors.red;
                        });

                        if (editEmail.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Rispetta il formato dell'email",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                          return;
                        } else {
                          controllerCheckEmail = Colors.greenAccent;
                        }
                      }

                      final String numberPhoneReg =
                          r'(^(?:[+0]9)?[0-9]{10,12}$)';
                      RegExp regExp = new RegExp(numberPhoneReg);

                      if (!regExp.hasMatch(editNumero)) {
                        setState(() {
                          controllerCheckNumber = Colors.greenAccent;
                        });
                      } else {
                        setState(() {
                          controllerCheckNumber = Colors.red;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Inserisci correttamente il numero, include anche il prefisso",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                        return;
                      }

                      if (editNumero.replaceFirst("+", "").length > 15) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Non puoi superare i 15 numeri",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                        controllerCheckNumber = Colors.red;
                        return;
                      }

                      setState(() {
                        widget.contact.nome = editNome;
                        widget.contact.cognome = editCognome;
                        widget.contact.numero = editNumero;
                        widget.contact.email = editEmail;

                        updatedContact = widget.contact;

                        widget.editContact(widget.contact);

                        Navigator.pop(context, widget.contact);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
