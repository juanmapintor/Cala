import 'package:cala/widgets/configs/CalaColors.dart';
import 'package:flutter/material.dart';

class TableContents {
  static Row makeTableRow(
      bool isHeader, List<String> cellsText, MaterialColor color) {
    return Row(
      children: cellsText
          .map(
            (cellText) => Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isHeader ? color[600] : color[100],
                  border: Border.all(
                    color: color[700]!,
                    style: BorderStyle.solid,
                    width: 0.3,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Center(
                  child: Text(
                    cellText,
                    style: isHeader
                        ? TextStyle(
                            color: CalaColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )
                        : TextStyle(
                            color: CalaColors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
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
          child: Container(
            decoration: BoxDecoration(
              color: color[600],
              border: Border.all(
                color: color[700]!,
                style: BorderStyle.solid,
                width: 0.3,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            child: Center(
              child: Text(
                header,
                style: TextStyle(
                  color: CalaColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: color[100],
              border: Border.all(
                color: color[700]!,
                style: BorderStyle.solid,
                width: 0.3,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            child: Center(
              child: Text(
                data.toStringAsFixed(2),
                style: TextStyle(
                  color: CalaColors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
