import 'package:flutter/material.dart';
import 'package:transfer_learning_fruit_veggies/events/add_food.dart';
import 'package:transfer_learning_fruit_veggies/model/food.dart';
import 'package:transfer_learning_fruit_veggies/services/local_storage_service.dart';

import 'package:transfer_learning_fruit_veggies/bloc/food_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  void initState() {
    Food food = Food(name: "mafood");
    //après add on rajoute levenement qu'on veut invoquer
    // on attend de recupérer notre food, une fois que cest fait
    // on préviens le bloc qu'on a ajouté de la food et qu'on la passer
    // dans storedfood, et apres rajout levenement addfood au bloc
    // et après la list devrait être uptaded ausi
    // previens le blocconsumer
    print("heeeeeeeeeeeeeloooooo page2");
    DatabaseProvider.db.insert(food).then(
          (storedFood) => BlocProvider.of<FoodBloc>(context).add(
            AddFood(storedFood),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
