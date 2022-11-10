import 'package:flutter/material.dart';

class GasScreen extends StatefulWidget {
  const GasScreen({super.key});

  @override
  GasScreenState createState() {
    return GasScreenState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class GasScreenState extends State<GasScreen> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  var _showResult;

  double quantity = 0;
  double price = 0;

  int _selectedIndex = 1;

//Ai sensi di quanto disposto dal DL 130/2021 (decreto bollette), successiva Legge n.234 del 30 dicembre 2021, DL 17/2022 e Decreto
//Legge del 30 giugno 2022, le competenze di ottobre-dicembre 2021 e gennaio-settembre 2022, sono state assoggettate
//all'aliquota iva del 5%
  double vat = 1.05;

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
    var result = (((price * quantity) * vat).toDouble().toStringAsFixed(2));

    return GestureDetector(
      onTap: (() {
        FocusManager.instance.primaryFocus?.unfocus();
      }),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Calcolo Bolletta',
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'smc consumati',
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
                      labelText: '€/smc',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
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
                    visible: _showResult,
                    child: Text(
                      "L importo risulta: ${(result)}€",
                      style: const TextStyle(fontSize: 25),
                    ),
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
