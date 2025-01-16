import 'package:flutter/material.dart';

class WeatherWidget extends StatefulWidget {
  final String? temperature; // Temperature value passed from the parent widget
  final String? weatherCondition; // Weather condition (e.g., 'Sunny', 'Rainy')
  final String? city; // City name where the weather is being displayed

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
        mainAxisSize: MainAxisSize.min, // Take only the minimum required space
        children: [
          // If temperature and weather condition are available, display them
          if (widget.temperature != null && widget.weatherCondition != null)
            Row(
              children: [
                // Display the city name
                Text(
                  '${widget.city}',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
                SizedBox(width: 15),
                // Display the temperature
                Text(
                  '${widget.temperature}°C',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                SizedBox(width: 15),
                // Display the weather condition (e.g., 'Sunny', 'Rainy')
                Text(
                  '${widget.weatherCondition}',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            )
          else
            // If weather data is not available, show a loading indicator
            CircularProgressIndicator(color: Colors.blue),
        ],
      ),
    );
  }
}
