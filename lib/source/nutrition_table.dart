// 100 ml
//ajout coffe and tea
// density: g/ml

/*
id, name, quantity(100ml), cal(cal/100ml), masse volumique: mv (g/ml) [1 cm^3 = 1 ml]
*/
List<Map> drinkNutritionJson = [

  {"id": '1', "name": "Coffee", "quantity": "100", "cal": "1", "mv": "1"},
  {"id": '2', "name": "Coke", "quantity": "100", "cal": "42", "mv": "1.02"},
  {"id": '3', "name": "IcedTea", "quantity": "100", "cal": "27", "mv": "1.03"},
  {"id": '4', "name": "Water", "quantity": "100", "cal": "0", "mv": "1"},
  {"id": '5', "name": "Beer", "quantity": "100", "cal": "43", "mv": "1"},
  {"id": '6', "name": "Wine", "quantity": "100", "cal": "83", "mv": "0.99"},
  {"id": '7', "name": "Whiskey", "quantity": "100", "cal": "250", "mv": "0.93"},
  {"id": '8', "name": "Vodka", "quantity": "100", "cal": "231", "mv": "0.95"},
  {"id": '9', "name": "Tea", "quantity": "100", "cal": "1000", "mv": "1"},
];

//quantity: 100 g
/*
id, name, cal(cal/100g), nutriscore (A-D) , eq: 266 ml (=100g) 1 ml = 1 cm^3, glucide: en g
vm (g/ml)
*/
List<Map> foodNutritionJson = [
  {
    "id": '1',
    "name": 'Leafy Greens 🥬',
    "cal": 20.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.10
  },
  {
    "id": '2',
    "name": "Stem Vegetables 🥦",
    "cal": 35.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.60
  },
  {
    "id": '3',
    "name": "Non-starchy Roots 🍅",
    "cal": 38.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.60
  },
  {
    "id": '4',
    "name": "Vegetables | Other 🌽",
    "cal": 25.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.20
  },
  {
    "id": '5',
    "name": "Fruits 🍓",
    "cal": 55.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.25
  },
  {
    "id": '6',
    "name": "Protein | Meat 🥩",
    "cal": 250.0,
    "nutriscore": "D",
    "glucide": "N/A",
    "vm": 0.95
  },
  {
    "id": '7',
    "name": "Protein | Poultry 🍗",
    "cal": 140.0,
    "nutriscore": "C",
    "glucide": "N/A",
    "vm": 0.90
  },
  {
    "id": '8',
    "name": "Protein | Seafood 🐟",
    "cal": 110.0,
    "nutriscore": "B",
    "glucide": "N/A",
    "vm": 0.75
  },
  {
    "id": '9',
    "name": "Protein | Eggs 🍳",
    "cal": 140.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.6
  },
  //http://www.fao.org/3/ap815e/ap815e.pdf
  {
    "id": '10',
    "name": "Protein | Beans/nuts 🥜",
    "cal": 630.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.55
  },
  {
    "id": '11',
    "name": "Starches/grains | Baked Goods 🥐",
    "cal": 280.0,
    "nutriscore": "D",
    "glucide": "N/A",
    "vm": 0.4
  },
  {
    "id": '12',
    "name": "Starches/grains | rice/grains/cereals 🍚",
    "cal": 95.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.7
  },
  {
    "id": '13',
    "name": "Starches/grains | Noodles/pasta 🍝",
    "cal": 90.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.56
  },
  {
    "id": '14',
    "name": "Starches/grains | Starchy Vegetables 🥔",
    "cal": 350.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.7
  },
  {
    "id": '15',
    "name": "Starches/grains | Other 🌾",
    "cal": 95.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.7
  },
  {
    "id": '16',
    "name": "Soups/stews 🥣",
    "cal": 30.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 1.0
  },
  {
    "id": '17',
    "name": "Herbs/spices 🌿",
    "cal": 20.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.30
  },
  {
    "id": '18',
    "name": "Dairy 🥛",
    "cal": 330.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.35
  },
  {
    "id": '19',
    "name": "Snacks 🍫",
    "cal": 560.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.1
  }, //
  {
    "id": '20',
    "name": "Sweets/desserts 🍰",
    "cal": 400.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.5
  }, //on prendra aussi le donut ?
  {
    "id": '21',
    "name": "Beverages 🥤",
    "cal": 0.0,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 1.0
  }, // cf la partie boisson
  {
    "id": '22',
    "name": "Fats/oils/sauces 🥫",
    "cal": 250.0,
    "nutriscore": "D",
    "glucide": "N/A",
    "vm": 0.8
  },

  // {"id": '7', "name": "Seafood", "cal": "143000"}, //
  //{"id": '8', "name": "Dairy", "cal": "129000"}, //
];
