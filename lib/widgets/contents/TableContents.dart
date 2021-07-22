import 'package:flutter/material.dart';

class TableContents {
  static Row makeTableRow(
      bool isHeader, List<String> cellsText, MaterialColor color) {
    return Row(
      children: cellsText
          .map(
            (cellText) => Expanded(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Container(
                  color: isHeader ? color[800] : color[400],
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: Center(
                    child: Text(
                      cellText,
                      style: isHeader
                          ? TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            )
                          : TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  static Row makeInfoRow(String header, double data, MaterialColor color) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Container(
              color: color[600],
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: Center(
                child: Text(
                  header,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Container(
              color: color[200],
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: Center(
                child: Text(
                  data.toStringAsFixed(2),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
