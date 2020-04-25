import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class InfoCard extends StatelessWidget {
  final String texto;
  final int casos;
  final Color fondo;

  InfoCard({
    Key key,
    @required this.texto,
    @required this.casos,
    @required this.fondo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      final formatter = new NumberFormat("#,###");

    return Card(
      elevation: 3,
      child: Container(
          padding: EdgeInsets.all(15),
          color: fondo,
          child: Column(
            children: <Widget>[
              Text(
                texto,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                formatter.format( casos),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
    );
  }
}
