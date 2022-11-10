import 'package:flutter/material.dart';

class LuceScreen extends StatefulWidget {
  const LuceScreen({super.key});

  @override
  LuceScreenState createState() {
    return LuceScreenState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class LuceScreenState extends State<LuceScreen> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  var _showResult;

  double quantity = 0;
  double quantityB = 0;
  double price = 0;
  double priceB = 0;

  double vat = 1.10;
  bool isCanone = false;
  bool isBioraria = false;
  int canone = 0;

  @override
  void initState() {
    _showResult = false;
    super.initState();
  }

  void show() {
    setState(() {
      _showResult = !_showResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    void toggleSwitch(bool value) {
      if (isCanone == false) {
        setState(() {
          isCanone = true;
          canone = 18;
        });
      } else {
        setState(() {
          isCanone = false;
          canone = 0;
        });
      }
    }

    void toggleSwitch2(bool value) {
      if (isBioraria == false) {
        setState(() {
          isBioraria = true;
        });
      } else {
        setState(() {
          isBioraria = false;
        });
      }
    }

    var result = isBioraria
        ? ((((price * quantity) + (priceB * quantityB)) * vat) + canone)
            .toDouble()
            .toStringAsFixed(2)
        : (((price * quantity) * vat) + canone).toDouble().toStringAsFixed(2);

    return GestureDetector(
      onTap: (() {
        FocusManager.instance.primaryFocus?.unfocus();
      }),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Calcolo Bolletta',
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'kW/h consumati',
                      enabledBorder: inputBorder(),
                      focusedBorder: focusBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Elemento richiesto';
                      } else {
                        setState(() {
                          quantity = double.parse(value);
                        });
                      }
                      return null;
                    },
                  ),
                  Container(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Prezzo kw/H',
                      enabledBorder: inputBorder(),
                      focusedBorder: focusBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Elemento richiesto';
                      } else {
                        setState(() {
                          price = double.parse(value);
                        });
                      }
                      return null;
                    },
                  ),
                  Container(
                    height: 20,
                  ),
                  Visibility(
                    visible: isBioraria,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'kw consumati fascia F23',
                        enabledBorder: inputBorder(),
                        focusedBorder: focusBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Elemento richiesto';
                        } else {
                          setState(() {
                            quantityB = double.parse(value);
                          });
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Visibility(
                    visible: isBioraria,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Prezzo kw/H fascia F23',
                        enabledBorder: inputBorder(),
                        focusedBorder: focusBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Elemento richiesto';
                        } else {
                          setState(() {
                            priceB = double.parse(value);
                          });
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Incl. Canone'),
                        Switch(
                          activeColor: Colors.amber,
                          activeTrackColor: Colors.cyan,
                          inactiveThumbColor: Colors.blueGrey.shade600,
                          inactiveTrackColor: Colors.grey.shade400,
                          splashRadius: 50.0,
                          value: isCanone,
                          onChanged: toggleSwitch,
                        ),
                        Text('Tariffa Bioraria'),
                        Switch(
                          activeColor: Colors.amber,
                          activeTrackColor: Colors.cyan,
                          inactiveThumbColor: Colors.blueGrey.shade600,
                          inactiveTrackColor: Colors.grey.shade400,
                          splashRadius: 50.0,
                          value: isBioraria,
                          onChanged: toggleSwitch2,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          show();
                        }
                      },
                      child: const Text(
                        'Calcola',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Visibility(
                    child: Container(
                      child: Text(
                        "L importo risulta: ${(result)}",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    visible: _showResult,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder inputBorder() {
    return const OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1,
        ));
  }

  OutlineInputBorder focusBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.blueAccent,
          width: 1,
        ));
  }
}
