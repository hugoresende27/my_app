import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
void main() {
  runApp(MyApp());
}


//MyApp  STATELESS WIDGET---------------------------------------------- theme, home:MyHomePage
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  //build the widget ******************/
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          navigationRailTheme: NavigationRailThemeData(
            selectedIconTheme: IconThemeData(size: 30.0), // Adjust the icon size
            selectedLabelTextStyle: TextStyle(
              fontSize: 16.0, // Adjust the font size
              color: Colors.black, // Change the text color to black
            ),
            
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

//MyAppState CHANGE NOTIFIER ----------------------------------------------
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  //Seguinte function
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}


//MyHomePage STATEFUL WIDGET ----------------------------------------------
  class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
//_MyHomePageState extends MyHomePage-----------------
class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0; 



  //build the widget ******************/
  @override
  Widget build(BuildContext context) {
    Widget page;
      switch (selectedIndex) {
        case 0:
          page = GeneratorPage();
          break;
        case 1:
          page = FavoritesPage(); 
          break;
        case 2:
          page = FavoritesPageTutorial(); 
          break;
        case 3:
          page = CountryNameWidget(); //placeholder marks a cross to dev 
          break;
        case 4:
          page = Placeholder(); //placeholder marks a cross to dev 
          break;
        default:
          throw UnimplementedError('no widget for $selectedIndex');
      }
    //SCAFFOLD --------------
    return LayoutBuilder(
      builder: (context, constraints) { //constriains here for horizontal expand auto
        return Scaffold(
          //ROW -------------
          body: Row(
            //2 children here --------------
            children: [
              //children SafeArea --side nav
              SafeArea(
                        // ----- child here -------//
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600, //auto expand when horizontal, extended was false before
                  minWidth: 72,
                   // Side menu nav here
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Generator'),
                    
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.face),
                      label: Text('Favorites'),
                    ),

                    NavigationRailDestination(
                      icon: Icon(Icons.photo_album),
                      label: Text('Album'),
                    ),
                    
                    NavigationRailDestination(
                      icon: Icon(Icons.yard),
                      label: Text('Yard'),
                    ),

          
                    
                     
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
                
              ),
              
              //children Expanded
              Expanded(
                        // ----- child here -------//
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  // child: GeneratorPage(),
                  child: page,
                ),
              ),
              
              
            ],
          ),
        );
      }
    );
  }
}

//GeneratorPage STATELESS WIDGET----------------------------------------------
class GeneratorPage extends StatelessWidget {

  //build the widget ******************/
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
                // ----- child here -------//
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
                    // ----- child here -------//
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                        // ----- child here -------//
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
  

  //build the widget ******************/
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      body: Column(
        // ----- child here -------//
        children: [
          Text('A random idea in my app:'),
          BigCard(pair: pair),
          SizedBox(height: 10),
           Row(
              mainAxisSize: MainAxisSize.min,  
              // ----- child here -------//
              children: [
                ElevatedButton(
                    onPressed: () {
                      print('botão pressionado debug console.log');
                      appState.getNext();
                    },
                    child: Text('Seguinte'),
                  ),
             ],
           ),
        ],
      ),
     
    );
  }


//BigCard STATELESS WIDGET----------------------------------------------
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  //build the widget ******************/
  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      // ----- child here -------//
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}


//FavoritesPage STATELESS WIDGET----------------------------------------------
class FavoritesPage extends StatelessWidget {

  //build the widget ******************/
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favorites = appState.favorites;

    if (appState.favorites.isEmpty) {
          return Center(
            child: Text('No favorites yet.'),
          );
        }

    return Center(
        // ----- child here -------//
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Favorites'),
                // ----- child here -------//
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(favorites[index].asLowerCase),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



//FavoritesPage STATELESS WIDGET----------------------------------------------
class FavoritesPageTutorial extends StatelessWidget {

  //build the widget ******************/
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favorites = appState.favorites;

    if (appState.favorites.isEmpty) {
          return Center(
            child: Text('No favorites yet.'),
          );
        }

     return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
    
  }
}

class Country {
  final String common;

  Country({required this.common});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      common: json['name']['common'],
    );
  }
}

Future<Country> fetchCountry() async {
  final response = await http.get(Uri.parse('https://restcountries.com/v3.1/independent?status=true'));

  if (response.statusCode == 200) {
    final dynamic jsonResponse = json.decode(response.body);

    // Parse the country name
    final country = Country.fromJson(jsonResponse);
    
    return country;
  } else {
    throw Exception('Failed to load country');
  }
}

class CountryNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    late Future<Country> futureCountry;
    futureCountry = fetchCountry();

    return MaterialApp(
      title: 'Country Name Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Country Name Example'),
        ),
        body: Center(
          child: FutureBuilder<Country>(
            future: futureCountry,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Display the country name
                return Text(snapshot.data!.common);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}