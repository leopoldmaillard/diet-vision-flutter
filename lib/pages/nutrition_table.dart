// 100 ml
//ajout coffe and tea
// density: g/ml

/*
id, name, quantity(100ml), cal(cal/100ml), masse volumique: mv (g/ml) [1 cm^3 = 1 ml]
*/
List<Map> drinkNutritionJson = [
  {"id": '1', "name": "Coffee", "quantity": "100", "cal": "1000", "mv": "1"},
  {"id": '2', "name": "Coke", "quantity": "100", "cal": "42000", "mv": "1.02"},
  {
    "id": '3',
    "name": "IcedTea",
    "quantity": "100",
    "cal": "27000",
    "mv": "1.03"
  },
  {"id": '4', "name": "Water", "quantity": "100", "cal": "0", "mv": "1"},
  {"id": '5', "name": "Beer", "quantity": "100", "cal": "43000", "mv": "1"},
  {"id": '6', "name": "Wine", "quantity": "100", "cal": "83000", "mv": "0.99"},
  {
    "id": '7',
    "name": "Whiskey",
    "quantity": "100",
    "cal": "250000",
    "mv": "0.93"
  },
  {
    "id": '8',
    "name": "Vodka",
    "quantity": "100",
    "cal": "231000",
    "mv": "0.95"
  },
  {"id": '9', "name": "Tea", "quantity": "100", "cal": "1000", "mv": "1"},
];

//quantity: 100 g
/*
id, name, cal(cal/100g), nutriscore (A-D) , eq: 266 ml (=100g) 1 ml = 1 cm^3, glucide: en g
*/
List<Map> foodNutritionJson = [
  {
    "id": '1',
    "name": "Leafy Greens",
    "cal": "27000",
    "nutriscore": "A",
    "glucide": "2.33",
    "eq": "266"
  }, // poireau
  {
    "id": '2',
    "name": "Stem Vegetables",
    "cal": "27000",
    "nutriscore": "A",
    "glucide": "2.33",
    "eq": "266"
  }, // poireau
  {
    "id": '3',
    "name": "Non-starchy Roots",
    "cal": "40000",
    "nutriscore": "A",
    "glucide": "7.59",
    "eq": "194"
  }, // carotte
  {
    "id": '4',
    "name": "Vegetables | Other",
    "cal": "37000",
    "nutriscore": "A",
    "glucide": "2.53",
    "eq": "269"
  }, // brocoli
  {
    "id": '5',
    "name": "Fruits",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  }, // pomme
  {
    "id": '6',
    "name": "Protein | Meat",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  }, // boeuf
  {
    "id": '7',
    "name": "Protein | Poultry",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '8',
    "name": "Protein | Seafood",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '9',
    "name": "Protein | Eggs",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '10',
    "name": "Protein | Beans/nuts",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '11',
    "name": "Starches/grains | Baked Goods",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '12',
    "name": "Starches/grains | rice/grains/cereals",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '13',
    "name": "Starches/grains | Noodles/pasta",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '14',
    "name": "Starches/grains | Starchy Vegetables",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '15',
    "name": "Non-starchy Roots",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '16',
    "name": "Starches/grains | Other",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '17',
    "name": "Soups/stews",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '18',
    "name": "Herbs/spices",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '19',
    "name": "Dairy",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '20',
    "name": "Snacks",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '21',
    "name": "Sweets/desserts",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '22',
    "name": "Beverages",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },
  {
    "id": '23',
    "name": "Fats/oils/sauces",
    "cal": "53000",
    "nutriscore": "A",
    "glucide": "11.40",
    "eq": "215"
  },

  // {"id": '7', "name": "Seafood", "cal": "143000"}, //
  //{"id": '8', "name": "Dairy", "cal": "129000"}, //
];
