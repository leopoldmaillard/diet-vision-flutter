/*
Database for this JSON:
https://docs.google.com/spreadsheets/d/1X1sPuft4cAvtiTXAFU1oabpTz5xuHhgKZi5MVBJw578/edit#gid=0
also taken from 
https://docs.google.com/spreadsheets/d/1snqE6leDkZlL61qQ4g-vUmiFjizJyN1OCVAhwWWKSm4/edit#gid=,
id, name, quantity(100ml), cal(cal/100ml), masse volumique: mv (g/ml) [1 cm^3 = 1 ml]
*/
List<Map> drinkNutritionJson = [
  {
    "id": '1',
    "name": "Select your drink  ",
    "cal": 0.0,
    "fat": 0.0,
    "protein": 0.0,
    "carbohydrates": 0.0,
    "sugar": 0.0,
    "nutriscore": "A",
    "vm": 0.0
  },
  {
    "id": '2',
    "name": "Soda", //Coke in the database of nutrition
    "cal": 42,
    "fat": 0.2,
    "protein": 0.0,
    "carbohydrates": 0.0,
    "sugar": 10.6,
    "nutriscore": "A",
    "vm": 1.02
  },
  {
    "id": '3',
    "name": "Iced Tea",
    "cal": 33,
    "fat": 0.03,
    "protein": 0.2,
    "carbohydrates": 9.17,
    "sugar": 7.2,
    "nutriscore": "A",
    "vm": 1.03
  },
  {
    "id": '4',
    "name": "Water",
    "cal": 0.0,
    "fat": 0.0,
    "protein": 0.0,
    "carbohydrates": 0.0,
    "sugar": 0.0,
    "nutriscore": "A",
    "vm": 1
  },
  {
    "id": '5',
    "name": "Juice",
    "cal": 48.0,
    "fat": 0.12,
    "protein": 0.68,
    "carbohydrates": 11.45,
    "sugar": 8.31,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 1.0
  },
  {
    "id": '6',
    "name": "Beer",
    "cal": 43.0,
    "fat": 0.0,
    "protein": 0.46,
    "carbohydrates": 3.55,
    "sugar": 0.0,
    "nutriscore": "A",
    "vm": 1.0
  },
  {
    "id": '7',
    "name": "Wine",
    "cal": 78.0,
    "fat": 0.0,
    "protein": 0.07,
    "carbohydrates": 2.38,
    "sugar": 3.8,
    "nutriscore": "A",
    "vm": 0.99
  },
  {
    "id": '8',
    "name": "Whiskey",
    "cal": 250,
    "fat": 0.0,
    "protein": 0.0,
    "carbohydrates": 0.1,
    "sugar": 0.1,
    "nutriscore": "A",
    "vm": 0.93
  },
  {
    "id": '9',
    "name": "Vodka",
    "cal": 231,
    "fat": 0.0,
    "protein": 0.0,
    "carbohydrates": 0.0,
    "sugar": 0.0,
    "nutriscore": "A",
    "vm": 0.95
  },
  {
    "id": '10',
    "name": "Tea",
    "cal": 1.0,
    "fat": 0.0,
    "protein": 0.0,
    "carbohydrates": 0.2,
    "sugar": 0.0,
    "nutriscore": "A",
    "vm": 1.0
  },
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
    "cal": 21.0,
    "fat": 0.2,
    "protein": 1.2,
    "carbohydrates": 4.42,
    "sugar": 1.88,
    "nutriscore": "A",
    "vm": 0.10
  },
  {
    "id": '2',
    "name": "Stem Vegetables 🥦",
    "cal": 28.0,
    "fat": 0.17,
    "protein": 1.49,
    "carbohydrates": 6.45,
    "sugar": 1.88,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.60
  },
  {
    "id": '3',
    "name": "Non-starchy Roots 🍅",
    "cal": 59,
    "fat": 3,
    "protein": 0.73,
    "carbohydrates": 7.94,
    "sugar": 3.33,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.60
  },
  {
    "id": '4',
    "name": "Vegetables | Other 🌽",
    "cal": 18,
    "fat": 0.11,
    "protein": 0.95,
    "carbohydrates": 3.99,
    "sugar": 2.48,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.20
  },
  {
    "id": '5',
    "name": "Fruits 🍓",
    "cal": 57,
    "fat": 0.15,
    "protein": 0.28,
    "carbohydrates": 13.6,
    "sugar": 10.04,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.25
  },
  {
    "id": '6',
    "name": "Protein | Meat 🥩",
    "cal": 260,
    "fat": 16.82,
    "protein": 25.54,
    "carbohydrates": 0,
    "sugar": 0,
    "nutriscore": "D",
    "glucide": "N/A",
    "vm": 0.95
  },
  {
    "id": '7',
    "name": "Protein | Poultry 🍗",
    "cal": 271,
    "fat": 13.95,
    "protein": 19.22,
    "carbohydrates": 17.25,
    "sugar": 0.4,
    "nutriscore": "C",
    "glucide": "N/A",
    "vm": 0.90
  },
  {
    "id": '8',
    "name": "Protein | Seafood 🐟",
    "cal": 188,
    "fat": 9.06,
    "protein": 25.08,
    "carbohydrates": 0.1,
    "sugar": 0.04,
    "nutriscore": "B",
    "glucide": "N/A",
    "vm": 0.75
  },
  {
    "id": '9',
    "name": "Protein | Eggs 🍳",
    "cal": 209,
    "fat": 14.97,
    "protein": 15.64,
    "carbohydrates": 1.52,
    "sugar": 1.06,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.6
  },
  //http://www.fao.org/3/ap815e/ap815e.pdf
  {
    "id": '10',
    "name": "Protein | Beans/nuts 🥜",
    "cal": 605,
    "fat": 53.62,
    "protein": 19.59,
    "carbohydrates": 21.04,
    "sugar": 4.53,
    "nutriscore": "A",
    "vm": 0.55
  },
  {
    "id": '11',
    "name": "Starches/grains | Baked Goods 🥐",
    "cal": 270,
    "fat": 3.42,
    "protein": 8.62,
    "carbohydrates": 50.09,
    "sugar": 3.14,
    "nutriscore": "D",
    "vm": 0.4
  },
  {
    "id": '12',
    "name": "Starches/grains | rice/grains/cereals 🍚",
    "cal": 129,
    "fat": 0.28,
    "protein": 2.67,
    "carbohydrates": 27.99,
    "sugar": 0.05,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.7
  },
  {
    "id": '13',
    "name": "Starches/grains | Noodles/pasta 🍝",
    "cal": 157,
    "fat": 0.92,
    "protein": 5.76,
    "carbohydrates": 30.68,
    "sugar": 0.56,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.56
  },
  {
    "id": '14',
    "name": "Starches/grains | Starchy Vegetables 🥔",
    "cal": 113,
    "fat": 4.22,
    "protein": 1.86,
    "carbohydrates": 16.81,
    "sugar": 1.43,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.7
  },
  {
    "id": '15',
    "name": "Starches/grains | Other 🌾",
    "cal": 113,
    "fat": 4.22,
    "protein": 1.86,
    "carbohydrates": 16.81,
    "sugar": 1.43,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.7
  },
  {
    "id": '16',
    "name": "Soups/stews 🥣",
    "cal": 28,
    "fat": 0.79,
    "protein": 0.86,
    "carbohydrates": 4.89,
    "sugar": 1.57,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 1.0
  },
  {
    "id": '17',
    "name": "Herbs/spices 🌿",
    "cal": 315,
    "fat": 12.75,
    "protein": 10.63,
    "carbohydrates": 60.73,
    "sugar": 1.71,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.30
  },
  {
    "id": '18',
    "name": "Dairy 🥛",
    "cal": 334,
    "fat": 27.68,
    "protein": 20.75,
    "carbohydrates": 0.45,
    "sugar": 0.45,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.35
  },
  {
    "id": '19',
    "name": "Snacks 🍫",
    "cal": 515,
    "fat": 25.91,
    "protein": 1.34,
    "carbohydrates": 69.23,
    "sugar": 3.36,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.1
  }, //
  {
    "id": '20',
    "name": "Sweets/desserts 🍰",
    "cal": 401,
    "fat": 16.95,
    "protein": 2.94,
    "carbohydrates": 63.55,
    "sugar": 47.22,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 0.5
  },
  {
    "id": '21',
    "name": "Beverages 🥤",
    "cal": 48,
    "fat": 0.12,
    "protein": 0.68,
    "carbohydrates": 11.45,
    "sugar": 8.31,
    "nutriscore": "A",
    "glucide": "N/A",
    "vm": 1.0
  }, // cf la partie boisson
  {
    "id": '22',
    "name": "Fats/oils/sauces 🥫",
    "cal": 688,
    "fat": 77.8,
    "protein": 0,
    "carbohydrates": 0.3,
    "sugar": 0.3,
    "nutriscore": "Z",
    "glucide": "N/A",
    "vm": 0.8
  },
];
