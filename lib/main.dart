import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'models/pokemon.dart';

void main() {
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        backgroundColor: Colors.blueGrey
      ),
      home: const MyHomePage(title: 'Pokedex'),
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
  int pokemonLimit = 251;
  int currentPokemonLimit = 25;
  List<Widget> PokemonCardsList = [];

  Widget PokemonCard(Pokemon pokemon) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.0
        ),
        borderRadius: BorderRadius.circular(5),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text("#${pokemon.number.toString()} ${pokemon.name}"),
              Image(
                image: NetworkImage(pokemon.api_image.toString()),
              ),
              Text("Height: ${pokemon.height}m"),
              Text("Weight: ${pokemon.weight}kg"),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 20,
                      width: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: getTypeColor(pokemon.typeOne.toString())
                      ),
                      margin: EdgeInsets.all(5),
                      child: Center(
                        child: Text(
                          pokemon.typeOne.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                            color: Colors.white,
                            
                          ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ability"),
              Text(pokemon.ability.toString() + "\n"),
              Text("HP: ${pokemon.hp}"),
              Text("ATK: ${pokemon.attack}"),
              Text("DEF: ${pokemon.defense}"),
              Text("SpATK: ${pokemon.spAttack}"),
              Text("SpDEF: ${pokemon.spDefense}"),
              Text("SPD: ${pokemon.speed}")
            ],
          ),
        ],
      ),
    );
  }


Future<Response> fetch(String url) async {
  Response response;
  try {
    response = await Dio().get(url);
  }
  on DioError catch (e) {
    print(e.message);
    throw Exception(e.message);
  }
  return response;
}

  void getPokemon() async{ 
    var snack = SnackBar(
      content: Text("Loading ${currentPokemonLimit.toString()} pokemon..."),
      duration: Duration(milliseconds: 800),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);

    dynamic pokemonName = "bulbasaur";
    var result = await fetch("https://pokeapi.co/api/v2/pokemon?limit=${currentPokemonLimit}");
    var resultPokemonList = result.data['results'];
    List<Widget> pokemonList = [];
    for (dynamic mon in resultPokemonList) {
      pokemonName = mon['name'];
      final dynamic futureMon = await fetch("https://pokeapi.co/api/v2/pokemon/$pokemonName");
      Pokemon pokemonObject = Pokemon.getInfo(pokemonName, futureMon.data as Map<String, dynamic>);
      pokemonList.add(PokemonCard(pokemonObject));
    };

    setState(() {
      PokemonCardsList = pokemonList;
    });
  }

  Color getTypeColor(String pkType) {
    switch(pkType) {
      case "GRASS": return Colors.green;
      case "WATER": return Colors.blue;
      case "FIRE": return Colors.red;
      case "BUG": return Colors.lightGreen;
      case "POISON": return Colors.purple;
      case "NORMAL": return Colors.grey;
      case "ELECTRIC": return Colors.yellow;
      case "ICE": return Colors.lightBlue;
      case "FIGHTING": return Colors.deepOrange;
      case "GROUND": return Colors.amber;
      case "FLYING": return Colors.teal;
      case "PSYCHIC": return Colors.orange;
      case "ROCK": return Colors.brown;
      case "GHOST": return Colors.indigo;
      case "DARK": return Colors.deepPurple;
      case "DRAGON": return Colors.blueGrey;
      case "FAIRY": return Colors.pink;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {

    final double viewHeight = MediaQuery.of(context).size.height;
    final double viewWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("PokeDex App"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Displaying ${currentPokemonLimit} pokemon'),
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: currentPokemonLimit.toDouble(), 
                  label: currentPokemonLimit.toString(),
                  min: 1,
                  max: 250,
                  divisions: pokemonLimit.toInt(),
                  onChanged: (double newCurrent) {
                    setState(() {
                      currentPokemonLimit = newCurrent.toInt();
                    });
                  }),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () => getPokemon(), 
                  child: Text("GET MON")),
              )
            ],
          ),

          Expanded(
            child: Container(
              width: viewWidth * .75,
              child: ListView(
                children: PokemonCardsList
              ),
            ),
          ),
        ],
      ),
    );
  }
}
