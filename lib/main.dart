import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(title: 'BMI Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  double _weight = 0.0;
  double _height = 0.0;
  String _gender = 'male';
  double _bmi = 0.0;

  final FocusNode _weightFocus = FocusNode();
  final FocusNode _heightFocus = FocusNode();

  @override
  void dispose() {
    _weightFocus.dispose();
    _heightFocus.dispose();
    super.dispose();
  }

  void _setWeight(String weight) {
    setState(() {
      _weight = double.tryParse(weight) ?? 0.0;
    });
  }

  void _setHeight(String height) {
    setState(() {
      _height = double.tryParse(height) ?? 0.0;
    });
  }

  void _setGender(String gender) {
    setState(() {
      _gender = gender;
    });
  }

  void _calculateBMI() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _bmi = (_weight / pow(_height / 100, 2));
      });

      if (_bmi < 18.5) {
        _showDialog('You are underweight!');
      } else if (_bmi >= 18.5 && _bmi <= 24.9) {
        _showDialog('You are having normal weight. Well done!');
      } else if (_bmi >= 25 && _bmi <= 29.9) {
        _showDialog('You are overweight!');
      } else if (_bmi >= 30) {
        _showDialog('You are obese. Please watch your diet!');
      }
    }
  }

  void _showDialog(String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("BMI Status", textAlign: TextAlign.center),
          content: Text(status),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.all(20),
                  child: TextFormField(
                    focusNode: _weightFocus,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Weight (kg)',
                    ),
                    onSaved: (value) {
                      _setWeight(value ?? '');
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your weight';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  )),
              Container(
                  margin: const EdgeInsets.all(20),
                  child: TextFormField(
                    focusNode: _heightFocus,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Height (cm)',
                    ),
                    onSaved: (value) {
                      _setHeight(value ?? '');
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your height';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  )),
              Container(
                margin: const EdgeInsets.all(20),
                child: FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('Gender:'),
                        RadioListTile<String>(
                          title: const Text('Male'),
                          value: 'male',
                          groupValue: _gender,
                          onChanged: (value) {
                            _setGender(value!);
                            state.didChange(value);
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Female'),
                          value: 'female',
                          groupValue: _gender,
                          onChanged: (value) {
                            _setGender(value!);
                            state.didChange(value);
                          },
                        ),
                        if (state.hasError)
                          Text(
                            state.errorText!,
                            style: const TextStyle(color: Colors.red),
                          ),
                      ],
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                  margin: const EdgeInsets.all(20),
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _calculateBMI,
                    child: const Text('Calculate'),
                  )),
              Container(
                margin: const EdgeInsets.all(20),
                child: Text(_bmi.toStringAsFixed(2)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
