import 'package:dio/dio.dart';
import 'package:estadisticapp/TabCountries.dart';
import 'package:estadisticapp/blocs/theme.dart';
import 'package:flutter/material.dart';
import 'package:estadisticapp/TabWorld.dart';
import 'package:provider/provider.dart';

getSummaryApi() async {
  var response = await Dio().get("https://api.covid19api.com/summary");

  if (response.statusCode == 200) {
    // print("Entré");
    // print(response.body);
    // print("Sali");
    // print("********************************************");
    return response.data;
  } else {
    throw Exception('Failed to load Countries');
  }
}

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData.light()),
      child: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch Data Example',
      theme: theme.getTheme(),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List futureCountries = [];
  Map<String, dynamic> futureSummary = {};

  int _currentIndex = 0;
  List<Widget> children = [CenterProgress(), CenterProgress()];

  bool isSwitched = false;

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getSummaryApi().then((data) {
      // print(data);
      // print("************************");
      // print(data["Global"]);
      // print("************************");
      // print(data["Countries"]);

      // print(data["Global"].runtimeType);

      setState(() {
        futureCountries = data["Countries"];
        futureSummary = data["Global"];
        children.clear();

        children = [
          TabWorld(futureSummary: futureSummary),
          TabCountries(futureCountries: futureCountries),
        ];
      }); //setState
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Estadísticas'),
        actions: <Widget>[
          Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
              });

              if (isSwitched == true) {
                _themeChanger.setTheme(ThemeData.dark());
              } else {
                _themeChanger.setTheme(ThemeData.light());
              }
            },
            activeColor: Colors.white,
          ),
        ],
      ),
      body: children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
                size: 32,
              ),
              title: Text(
                'Mundo',
                style: TextStyle(
                  fontSize: 18,
                ),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.business,
                size: 32,
              ),
              title: Text(
                'Paises',
                style: TextStyle(
                  fontSize: 18,
                ),
              )),
        ],
      ),
    );
  }
}

class CenterProgress extends StatelessWidget {
  const CenterProgress({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
