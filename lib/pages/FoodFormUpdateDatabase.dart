import 'package:transfer_learning_fruit_veggies/model/food.dart';
import 'package:transfer_learning_fruit_veggies/bloc/food_bloc.dart';

import 'package:transfer_learning_fruit_veggies/services/local_storage_service.dart';
import 'package:transfer_learning_fruit_veggies/events/update_food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodForm extends StatefulWidget {
  final Food food;
  final int foodIndex;

  FoodForm({required this.food, required this.foodIndex});

  @override
  State<StatefulWidget> createState() {
    return FoodFormState();
  }
}

class FoodFormState extends State<FoodForm> {
  String _name = '';
  String _calories = '';
  String _protein = '';
  String _carbohydrates = '';
  String _sugar = '';
  String _fat = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 15,
      style: TextStyle(fontSize: 28),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String? value) {
        _name = value!;
      },
    );
  }

  Widget _buildCalories() {
    return TextFormField(
      initialValue: _calories,
      decoration: InputDecoration(labelText: 'Calories'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Name is Required';
        }
        double calories = double.parse(value);
        if (calories < 0.0) {
          return 'Calories can\'t be negatve';
        }

        return null;
      },
      onSaved: (String? value) {
        _calories = value!;
      },
    );
  }

  Widget _buildprotein() {
    return TextFormField(
      initialValue: _protein,
      decoration: InputDecoration(labelText: 'protein'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Name is Required';
        }
        double calories = double.parse(value);
        if (calories < 0.0) {
          return 'protein can\'t be negatve';
        }

        return null;
      },
      onSaved: (String? value) {
        _protein = value!;
      },
    );
  }

  Widget _buildcarbohydrates() {
    return TextFormField(
      initialValue: _carbohydrates,
      decoration: InputDecoration(labelText: 'Carbohydrates'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Name is Required';
        }
        double calories = double.parse(value);
        if (calories < 0.0) {
          return 'Carbohydrates can\'t be negatve';
        }

        return null;
      },
      onSaved: (String? value) {
        _carbohydrates = value!;
      },
    );
  }

  Widget _buildsugar() {
    return TextFormField(
      initialValue: _sugar,
      decoration: InputDecoration(labelText: 'sugar'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Name is Required';
        }
        double calories = double.parse(value);
        if (calories < 0.0) {
          return 'sugar can\'t be negatve';
        }

        return null;
      },
      onSaved: (String? value) {
        _sugar = value!;
      },
    );
  }

  Widget _buildfat() {
    return TextFormField(
      initialValue: _fat,
      decoration: InputDecoration(labelText: 'fat'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Name is Required';
        }
        double calories = double.parse(value);
        if (calories < 0.0) {
          return 'fat can\'t be negatve';
        }

        return null;
      },
      onSaved: (String? value) {
        _fat = value!;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.food != null) {
      _name = widget.food.nameFood;
      _calories = widget.food.kal.toString();
      _protein = widget.food.protein.toString();
      _carbohydrates = widget.food.carbohydrates.toString();
      _sugar = widget.food.sugar.toString();
      _fat = widget.food.fat.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Form"),
        brightness: Brightness.dark,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              _buildCalories(),
              _buildprotein(),
              _buildcarbohydrates(),
              _buildsugar(),
              _buildfat(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        print("form");
                        return;
                      }

                      _formKey.currentState!.save();

                      // Food food = Food(
                      //   nameFood: _name,
                      // );
                      // food.id = widget.food.id;
                      // food.kal = double.parse(_calories);
                      // food.volEstim = widget.food.volEstim;
                      // food.carbohydrates = widget.food.carbohydrates;
                      // food.protein = widget.food.protein;
                      // food.sugar = widget.food.sugar;
                      // food.fat = widget.food.fat;
                      // food.mass = widget.food.mass;
                      // food.volumicMass = widget.food.volumicMass;
                      print("new calories : " + _calories);
                      print("name new : " + _name);
                      widget.food.nameFood = _name;
                      widget.food.kal = double.parse(_calories);
                      widget.food.protein = double.parse(_protein);
                      widget.food.carbohydrates = double.parse(_carbohydrates);
                      widget.food.sugar = double.parse(_sugar);
                      widget.food.fat = double.parse(_fat);
                      print("aaaaaaaaa");
                      print(widget.food);
                      print("bbbbbbbbb");
                      widget.food.nameUpdated = _name;

                      DatabaseProvider.db.update(widget.food).then(
                            (storedFood) =>
                                BlocProvider.of<FoodBloc>(context).add(
                              UpdateFood(widget.foodIndex, widget.food),
                            ),
                          );

                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    onPressed: () => Navigator.pop(context),
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
