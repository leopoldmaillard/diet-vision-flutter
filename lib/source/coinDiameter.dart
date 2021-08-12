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
  {"id": '1', "coin": "euro", "country": "Germany", "code": "DE"},
  {"id": '2', "coin": "euro", "country": "Andorra", "code": "AD"},
  {"id": '3', "coin": "euro", "country": "Austria", "code": "AT"},
  {"id": '4', "coin": "euro", "country": "Belgium", "code": "BE"},
  {"id": '5', "coin": "euro", "country": "Cyprus", "code": "CY"},
  {"id": '6', "coin": "euro", "country": "Spain", "code": "ES"},
  {"id": '7', "coin": "euro", "country": "Estonia", "code": "EE"},
  {"id": '8', "coin": "euro", "country": "Finland", "code": "FI"},
  {"id": '9', "coin": "euro", "country": "France", "code": "FR"},
  {"id": '10', "coin": "euro", "country": "Greece", "code": "GR"},
  {"id": '11', "coin": "euro", "country": "Irelande", "code": "IE"},
  {"id": '12', "coin": "euro", "country": "Italy", "code": "IT"},
  {"id": '14', "coin": "euro", "country": "Letton", "code": "LV"},
  {"id": '15', "coin": "euro", "country": "Lithuania", "code": "LT"},
  {"id": '16', "coin": "euro", "country": "Luxembourg", "code": "LU"},
  {"id": '17', "coin": "euro", "country": "Malta", "code": "MT"},
  {"id": '18', "coin": "euro", "country": "Monaco", "code": "MC"},
  {"id": '19', "coin": "euro", "country": "Montenegro", "code": "ME"},
  {"id": '20', "coin": "euro", "country": "Netherlands", "code": "NL"},
  {"id": '21', "coin": "euro", "country": "Portugal", "code": "PT"},
  {"id": '22', "coin": "euro", "country": "Saint Martin", "code": "MF"},
  {"id": '23', "coin": "euro", "country": "Slovakia", "code": "SK"},
  {"id": '24', "coin": "euro", "country": "SlovéniA", "code": "SI"},
  {"id": '25', "coin": "euro", "country": "Vatican", "code": "VA"},
  //Livre Sterling
  {
    "id": '26',
    "coin": "livre_sterling",
    "country": "United Kingdom",
    "code": "GB"
  },
  {"id": '27', "coin": "livre_sterling", "country": "England", "code": "ENG"},
  {"id": '28', "coin": "livre_sterling", "country": "Scotland", "code": "SCT"},
  {"id": '29', "coin": "livre_sterling", "country": "Jersey", "code": "JE"},
  {"id": '30', "coin": "livre_sterling", "country": "Gibraltar", "code": "GI"},
  {
    "id": '31',
    "coin": "livre_sterling",
    "country": "Pays de Galles",
    "code": "WAL"
  },
  {
    "id": '32',
    "coin": "livre_sterling",
    "country": "Isle of Man",
    "code": "IM"
  },
  {"id": '34', "coin": "livre_sterling", "country": "Guernsey", "code": "GG"},
  {
    "id": '35',
    "coin": "livre_sterling",
    "country": "Georgie South",
    "code": "GE"
  },
  {
    "id": '36',
    "coin": "livre_sterling",
    "country": "Saint Helena",
    "code": "SH"
  },

  //dollar
  //American
  {
    "id": '37',
    "coin": "american_dollar",
    "country": "United States",
    "code": "US"
  },
  {
    "id": '38',
    "coin": "american_dollar",
    "country": "Puerto Rico",
    "code": "PR"
  },
  {
    "id": '39',
    "coin": "american_dollar",
    "country": "El Salvador",
    "code": "SV"
  },
  {
    "id": '40',
    "coin": "american_dollar",
    "country": "Equatorial Guinea",
    "code": "GQ"
  },
  {
    "id": '41',
    "coin": "american_dollar",
    "country": "Turks and Caicos Islands",
    "code": "TC"
  },
  {"id": '42', "coin": "american_dollar", "country": "Panama", "code": "PA"},
  {"id": '43', "coin": "american_dollar", "country": "Somalia", "code": "SO"},
  {"id": '44', "coin": "american_dollar", "country": "Zimbabwe", "code": "ZW"},
  {"id": '45', "coin": "american_dollar", "country": "Guam", "code": "GU"},
  {
    "id": '46',
    "coin": "american_dollar",
    "country": "Virgin Islands, U.S.",
    "code": "VI"
  },
  {"id": '47', "coin": "american_dollar", "country": "Palau", "code": "PW"},
  {
    "id": '48',
    "coin": "american_dollar",
    "country": "Marshall Islands",
    "code": "MH"
  },
  {
    "id": '49',
    "coin": "american_dollar",
    "country": "AmericanSamoa",
    "code": "AS"
  },
  {
    "id": '50',
    "coin": "american_dollar",
    "country": "Micronesia, Federated States of Micronesia",
    "code": "FM"
  },
  {
    "id": '51',
    "coin": "american_dollar",
    "country": "Northern Mariana Islands",
    "code": "MP"
  },
  {
    "id": '52',
    "coin": "american_dollar",
    "country": "Caribbean Netherlands",
    "code": "BQ"
  },
  //Canadien
  {"id": '54', "coin": "canadien_dollar", "country": "Canada", "code": "CA"},
];
