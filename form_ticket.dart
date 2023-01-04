// ignore_for_file: sort_child_properties_last, prefer_interpolation_to_compose_strings

import 'package:book_tickets/models/ferryticket.dart';
import 'package:book_tickets/screens/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_services.dart';
import '../utils/app_styles.dart';
import 'package:sqflite/sqflite.dart';

const String myhomepageRoute = '/';
const String myprofileRoute = 'profile';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case myhomepageRoute:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('404 Not found')),
                ));
    }
  }
}

class FormTicket extends StatefulWidget {
  const FormTicket({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<FormTicket> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: MyHomePage(),
        onGenerateRoute: Router.generateRoute,
        initialRoute: myhomepageRoute);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.ferryDetails}) : super(key: key);
  final FerryTicket? ferryDetails;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String date = "";
  String departure = "";
  String destination = "";
  String journey = "";
  final DateFormat formatter = DateFormat("dd/MM/yyyy");
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _dateController = TextEditingController();
  final _departureController = TextEditingController();
  final _destinationController = TextEditingController();
  final _journeyController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  Future<void> _onSave() async {
    final date = formatter.parse(_dateController.text);
    final departure = _departureController.text;
    final destination = _destinationController.text;
    final journey = _journeyController.text;

    // Add save code here
    widget.ferryDetails == null;
    await _databaseService.insertFerryTicket(
      FerryTicket(
          depart_date: date,
          journey: journey,
          depart_route: departure,
          dest_route: destination),
    );
  }

  _submit() {
    showDialog(
      context: context,
      barrierDismissible: true, // user can tap anywhere to close the pop up
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Is this the correct information ?'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Date:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(date),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Departure:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(departure),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Destination:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(destination),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Journey:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(journey),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.grey,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  child: const Text('Cancel'),
                  onPressed: () async {
                    Navigator.of(context).pop(); // Close the dialog
                    FocusScope.of(context)
                        .unfocus(); // Unfocus the last selected input field
                    _formKey.currentState?.reset(); // Emp
                  }, // so the alert dialog is closed when navigating back to main page
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  child: const Text('Submit'),
                  onPressed: () {
                    _onSave().then((value) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TicketScreen(),
                        ),
                      );
                    });
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Styles.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    validator: (value) {
                      if (value == null) {
                        return "Please select your date!";
                      }
                      return null;
                    },
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() {
                          date = formatter.format(picked);
                        });
                        _dateController.text = date;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    // ignore: prefer_const_literals_to_create_immutables
                    items: [
                      const DropdownMenuItem(
                        child: Text("Penang"),
                        value: "Penang",
                      ),
                      const DropdownMenuItem(
                        child: Text("Langkawi"),
                        value: "Langkawi",
                      ),
                      const DropdownMenuItem(
                        child: Text("Singapore"),
                        value: "Singapore",
                      ),
                      const DropdownMenuItem(
                        child: Text("Batam"),
                        value: "Batam",
                      ),
                      const DropdownMenuItem(
                        child: Text("Koh Lipe"),
                        value: "Koh Lipe",
                      )
                    ],
                    hint: const Text("Departure"),
                    onChanged: (value) {
                      setState(() {
                        departure = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please select your departure!";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        departure = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    // ignore: prefer_const_literals_to_create_immutables
                    items: [
                      const DropdownMenuItem(
                        child: Text("Penang"),
                        value: "Penang",
                      ),
                      const DropdownMenuItem(
                        child: Text("Langkawi"),
                        value: "Langkawi",
                      ),
                      const DropdownMenuItem(
                        child: Text("Singapore"),
                        value: "Singapore",
                      ),
                      const DropdownMenuItem(
                        child: Text("Batam"),
                        value: "Batam",
                      ),
                      const DropdownMenuItem(
                        child: Text("Koh Lipe"),
                        value: "Koh Lipe",
                      )
                    ],
                    hint: const Text("Destination"),
                    onChanged: (value) {
                      setState(() {
                        destination = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please select your destination!";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        destination = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      // ignore: prefer_const_literals_to_create_immutables
                      items: [
                        const DropdownMenuItem(
                          child: Text("One Way"),
                          value: "One Way",
                        ),
                        const DropdownMenuItem(
                          child: Text("Return"),
                          value: "Return",
                        )
                      ],
                      hint: const Text("Journey"),
                      onChanged: (value) {
                        setState(() {
                          journey = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please select your journey!";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          journey = value!;
                        });
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _submit();
                      }
                    },
                    child: const Text("Submit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
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
