// // ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';
import 'package:weather_desktop/data/providers/weather/weather_notifier.dart';
import 'package:weather_desktop/infrastructure/weather/model/weather_model.dart';
import 'package:weather_desktop/presentation/screens/home/model/city_model.dart';
import 'package:weather_desktop/presentation/utilities/utils.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<City> _filteredCities = [];
  final List<City> _favoriteCities = [];
  final Map<City, WeatherModel?> _favoriteWeatherData = {};

  @override
  void initState() {
    super.initState();
    _filteredCities = cityList;
    // Initialize with some default favorites
    _favoriteCities.addAll([
      cityList[0], // Lagos
      cityList[2], // London
    ]);
    // Load initial weather data for favorites
    _loadFavoriteWeather();
  }

  Future<void> _loadFavoriteWeather() async {
    for (final city in _favoriteCities) {
      await _fetchWeatherForCity(city);
    }
  }

  Future<void> _fetchWeatherForCity(City city) async {
    try {
      // Get the notifier first
      final notifier = ref.read(weatherNotifierProvider.notifier);
      
      // Fetch the weather (this updates the state through Riverpod)
      await notifier.fetchCurrentWeather(
        latitude: city.latitude,
        longitude: city.longitude,
      );
      
      // Get the updated weather data from the provider
      final weatherState = ref.read(weatherNotifierProvider);
      
      if (weatherState.data != null) {
        setState(() {
          _favoriteWeatherData[city] = weatherState.data!;
        });
      }
    } catch (e) {
      // Handle error
      Utils.logger.d('Error fetching weather for ${city.name}: $e');
    }
  }

  void _filterCities(String query) {
    setState(() {
      _filteredCities = cityList
          .where((city) => city.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleFavorite(City city) async {
    setState(() {
      if (_favoriteCities.contains(city)) {
        _favoriteCities.remove(city);
        _favoriteWeatherData.remove(city);
      } else {
        _favoriteCities.add(city);
        _fetchWeatherForCity(city); // Fetch weather when adding new favorite
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(color: AppColors.backgroundDark)),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              backgroundBlendMode: BlendMode.overlay,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Favorite Cities',
                    style: AppFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightBlueGrey,
                    ),
                  ),
                  const Gap(40),

                  // Search and Add City
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: AppFonts.poppins(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            hintText: 'Search cities...',
                            hintStyle: AppFonts.poppins(color: Colors.white54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.search, color: Colors.white70),
                          ),
                          onChanged: _filterCities,
                        ),
                      ),
                      const Gap(12),
                      ElevatedButton(
                        onPressed: () {
                          if (_searchController.text.isNotEmpty && _filteredCities.isNotEmpty) {
                            _toggleFavorite(_filteredCities.first);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          'Add',
                          style: AppFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),

                  // Favorites List
                  Expanded(
                    child: _favoriteCities.isEmpty
                        ? Center(
                            child: Text(
                              'No favorite cities yet',
                              style: AppFonts.poppins(color: Colors.white54),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _favoriteCities.length,
                            itemBuilder: (context, index) {
                              final city = _favoriteCities[index];
                              final weather = _favoriteWeatherData[city];
                              return _WeatherCityCard(
                                city: city,
                                weather: weather,
                                onRemove: () => _toggleFavorite(city),
                                onRefresh: () => _fetchWeatherForCity(city),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherCityCard extends StatelessWidget {
  final City city;
  final WeatherModel? weather;
  final VoidCallback onRemove;
  final VoidCallback onRefresh;

  const _WeatherCityCard({
    required this.city,
    this.weather,
    required this.onRemove,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.location_city, color: Colors.lightBlueAccent),
                const Gap(16),
                Expanded(
                  child: Text(
                    city.name,
                    style: AppFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: onRemove,
                ),
              ],
            ),
            const Gap(8),
            if (weather != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _WeatherInfoItem(
                    icon: Icons.thermostat,
                    value: '${weather!.temperature}°C',
                    label: 'Temperature',
                  ),
                  _WeatherInfoItem(
                    icon: Icons.air,
                    value: '${weather!.windSpeed} km/h',
                    label: 'Wind',
                  ),
                  _WeatherInfoItem(
                    icon: Icons.water_drop,
                    value: '${weather!.humidity}%',
                    label: 'Humidity',
                  ),
                ],
              )
            else
              Text(
                'Loading weather...',
                style: AppFonts.poppins(color: Colors.white54),
              ),
            const Gap(8),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white70),
                onPressed: onRefresh,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherInfoItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _WeatherInfoItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const Gap(4),
        Text(
          value,
          style: AppFonts.poppins(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          label,
          style: AppFonts.poppins(
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}