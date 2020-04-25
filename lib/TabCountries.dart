import 'package:estadisticapp/country.dart';
import 'package:flutter/material.dart';

class TabCountries extends StatefulWidget {
  const TabCountries({
    Key key,
    @required this.futureCountries,
  }) : super(key: key);

  final List futureCountries;

  @override
  _TabCountriesState createState() => _TabCountriesState();
}

class _TabCountriesState extends State<TabCountries> {
  bool ordenado = false;
  bool buscando = false;

  List filteredCountries = [];

  @override
  void initState() {
    filteredCountries = widget.futureCountries;
    super.initState();
  }

  void _filterCountries(value) {
    print(value);
    setState(() {
      filteredCountries = widget.futureCountries
          .where((country) =>
              country["Country"].toLowerCase().contains((value.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(filteredCountries.where((b) => b['Country'] == "Colombia"));
    return Center(
        child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextField(
                  onChanged: (value) {
                    _filterCountries(value);
                  },
                  decoration: InputDecoration(
                      icon: Icon(Icons.search), hintText: "Buscar pais"),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.sort,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    if (ordenado == false) {
                      filteredCountries.sort((b, a) =>
                          a["TotalConfirmed"].compareTo(b["TotalConfirmed"]));
                      ordenado = true;
                    } else {
                      filteredCountries
                          .sort((a, b) => a["Country"].compareTo(b["Country"]));
                      ordenado = false;
                    }
                  });
                },
              )
            ],
          ),
        ),
        filteredCountries.length > 0
              ? Expanded(
          child: ListCountries(futureCountries: filteredCountries)
              
        ): Text("No se encontraron paises"),
      ],
    ));
  }
}

class ListCountries extends StatelessWidget {
  const ListCountries({
    Key key,
    @required this.futureCountries,
  }) : super(key: key);

  final List futureCountries;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: futureCountries.length,
        itemBuilder: (BuildContext context, int index) {
          // return Text(futureCountries[index]["Country"]);
          return Card(
              child: InkWell(
            onTap: () {
              // print(futureCountries[index]);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Country(futureCountries[index]),
                ),
              );
            },
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        futureCountries[index]["Country"],
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          futureCountries[index]["TotalConfirmed"].toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ],
                )),
          ));
        },
      ),
    );
  }
}
