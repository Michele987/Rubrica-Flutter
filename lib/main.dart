import 'package:address_book/screens/add_contact.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'classes/contact.dart';
import './widget-custom/row_contacts.dart';
import './widget-custom/btn_actions.dart';
import 'package:intl/date_symbol_data_local.dart';
import './database/address_book_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import './widget-custom/btn_filter.dart';
import './global.dart';

void main() async {
  initializeDateFormatting('it_IT').then((_) {
    runApp(MyApp());
  });

  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseManager.instance.initDatabase();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Rubrica",
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool showButtonsIcon = false;
  bool showThankYou = false;
  updateContact(updatedContact) async {
    setState(() {
      updateContacts(updatedContact);
      returnContacts();
    });
  }

  updateContacts(updatedContact) async {
    await DatabaseManager.instance.updateContact(updatedContact);
  }

  recuperaContatto() {
    return listContacts;
  }

  bool returnVisibible = false;

  returnContacts() async {
    listContacts = await DatabaseManager.instance.getContacts();
    setState(() {});
  }

  returnContactEliminated() {
    setState(() {
      if (deletedContact != null) {
        recoverContact();
        returnContacts();
        deletedContact = null;
      }
    });
  }

  List arrContactName = [];
  contEliminati() {
    for (var i = 0; i < contattiEliminati.length; i++) {
      arrContactName.add(contattiEliminati[i].nome);
    }
  }

  List<dynamic> nomeContattiEliminati = [];

  recoverContact() async {
    await DatabaseManager.instance.insertContact(deletedContact!);
  }

  List<Contact> listContacts = [];
  List<Contact> contactsFilter = [];
  List<Contact> allContacts = [];

  final TextEditingController _textFilterController = TextEditingController();
  bool isButtonActivated = false;
  bool show = true;
  Color changeColor = Color.fromARGB(255, 60, 60, 84);
  bool numContact = false;

  void preferencesColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      show = prefs.getBool('show') ?? true;
      changeColor = show
          ? Color.fromARGB(255, 60, 60, 84)
          : Color.fromARGB(255, 85, 96, 120);
    });
  }

  void loadSelectedFont() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      changeFont = prefs.getString('selectedFont') ?? "defaultFont";
    });
  }

  @override
  void initState() {
    isButtonActivated = false;
    returnContacts();
    preferencesColor();
    loadSelectedFont();
    super.initState();
  }

  bool showLength = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: changeColor,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 96, 96, 135),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Apri il drawer
              },
              icon: Icon(Icons.menu),
            );
          },
        ),
        title: Row(
          children: [
            Text(
              "Tutti i contatti",
              style: TextStyle(fontFamily: "letter"),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.contact_page_rounded)
          ],
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                setState(() {
                  show = !show;
                  print(show);

                  if (show) {
                    changeColor = Color.fromARGB(255, 60, 60, 84);
                  } else {
                    changeColor = Color.fromARGB(255, 85, 96, 120);
                  }
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('show', show);
              },
              icon: Icon(show ? Icons.sunny : Icons.nightlight)),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color.fromARGB(255, 96, 96, 135),
                      title: Text(
                        'Contatti eliminati',
                        style: TextStyle(
                            fontFamily: "all_fonts",
                            color: Colors.white,
                            fontSize: 20),
                      ),
                      content: Container(
                        height: 150,
                        child: Column(
                          children: [
                            Text(
                              'I contatti eliminati sono: ${contattiEliminati.length}',
                              style: TextStyle(
                                  fontFamily: "letter",
                                  fontSize: 19,
                                  color: Colors.white),
                            ),
                            ...contattiEliminati
                                .map((e) => Text(
                                      "Contatto eliminato: " + e.nome,
                                      style: TextStyle(
                                          fontFamily: "letter",
                                          fontSize: 19,
                                          color: Colors.white),
                                    ))
                                .toList(),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            'Chiudi',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "letter",
                                fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.delete_outline))
        ],
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 96, 96, 135),
        child: ListView(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showLength = !showLength;
                    });
                  },
                  child: Container(
                    width: 320,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 125, 149, 227)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.contact_page_outlined,
                              size: 30,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        if (showLength)
                          Text(
                            "Al momento hai ${listContacts.length} contatti/o",
                            style:
                                TextStyle(fontSize: 20, fontFamily: "letter"),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomElevatedButton(
                  onPressed: () {
                    setState(() {
                      showButtonsIcon = !showButtonsIcon;
                    });
                  },
                  icon:
                      showButtonsIcon ? Icons.filter_alt_off : Icons.filter_alt,
                  iconColor: Colors.greenAccent,
                )
                    .animate(
                        delay: 10.seconds,
                        onPlay: (controller) => controller.repeat())
                    .shake(delay: Duration(seconds: 2)),
                SizedBox(
                  height: 8,
                ),
                if (showButtonsIcon)
                  Column(
                    children: [
                      CustomElevatedIconButton(
                        onPressed: () async {
                          setState(() {
                            changeFont = "font3";
                          });
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('selectedFont', changeFont!);

                          Navigator.pop(context);
                        },
                        iconColor: Colors.greenAccent,
                        icon: Icons.filter_1,
                        label: Text(
                          "1 font",
                          style: TextStyle(fontFamily: "font3"),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      CustomElevatedIconButton(
                          onPressed: () async {
                            setState(() {
                              changeFont = "font4";
                            });

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString('selectedFont', changeFont!);

                            Navigator.pop(context);
                          },
                          iconColor: Colors.greenAccent,
                          icon: Icons.filter_2,
                          label: Text(
                            "2 font",
                            style: TextStyle(fontFamily: "font4"),
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      CustomElevatedIconButton(
                          onPressed: () async {
                            setState(() {
                              changeFont = "all_fonts";
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString('selectedFont', changeFont!);

                            Navigator.pop(context);
                          },
                          icon: Icons.filter_3,
                          iconColor: Colors.greenAccent,
                          label: Text(
                            "3 font",
                            style: TextStyle(fontFamily: "all_fonts"),
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      CustomElevatedIconButton(
                          onPressed: () async {
                            setState(() {
                              changeFont = "letter";
                            });

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString('selectedFont', changeFont!);

                            Navigator.pop(context);
                          },
                          icon: Icons.filter_4,
                          iconColor: Colors.greenAccent,
                          label: Text(
                            "4 font",
                            style: TextStyle(fontFamily: "letter"),
                          ))
                    ],
                  )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.white,
              thickness: 0.5,
              indent: 30,
              endIndent: 30,
            ),
            Container(
              width: 300,
              height: 367,
              child: Column(
                children: [
                  Image.asset(
                    "assets/iconaRubrica.png",
                    width: 150,
                  ),
                  Text(
                    "Developed by",
                    style: TextStyle(fontFamily: "letter", fontSize: 20),
                  ),
                  Text(
                    "Michele Pugliese",
                    style: TextStyle(
                        fontFamily: "all_fonts",
                        fontSize: 23,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomElevatedButton(
                      onPressed: () {
                        launch(
                            'https://www.linkedin.com/in/michele-pugliese-5b02661b8/');
                      },
                      icon: Icons.share,
                      iconColor: Colors.greenAccent),
                  SizedBox(
                    height: 10,
                  ),
                  CustomElevatedIconButton(
                          onPressed: () {
                            setState(() {
                              showThankYou = true;
                            });
                          },
                          icon: showThankYou ? Icons.thumb_up : Icons.check,
                          label: showThankYou
                              ? Text(
                                  "Thank you",
                                  style: TextStyle(
                                      fontFamily: "all_fonts", fontSize: 17),
                                )
                              : Text(
                                  "Click",
                                  style: TextStyle(
                                      fontFamily: "all_fonts", fontSize: 17),
                                ),
                          iconColor: Colors.greenAccent)
                      .animate(
                          delay: 10.seconds,
                          onPlay: (controller) => controller.repeat())
                      .shake(delay: Duration(seconds: 2)),
                ],
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: 300,
              child: TextFormField(
                controller: _textFilterController,
                decoration: InputDecoration(
                  fillColor: Color.fromARGB(255, 181, 182, 194),
                  filled: true,
                  labelText: "Inserisci il nome",
                  labelStyle: TextStyle(fontFamily: "letter", fontSize: 18),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomElevatedButton(
                        onPressed: () {
                          allContacts.addAll(listContacts);
                          final valueSearch = _textFilterController.text;
                          if (valueSearch.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              "Devi inserire qualcosa",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: "letter",
                                  fontSize: 16),
                            )));
                            return;
                          }
                          for (var contact in listContacts) {
                            if (valueSearch == contact.nome) {
                              returnVisibible = true;

                              contactsFilter.add(contact);

                              // listContacts.clear();
                            } else {
                              print("Nome non trovato");
                            }
                          }
                          listContacts = contactsFilter;
                          setState(() {});
                        },
                        icon: Icons.search,
                        iconColor: Colors.greenAccent,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      if (returnVisibible)
                        CustomElevatedButton(
                          onPressed: () {
                            setState(() {
                              contactsFilter = [];
                              listContacts = allContacts;
                              allContacts = [];
                              returnVisibible = false;
                            });
                          },
                          icon: Icons.exit_to_app,
                          iconColor: Colors.greenAccent,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 300,
              height: 500,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final currentyContact = listContacts[index];
                  return WidgetCustom(
                      recoverContactAndSetState: returnContactEliminated,
                      updateNewContact: updateContact,
                      contact: currentyContact,
                      function: () {
                        setState(() {
                          listContacts.removeAt(index);
                        });
                      },
                      recoverContact: () => _recoverContact(currentyContact));
                },
                itemCount: listContacts.length,
              ),
            ),
            Container(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Slider(
                    activeColor: Color.fromARGB(255, 96, 96, 135),
                    inactiveColor: Colors.cyan,
                    value: fontSize,
                    min: 16.0,
                    max: 25.0,
                    onChanged: (newValue) {
                      setState(() {
                        fontSize = newValue;
                      });
                    },
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  AggiungiContatto(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      ).then((newContact) {
                        if (newContact != null) {
                          setState(() {
                            listContacts.add(newContact);
                          });
                        }
                      });
                    },
                    icon: Icons.add,
                    iconColor: Colors.greenAccent,
                  )
                      .animate(
                          delay: 10.seconds,
                          onPlay: (controller) => controller.repeat())
                      .shake(delay: Duration(seconds: 2)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _recoverContact(Contact contact) {
    setState(() {
      listContacts.add(contact);
    });
  }
}
