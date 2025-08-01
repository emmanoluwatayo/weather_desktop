class City {
  final String name;
  final double latitude;
  final double longitude;

  City({required this.name, required this.latitude, required this.longitude});
}

final List<City> cityList = [
  // 🌍 Africa
  City(name: 'Lagos, Nigeria', latitude: 6.5244, longitude: 3.3792),
  City(name: 'Cairo, Egypt', latitude: 30.0444, longitude: 31.2357),
  City(name: 'Nairobi, Kenya', latitude: -1.2864, longitude: 36.8172),
  City(name: 'Johannesburg, South Africa', latitude: -26.2041, longitude: 28.0473),
  City(name: 'Casablanca, Morocco', latitude: 33.5731, longitude: -7.5898),

  // 🏯 Asia
  City(name: 'Tokyo, Japan', latitude: 35.6762, longitude: 139.6503),
  City(name: 'Mumbai, India', latitude: 19.0760, longitude: 72.8777),
  City(name: 'Dubai, UAE', latitude: 25.2048, longitude: 55.2708),
  City(name: 'Shanghai, China', latitude: 31.2304, longitude: 121.4737),
  City(name: 'Seoul, South Korea', latitude: 37.5665, longitude: 126.9780),

  // 🏰 Europe
  City(name: 'London, UK', latitude: 51.5074, longitude: -0.1278),
  City(name: 'Paris, France', latitude: 48.8566, longitude: 2.3522),
  City(name: 'Berlin, Germany', latitude: 52.5200, longitude: 13.4050),
  City(name: 'Rome, Italy', latitude: 41.9028, longitude: 12.4964),
  City(name: 'Moscow, Russia', latitude: 55.7558, longitude: 37.6173),

  // 🗽 North America
  City(name: 'New York, USA', latitude: 40.7128, longitude: -74.0060),
  City(name: 'Los Angeles, USA', latitude: 34.0522, longitude: -118.2437),
  City(name: 'Mexico City, Mexico', latitude: 19.4326, longitude: -99.1332),
  City(name: 'Toronto, Canada', latitude: 43.6532, longitude: -79.3832),
  City(name: 'Chicago, USA', latitude: 41.8781, longitude: -87.6298),

  // 🌎 South America
  City(name: 'Rio de Janeiro, Brazil', latitude: -22.9068, longitude: -43.1729),
  City(name: 'Buenos Aires, Argentina', latitude: -34.6037, longitude: -58.3816),
  City(name: 'Lima, Peru', latitude: -12.0464, longitude: -77.0428),
  City(name: 'Bogotá, Colombia', latitude: 4.7110, longitude: -74.0721),
  City(name: 'Santiago, Chile', latitude: -33.4489, longitude: -70.6693),

  // 🦘 Oceania
  City(name: 'Sydney, Australia', latitude: -33.8688, longitude: 151.2093),
  City(name: 'Melbourne, Australia', latitude: -37.8136, longitude: 144.9631),
  City(name: 'Auckland, New Zealand', latitude: -36.8485, longitude: 174.7633),
  City(name: 'Brisbane, Australia', latitude: -27.4698, longitude: 153.0251),
  City(name: 'Perth, Australia', latitude: -31.9505, longitude: 115.8605),
];