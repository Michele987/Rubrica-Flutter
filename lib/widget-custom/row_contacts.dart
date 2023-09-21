// import 'package:address_book/global.dart';
import 'package:address_book/global.dart';
import 'package:address_book/screens/edit_contact.dart';
import 'package:address_book/screens/only_contact.dart';
import 'package:flutter/material.dart';
import '../classes/contact.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dialog_delete.dart';
import './btn_actions.dart';

class WidgetCustom extends StatefulWidget {
  WidgetCustom({
    super.key,
    required this.contact,
    required this.function,
    required this.recoverContact,
    required this.recoverContactAndSetState,
    required this.updateNewContact,
  });
  final Contact contact;
  final Function function;
  final Function recoverContact;
  final Function recoverContactAndSetState;
  final Function updateNewContact;

  @override
  State<WidgetCustom> createState() => _WidgetCustomState();
}

class _WidgetCustomState extends State<WidgetCustom> {
  bool isLongPressed = false;
  Color variableColor = Colors.brown;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerSurname = TextEditingController();
  final TextEditingController controllerNumber = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerName.text = "${widget.contact.nome}";
    controllerSurname.text = "${widget.contact.cognome}";
    controllerNumber.text = "${widget.contact.numero}";
    controllerEmail.text = "${widget.contact.email}";

    String letterName = "${widget.contact.nome.substring(0, 1)}";
    if (letterName == "M" || letterName == "m") {
      variableColor = Color.fromARGB(255, 191, 26, 26);
    } else if (letterName == "P" || letterName == "p") {
      variableColor = Colors.white;
    } else if (letterName == "N" || letterName == "n") {
      variableColor = Colors.purple;
    } else if (letterName == "S" || letterName == "s") {
      variableColor = Colors.yellow;
    } else if (letterName == "T" || letterName == "t") {
      variableColor = Colors.cyan;
    } else if (letterName == "C" || letterName == "c") {
      variableColor = Colors.tealAccent;
    } else if (letterName == "R" || letterName == "r") {
      variableColor = Colors.orange;
    } else if (letterName == "V" || letterName == "v") {
      variableColor = Colors.pinkAccent;
    } else if (letterName == "O" || letterName == "O") {
      variableColor = Colors.blue;
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isLongPressed = !isLongPressed;
              });
            },
            child: Container(
              decoration: BoxDecoration(

                  // border: Border.all(width: 1),
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: variableColor),
                    child: Center(
                        child: Text(
                      "${widget.contact.nome.substring(0, 1)}",
                      style: TextStyle(fontSize: 22, fontFamily: changeFont),
                    )),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          "${widget.contact.nome}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize,
                              fontFamily: changeFont),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${widget.contact.cognome}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSize,
                              fontFamily: changeFont),
                        ),
                      ],
                    ),
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingoloContatto(
                            singleContact: widget.contact,
                          ),
                        ),
                      );
                    },
                    icon: Icons.info,
                    iconColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 9,
          ),
          if (isLongPressed)
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 156, 154, 177),
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomElevatedButton(
                      onPressed: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: '',
                          barrierColor: Colors.black54,
                          transitionDuration: const Duration(milliseconds: 700),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return CustomDialog(
                              deleteContactAndSetState:
                                  widget.recoverContactAndSetState,
                              contactDelete: widget.contact,
                              // contactRecover: widget.contact
                            );
                          },
                          transitionBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ).then((value) {
                          if (value != null) {
                            widget.function();
                          }
                        }).then((value) {
                          if (value != null) {
                            widget.recoverContact();
                          }
                        });
                      },
                      icon: Icons.delete,
                      iconColor: Colors.red),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  ModificaContatto(
                                      contact: widget.contact,
                                      nameController: controllerName,
                                      surnameController: controllerSurname,
                                      numberController: controllerNumber,
                                      emailController: controllerEmail,
                                      editContact: widget.updateNewContact),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return RotationTransition(
                              turns: Tween<double>(begin: 0.7, end: 1.0)
                                  .animate(animation),
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 0.7, end: 1.0)
                                    .animate(animation),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              ),
                            );
                          },
                        ),
                      ).then((contact) {
                        setState(() {
                          contact;
                        });
                      });
                    },
                    icon: Icons.edit,
                    iconColor: Colors.greenAccent,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      final numero = "${widget.contact.numero}";
                      final uri = Uri(scheme: "tel", path: numero);
                      launchUrl(uri);
                    },
                    icon: Icons.call,
                    iconColor: Colors.greenAccent,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      final String subject = "Titolo mail!";
                      final String email = "${widget.contact.email}";
                      final String message = "Contenuto email";
                      final mail =
                          'mailto:$email?subject=$subject&body=$message';
                      launch(mail);
                    },
                    icon: Icons.email,
                    iconColor: Colors.greenAccent,
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      final String subject = "Invio contatto!";
                      final String message =
                          " Ti invio il seguente contatto: ${widget.contact.numero}";
                      final mail = 'mailto:?subject=$subject&body=$message';
                      launch(mail);
                    },
                    icon: Icons.share,
                    iconColor: Colors.greenAccent,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
