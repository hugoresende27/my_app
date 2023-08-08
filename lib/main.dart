import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}


//MyApp  STATELESS WIDGET----------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

  @override
  Widget build(BuildContext context) {
    Widget page;
      switch (selectedIndex) {
        case 0:
          page = GeneratorPage();
          break;
        case 1:
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
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600, //auto expand when horizontal, extended was false before
                  minWidth: 72, // Set your desired minimum width here
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
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
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
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
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    return Scaffold(
      body: Column(

        children: [
          Text('A random idea in my app:'),
          BigCard(pair: pair),
          SizedBox(height: 10),
           Row(
              mainAxisSize: MainAxisSize.min,  
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

  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}