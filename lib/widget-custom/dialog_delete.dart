import 'package:address_book/global.dart';
import 'package:flutter/material.dart';
import '../database/address_book_database.dart';
import '../classes/contact.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog({
    super.key,
    required this.contactDelete,
    required this.deleteContactAndSetState,
  });
  final Contact contactDelete;
  final Function deleteContactAndSetState;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  bool show_Text_Image = false;
  int _counter = 3;

  bool contactDelete = false;
  final String recoverContact = "Recupera";

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 97, 97, 119)),
        width: 700,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(9)),
              child: Image.network(
                "https://images.pexels.com/photos/2743739/pexels-photo-2743739.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                width: 200,
              ),
            ),
            Text(
              "Alert",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                  fontFamily: "all_fonts"),
            ),
            Text(
              "Sei sicuro di voler eliminare il contatto?",
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontFamily: "letter",
                  color: Colors.white),
            ),
            Container(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      show_Text_Image = true;
                      Navigator.pop(context, true);
                      deletedContact = widget.contactDelete;
                      contattiEliminati.add(deletedContact!);

                      if (widget.contactDelete.id != null) {
                        await DatabaseManager.instance
                            .deleteContact(widget.contactDelete.id!);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: ElevatedButton(
                              onPressed: () {
                                widget.deleteContactAndSetState();
                                contattiEliminati.length =
                                    contattiEliminati.length - 1;
                              },
                              child: Text(
                                "Recupera",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.greenAccent,
                                  fontFamily: "letter",
                                ),
                              ))));
                    },
                    child: Text(
                      "Si",
                      style: TextStyle(fontFamily: "letter", fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "No",
                      style: TextStyle(fontFamily: "letter", fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (show_Text_Image)
                  Text(
                    "Stai per essere reinderizzato \n alla home tra $_counter secondi..",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                if (show_Text_Image)
                  Image.network(
                    "https://media.tenor.com/On7kvXhzml4AAAAj/loading-gif.gif",
                    width: 50,
                  ),
                SizedBox(
                  height: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

// void _gestisciChiusura() async {
//   Timer(Duration(seconds: 1), () {
//     if (_counter == 0) {
//       Navigator.pop(context, true);
//      await  DatabaseManager.instance.deleteContact(widget.contactDelete.id);
//     } else {
//       setState(() {
//         _counter--;
//         _gestisciChiusura();
//       });
//     }
//   });
// }
}
