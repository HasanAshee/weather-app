import 'package:flutter/material.dart';
import 'weather_model.dart';
import 'weather_service.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    try {
      final weather = await _weatherService.getWeather();
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }
  String getMensajeHonesto(double temp) {
    if (temp > 40) return "AAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    if (temp > 35) return "Que dia de mierda, apaguen el sol";
    if (temp > 30) return "El culo todo sudado tengo";
    if (temp > 25) return "Hace calor lpm";
    if (temp > 18) return "Ta lindo";
    if (temp > 10) return "Fresquito pa' cucharear";
    if (temp > 0) return "Se me freezan las bolas puñeta";
    return "mis bolas estan como girnaldas de navidad";
  }

  IconData getIcono(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'clouds': return Icons.cloud;
      case 'mist': 
      case 'smoke': 
      case 'haze': 
      case 'dust': 
      case 'fog': return Icons.cloud_queue;
      case 'rain': 
      case 'drizzle': 
      case 'shower rain': return Icons.umbrella;
      case 'thunderstorm': return Icons.flash_on;
      case 'clear': return Icons.wb_sunny;
      default: return Icons.wb_sunny;
    }
  }

 Widget getClimaIcono(String? mainCondition) {
    if (mainCondition == null) return const Icon(Icons.error, size: 100, color: Colors.red);

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return const Icon(Icons.cloud, size: 150, color: Colors.grey);
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return const Icon(Icons.umbrella, size: 150, color: Colors.blueAccent);
      case 'thunderstorm':
        return const Icon(Icons.flash_on, size: 150, color: Colors.yellowAccent);
      case 'clear':
        return const Icon(Icons.wb_sunny, size: 150, color: Colors.orangeAccent);
      default:
        return const Icon(Icons.wb_sunny, size: 150, color: Colors.orangeAccent);
    }
  }
  List<Color> getBackgroundColors(double? temp) {
    if (temp == null) return [Colors.grey[900]!, Colors.grey[800]!];

    if (temp > 30) {
      return [Colors.orange[900]!, Colors.red[700]!];
    } else if (temp > 18) {
      return [Colors.green[800]!, Colors.teal[900]!];
    } else {
      return [Colors.blue[900]!, Colors.indigo[900]!];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> bgColors = getBackgroundColors(_weather?.temperature);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: bgColors,
          ),
        ),
        child: Center(
          child: _isLoading 
            ? const CircularProgressIndicator(color: Colors.white)
            : _weather == null 
              ? const Text("No se pudo cargar el clima de mierda", style: TextStyle(color: Colors.white))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, color: Colors.white70),
                        const SizedBox(width: 5),
                        Text(
                          _weather!.cityName.toUpperCase(),
                          style: const TextStyle(color: Colors.white70, fontSize: 20, letterSpacing: 2),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    getClimaIcono(_weather?.mainCondition),

                    const SizedBox(height: 20),

                    Text(
                      '${_weather!.temperature.round()}°',
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 90, 
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 10, color: Colors.black45, offset: Offset(2, 2))]
                      ),
                    ),

                    Text(
                      _weather!.mainCondition,
                      style: const TextStyle(color: Colors.white70, fontSize: 24),
                    ),

                    const SizedBox(height: 50),

                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.black26, 
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getMensajeHonesto(_weather!.temperature),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 22, 
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}