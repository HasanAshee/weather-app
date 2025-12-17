import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'weather_model.dart';

class WeatherService {
  static const String apiKey = 'ab9aca49e5204d6a9ef9422dea2c426f';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> getWeather() async {
    Position position = await _getCurrentLocation();

    final response = await http.get(Uri.parse(
        '$baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar datos del clima');
    }
  }

  Future<Position> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        print("Permisos denegados. Usando ubicación por defecto.");
        throw Exception('Permisos faltantes');
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low, 
      );

    } catch (e) {
      print("Error obteniendo GPS: $e. Usando coordenadas por defecto (Tucumán).");
      return Position(
        latitude: -26.8241, 
        longitude: -65.2226, 
        timestamp: DateTime.now(), 
        accuracy: 0, 
        altitude: 0, 
        heading: 0, 
        speed: 0, 
        speedAccuracy: 0, 
        altitudeAccuracy: 0, 
        headingAccuracy: 0
      );
    }
  }
}