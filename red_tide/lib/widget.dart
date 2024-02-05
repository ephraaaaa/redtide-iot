// ignore_for_file: prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget customContainer(double height, width, fontSize, String text) {
  return Container(
    height: height,
    width: width,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
      color: Colors.white,
    ),
    child: Center(
      child: Text(
        text,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(fontSize: fontSize),
            color: Colors.black,
            fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget customSizedBox(double height) {
  return SizedBox(
    height: height,
  );
}

Widget customOutputContainer(double turbidity, String parameterName) {
  return Container(
    height: 150,
    width: 200,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
      color: Colors.black,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          turbidity.toString(),
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          parameterName,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 25),
        )
      ],
    ),
  );
}

Widget customButton(
    double height, width, VoidCallback onPressed, String buttonText) {
  return SizedBox(
    height: height,
    width: width,
    child: Builder(builder: (BuildContext context) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.black),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              side: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }),
  );
}

Widget customGraph(double y, Color color, parameterName,
    List<Map<String, dynamic>> weekData, String value) {
  return Center(
    child: Container(
      height: 200,
      width: 1000,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 30,
          left: 20,
          right: 25,
        ),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (int i = 0; i < weekData.length; i++)
                    FlSpot(i.toDouble(), (weekData[i][value] ?? 0).toDouble()),
                ],
                dotData: FlDotData(show: true),
                color: color,
                barWidth: 1,
              ),
            ],
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toString(),
                      style: TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    String text = '';
                    switch (value.toInt()) {
                      case 0:
                        text = "Sunday";
                      case 1:
                        text = "Monday";
                      case 2:
                        text = "Tuesday";
                      case 3:
                        text = "Wednesday";
                      case 4:
                        text = "Thursday";
                      case 5:
                        text = "Friday";
                      case 6:
                        text = "Saturday";
                    }
                    return Text(
                      text,
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget customText(String text, double fontSize, Color color) {
  return Text(
    text,
    style: GoogleFonts.poppins(
        color: color, fontWeight: FontWeight.normal, fontSize: fontSize),
  );
}

Widget navListTiles(
    IconData iconData, textString, VoidCallback onTap, bool selected) {
  return ListTile(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(left: 50)),
        Center(
          child: Icon(
            iconData,
            color: Colors.white,
            size: 35,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Center(
          child: Text(
            textString,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ],
    ),
    onTap: onTap,
    selected: selected,
  );
}

Widget customFormField(IconData iconData, Color color,
    TextEditingController controller, bool obscureText, String hintText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        iconData,
        color: color,
      ),
      SizedBox(
        width: 20,
      ),
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        height: 35,
        width: 300,
        child: TextFormField(
          obscureText: obscureText,
          controller: controller,
          maxLines: 1,
          autofocus: true,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsetsDirectional.only(start: 10.0, bottom: 10),
              hintText: hintText,
              border: InputBorder.none),
        ),
      ),
      SizedBox(
        width: 40,
      )
    ],
  );
}
