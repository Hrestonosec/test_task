import 'package:flutter/material.dart';

class WeatherWidget extends StatefulWidget {
  final String? temperature;
  final String? weatherCondition;
  final String? city;

  const WeatherWidget(
      {super.key, this.temperature, this.weatherCondition, this.city});

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.temperature != null && widget.weatherCondition != null)
            Row(
              children: [
                Text(
                  '${widget.city}',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
                SizedBox(width: 15),
                Text(
                  '${widget.temperature}°C',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                SizedBox(width: 15),
                Text(
                  '${widget.weatherCondition}',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            )
          else
            CircularProgressIndicator(color: Colors.blue),
        ],
      ),
    );
  }
}
