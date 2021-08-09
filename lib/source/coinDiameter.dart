// 1 inch = 2.54 cm (USA, Liberia et Birmanie)
// website used:
//https://www.blog-note.com/diametre-des-pieces-de-monnaie-e-euro-dollar-livre/
List<Map> coinDiameterJson = [
  //American Dollar
  {
    "id": '1',
    "coin": "american_dollar",
    "value": "1_c",
    "diameter_inch": 0.75,
    "diameter_mm": 19,
  }, // 1 cent
  {
    "id": '2',
    "coin": "american_dollar",
    "value": "5_c",
    "diameter_inch": 0.79,
    "diameter_mm": 20,
  },
  {
    "id": '3',
    "coin": "american_dollar",
    "value": "10_c",
    "diameter_inch": 0.71,
    "diameter_mm": 18,
  },
  {
    "id": '4',
    "coin": "american_dollar",
    "value": "25_c",
    "diameter_inch": 0.94,
    "diameter_mm": 24,
  }, // the most commonly used
  {
    "id": '5',
    "coin": "american_dollar",
    "value": "50_c",
    "diameter_inch": 1.22,
    "diameter_mm": 31,
  },
  {
    "id": '6',
    "coin": "american_dollar",
    "value": "1_d",
    "diameter_inch": 1.02,
    "diameter_mm": 26,
  },

  // Canadien Dollar
  {
    "id": '7',
    "coin": "canadien_dollar",
    "value": "1_c",
    "diameter_inch": 0.75,
    "diameter_mm": 19,
  },
  {
    "id": '8',
    "coin": "canadien_dollar",
    "value": "5_c",
    "diameter_inch": 0.83,
    "diameter_mm": 21,
  },
  {
    "id": '9',
    "coin": "canadien_dollar",
    "value": "10_c",
    "diameter_inch": 0.71,
    "diameter_mm": 18,
  },
  {
    "id": '10',
    "coin": "canadien_dollar",
    "value": "25_c",
    "diameter_inch": 0.94,
    "diameter_mm": 24,
  },
  {
    "id": '11',
    "coin": "canadien_dollar",
    "value": "50_c",
    "diameter_inch": 1.07,
    "diameter_mm": 27,
  },
  {
    "id": '12',
    "coin": "canadien_dollar",
    "value": "1_d",
    "diameter_inch": 1.02,
    "diameter_mm": 26,
  },
  {
    "id": '13',
    "coin": "canadien_dollar",
    "value": "2_d",
    "diameter_inch": 1.1,
    "diameter_mm": 28,
  },
  // Livre Sterling
  {
    "id": '14',
    "coin": "livre_sterling",
    "value": "1_p",
    "diameter_inch": 0.8,
    "diameter_mm": 20.32,
  },
  {
    "id": '15',
    "coin": "livre_sterling",
    "value": "2_p",
    "diameter_inch": 1.02,
    "diameter_mm": 25.91,
  },
  {
    "id": '16',
    "coin": "livre_sterling",
    "value": "5_p",
    "diameter_inch": 0.71,
    "diameter_mm": 18,
  },
  {
    "id": '17',
    "coin": "livre_sterling",
    "value": "10_p",
    "diameter_inch": 0.96,
    "diameter_mm": 24.05,
  },
  {
    "id": '18',
    "coin": "livre_sterling",
    "value": "20_p",
    "diameter_inch": 0.84,
    "diameter_mm": 21.4,
  },
  {
    "id": '19',
    "coin": "livre_sterling",
    "value": "50_p",
    "diameter_inch": 1.07,
    "diameter_mm": 27.3,
  },
  {
    "id": '20',
    "coin": "livre_sterling",
    "value": "1_l",
    "diameter_inch": 0.89,
    "diameter_mm": 22.5,
  },
  {
    "id": '21',
    "coin": "livre_sterling",
    "value": "2_l",
    "diameter_inch": 0.89,
    "diameter_mm": 28.4,
  },
  // Euro
  {
    "id": '22',
    "coin": "euro",
    "value": "1 Euro cent",
    "diameter_inch": 0.64,
    "diameter_mm": 16.25,
  },
  {
    "id": '23',
    "coin": "euro",
    "value": "2 Euro cent",
    "diameter_inch": 0.74,
    "diameter_mm": 18.75,
  },
  {
    "id": '24',
    "coin": "euro",
    "value": "5 Euro cent",
    "diameter_inch": 0.84,
    "diameter_mm": 21.25,
  },
  {
    "id": '25',
    "coin": "euro",
    "value": "10 Euro cent",
    "diameter_inch": 0.78,
    "diameter_mm": 19.75,
  },
  {
    "id": '26',
    "coin": "euro",
    "value": "20 Euro cent",
    "diameter_inch": 0.88,
    "diameter_mm": 22.25,
  },
  {
    "id": '27',
    "coin": "euro",
    "value": "50 Euro cent",
    "diameter_inch": 0.95,
    "diameter_mm": 24.25,
  },
  {
    "id": '28',
    "coin": "euro",
    "value": "1 Euro",
    "diameter_inch": 0.92,
    "diameter_mm": 23.25,
  },
  {
    "id": '29',
    "coin": "euro",
    "value": "2 Euro",
    "diameter_inch": 1.01,
    "diameter_mm": 25.75,
  },
];

List<Map> coinCountryJson = [
  // Europe
  {"id": '1', "coin": "euro", "country": "Allemagne"},
  {"id": '2', "coin": "euro", "country": "Andorre"},
  {"id": '3', "coin": "euro", "country": "Autriche"},
  {"id": '4', "coin": "euro", "country": "Belgique"},
  {"id": '5', "coin": "euro", "country": "Chypre"},
  {"id": '6', "coin": "euro", "country": "Espagne"},
  {"id": '7', "coin": "euro", "country": "Estonie"},
  {"id": '8', "coin": "euro", "country": "Finlande"},
  {"id": '9', "coin": "euro", "country": "France"},
  {"id": '10', "coin": "euro", "country": "Grèce"},
  {"id": '11', "coin": "euro", "country": "Irlande"},
  {"id": '12', "coin": "euro", "country": "Italie"},
  {"id": '13', "coin": "euro", "country": "Kosovo"},
  {"id": '14', "coin": "euro", "country": "Lettonie"},
  {"id": '15', "coin": "euro", "country": "Lituanie"},
  {"id": '16', "coin": "euro", "country": "Luxembourg"},
  {"id": '17', "coin": "euro", "country": "Malte"},
  {"id": '18', "coin": "euro", "country": "Monaco"},
  {"id": '19', "coin": "euro", "country": "Monténégro"},
  {"id": '20', "coin": "euro", "country": "Pays-Bas"},
  {"id": '21', "coin": "euro", "country": "Portugal"},
  {"id": '22', "coin": "euro", "country": "Saint-Martin"},
  {"id": '23', "coin": "euro", "country": "Slovaquie"},
  {"id": '24', "coin": "euro", "country": "Slovénie"},
  {"id": '25', "coin": "euro", "country": "Vatican"},
  //Livre Sterling
  {"id": '26', "coin": "livre_sterling", "country": "Royaume-Uni"},
  {"id": '27', "coin": "livre_sterling", "country": "Angleterre"},
  {"id": '28', "coin": "livre_sterling", "country": "Ecosse"},
  {"id": '29', "coin": "livre_sterling", "country": "Jersey"},
  {"id": '30', "coin": "livre_sterling", "country": "Gibraltar"},
  {"id": '31', "coin": "livre_sterling", "country": "Pays_de_Galles"},
  {"id": '32', "coin": "livre_sterling", "country": "Ile_de_Man"},
  {"id": '33', "coin": "livre_sterling", "country": "Irlande_du_Nord"},
  {"id": '34', "coin": "livre_sterling", "country": "Guernesey"},
  {"id": '35', "coin": "livre_sterling", "country": "Georgie_Sud"},
  {"id": '36', "coin": "livre_sterling", "country": "Sainte-Hélène"},

  //dollar
  //American
  {"id": '37', "coin": "american_dollar", "country": "États-Unis"},
  {"id": '38', "coin": "american_dollar", "country": "Porto_Rico"},
  {"id": '39', "coin": "american_dollar", "country": "El_Salvador"},
  {"id": '40', "coin": "american_dollar", "country": "Equateur"},
  {"id": '41', "coin": "american_dollar", "country": "Iles_Turks_et_Caîques"},
  {"id": '42', "coin": "american_dollar", "country": "Panama"},
  {"id": '43', "coin": "american_dollar", "country": "Somalie"},
  {"id": '44', "coin": "american_dollar", "country": "Zimbabwe"},
  {"id": '45', "coin": "american_dollar", "country": "Guam"},
  {"id": '46', "coin": "american_dollar", "country": "Iles_Vierges_Etats-Unis"},
  {"id": '47', "coin": "american_dollar", "country": "Palaos"},
  {"id": '48', "coin": "american_dollar", "country": "Iles_Marshall"},
  {"id": '49', "coin": "american_dollar", "country": "Samoa_americaines"},
  {"id": '50', "coin": "american_dollar", "country": "Micronésie"},
  {"id": '51', "coin": "american_dollar", "country": "Iles_Mariannes_du_Nord"},
  {"id": '52', "coin": "american_dollar", "country": "Pays-Bas_caribéens"},
  {"id": '53', "coin": "american_dollar", "country": "Bonaire"},

  //Canadien
  {"id": '54', "coin": "canadien_dollar", "country": "Canada"},
];
