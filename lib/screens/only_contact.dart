import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './../classes/contact.dart';
import './../widget-custom/btn_actions.dart';
import 'package:intl/intl.dart';

class SingoloContatto extends StatefulWidget {
  SingoloContatto({super.key, required this.singleContact});
  final Contact singleContact;

  @override
  State<SingoloContatto> createState() => _SingoloContattoState();
}

class _SingoloContattoState extends State<SingoloContatto> {
  String formattedDate = DateFormat.yMMMMEEEEd('it_IT').format(DateTime.now());
  Color variableColor = Colors.brown;

  void initState() {
    super.initState();

    String letterName = "${widget.singleContact.nome.substring(0, 1)}";
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 60, 60, 84),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 96, 96, 135),
        title: Text(
          "Singolo contatto",
          style: TextStyle(fontFamily: "letter"),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 96, 96, 135),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Transform.translate(
                    offset: Offset(5.0, -75.0),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: variableColor,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: Text(
                          "${widget.singleContact.nome.substring(0, 1)}",
                          style: TextStyle(fontSize: 28, fontFamily: "letter"),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${widget.singleContact.nome}",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontFamily: "all_fonts"),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${widget.singleContact.cognome}",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontFamily: "all_fonts"),
                      ),
                    ],
                  ),
                  Text(
                    "Cellulare: ${widget.singleContact.numero}",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "all_fonts"),
                  ),
                  Text(
                    "Email: ${widget.singleContact.email}",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "all_fonts"),
                  ),
                  Text(
                    "Data creazione contatto:",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "letter",
                        fontSize: 18),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: "all_fonts"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomElevatedButton(
                        onPressed: () {
                          final numero = "+39${widget.singleContact.numero}";
                          final uri = Uri(scheme: "tel", path: numero);
                          launchUrl(uri);
                        },
                        icon: Icons.call,
                        iconColor: Colors.green,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CustomElevatedButton(
                        onPressed: () {
                          final String subject = "Titolo mail!";
                          final String email = "${widget.singleContact.email}";
                          final String message = "Contenuto email";
                          final mail =
                              'mailto:$email?subject=$subject&body=$message';
                          launch(mail);
                        },
                        icon: Icons.mail,
                        iconColor: Colors.green,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CustomElevatedButton(
                        onPressed: () {
                          launch("sms:${widget.singleContact.numero}");
                        },
                        icon: Icons.sms,
                        iconColor: Colors.green,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CustomElevatedButton(
                        onPressed: () {
                          launch(
                              'https://wa.me/${widget.singleContact.numero}');
                        },
                        icon: Icons.message,
                        iconColor: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
