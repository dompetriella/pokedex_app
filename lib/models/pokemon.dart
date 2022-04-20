class Pokemon {
  dynamic name = '';
  dynamic number = 0;
  dynamic image_url = '';
  dynamic api_image = '';
  dynamic height = '';
  dynamic weight = '';
  dynamic typeOne = '';
  dynamic typeTwo = '';
  dynamic ability = '';
  dynamic hp = 0;
  dynamic attack = 0;
  dynamic defense = 0;
  dynamic spAttack = 0;
  dynamic spDefense = 0;
  dynamic speed = 0;

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }



  Pokemon(this.name, this.number, this.image_url, this.height, this.weight);

  Pokemon.getInfo(dynamic pokemonName, Map<String, dynamic> pokemonObject) {
    name = pokemonName.toUpperCase();
    number = pokemonObject['id'];
    var str = "00" + number.toString();
    image_url = "https://assets.pokemon.com/assets/cms2/img/pokedex/full/${str.substring(str.length-3)}.png";
    api_image = pokemonObject['sprites']['front_default'];
    height = ((pokemonObject['height']/10)).toString();
    weight = (pokemonObject['weight']/10).toString();
    typeOne = pokemonObject['types'][0]["type"]["name"].toUpperCase();
    // try {
    //   typeTwo = pokemonObject['types'][1]["type"]["name"].toUpperCase();
    // }
    // on IndexError{
    //   typeTwo = '';
    // }
    ability = (pokemonObject['abilities'][0]['ability']['name'].replaceAll(RegExp('-'), ' ')).toUpperCase();
    hp = pokemonObject['stats'][0]["base_stat"];
    attack = pokemonObject['stats'][1]["base_stat"];
    defense = pokemonObject['stats'][2]["base_stat"];
    spAttack = pokemonObject['stats'][3]["base_stat"];
    spDefense = pokemonObject['stats'][4]["base_stat"];
    speed = pokemonObject['stats'][5]["base_stat"];
  }
}