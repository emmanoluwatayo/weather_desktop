// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';
import 'package:weather_desktop/core/network/api_response.dart';
import 'package:weather_desktop/data/providers/weather/weather_notifier.dart';
import 'package:weather_desktop/presentation/screens/home/model/city_model.dart';
import 'package:weather_desktop/utilities/loading.dart';
import 'package:weather_desktop/utilities/toast_info.dart';



class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  City? _selectedCity;

  @override
  void initState() {
    super.initState();
    // Optionally load default city weather on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedCity == null && cityList.isNotEmpty) {
        _fetchWeatherForCity(cityList.first);
      }
    });
  }

  Future<void> _fetchWeatherForCity(City city) async {
    setState(() => _selectedCity = city);
    await ref
        .read(weatherNotifierProvider.notifier)
        .fetchCurrentWeather(
          latitude: city.latitude,
          longitude: city.longitude,
        );
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherNotifierProvider);

    // Handle loading and error states
    if (weatherState.processingStatus == ProcessingStatus.waiting) {
      context.showLoader();
    } else {
      context.hideLoader();
    }

    if (weatherState.processingStatus == ProcessingStatus.error) {
      toastInfo(
        msg: 'Oops! ${weatherState.error.errorMsg}',
        status: Status.error,
      );
    }

    List<FlSpot> dailySpots = [];
    List<String> dailyLabels = [];

    if (weatherState.data != null) {
      final weatherData = weatherState.data!;

      for (int i = 0; i < weatherData.dailyTime.length && i < 7; i++) {
        final dateStr = weatherData.dailyTime[i];
        final temp = weatherData.dailyTempMax[i];
        final date = DateTime.tryParse(dateStr);

        if (date != null) {
          dailySpots.add(FlSpot(i.toDouble(), temp));
          dailyLabels.add(DateFormat('E').format(date)); // 'Mon', 'Tue', etc.
        }
      }
    }

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
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔽 City Selection Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: DropdownButton<City>(
                          value: _selectedCity,
                          isExpanded: true,
                          underline: const SizedBox(),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          hint: Text(
                            'Select a city',
                            style: AppFonts.poppins(color: Colors.white70),
                          ),
                          dropdownColor: AppColors.backgroundDark,
                          items:
                              cityList.map((city) {
                                return DropdownMenuItem<City>(
                                  value: city,
                                  child: Text(
                                    city.name,
                                    style: AppFonts.poppins(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (city) {
                            if (city != null) {
                              _fetchWeatherForCity(city);
                            }
                          },
                        ),
                      ),
                      const Gap(20),

                      if (weatherState.data != null) ...[
                        // 🔹 Current Weather Summary
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${weatherState.data!.temperature}°C',
                                  style: AppFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${TimeOfDay.now().format(context)} - ${weatherState.data!.time}",
                                  style: AppFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.wb_sunny,
                                  size: 40,
                                  color: Colors.amberAccent,
                                ),
                                Text(
                                  "${weatherState.data!.tempMax}°C",
                                  style: AppFonts.poppins(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Gap(40),

                        // 🔸 Animated Weather Icon
                        Center(
                          child: Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.cloud,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Gap(40),

                        // 🔹 7-Day Forecast
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: Builder(
                              builder: (context) {
                                final now = DateTime.now();
                                final filteredTimes = <String>[];
                                final filteredTemps = <double>[];

                                for (
                                  int i = 0;
                                  i < weatherState.data!.hourlyTime.length;
                                  i++
                                ) {
                                  final timeStr =
                                      weatherState.data!.hourlyTime[i];
                                  final parsedTime = DateTime.tryParse(timeStr);
                                  if (parsedTime != null &&
                                      parsedTime.isAfter(now)) {
                                    filteredTimes.add(timeStr);
                                    filteredTemps.add(
                                      weatherState.data!.hourlyTemp[i],
                                    );
                                  }
                                  if (filteredTimes.length == 8) break;
                                }

                                return Center(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: filteredTemps.length,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final temp = filteredTemps[index];
                                      final timeStr = filteredTimes[index];

                                      final formattedTime =
                                          DateTime.tryParse(timeStr) != null
                                              ? TimeOfDay.fromDateTime(
                                                DateTime.parse(timeStr),
                                              ).format(context)
                                              : timeStr;

                                      return Container(
                                        width: 100,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Colors.white24,
                                              Colors.white10,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              formattedTime,
                                              style: AppFonts.poppins(
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 8),
                                            const Icon(
                                              Icons.wb_sunny,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "${temp.toStringAsFixed(0)}°C",
                                              style: AppFonts.poppins(
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const Gap(24),

                        // 🔸 Weather Info Cards
                        Row(
                          children: [
                            _infoCard(
                              "Humidity",
                              "${weatherState.data!.humidity}%",
                              Icons.water_drop,
                              Colors.lightBlue,
                            ),
                            _infoCard(
                              "Wind",
                              "${weatherState.data!.windSpeed} km/h",
                              Icons.air_rounded,
                              Colors.cyan,
                            ),
                            _infoCard(
                              "Sunrise",
                              weatherState.data!.sunrise,
                              Icons.wb_twilight,
                              Colors.orangeAccent,
                            ),
                          ],
                        ),
                        const Gap(16),
                        Row(
                          children: [
                            _infoCard(
                              "Sunset",
                              weatherState.data!.sunset,
                              Icons.nightlight_round,
                              Colors.purpleAccent,
                            ),
                            _infoCard(
                              "Min Temp",
                              "${weatherState.data!.tempMin}°C",
                              Icons.thermostat_auto,
                              Colors.blueAccent,
                            ),
                            _infoCard(
                              "Max Temp",
                              "${weatherState.data!.tempMax}°C",
                              Icons.thermostat,
                              Colors.redAccent,
                            ),
                          ],
                        ),

                        const Gap(24),
                        // 🔸 7-Day Temperature Trend
                        Text(
                          "7-Day Temperature Trend",
                          style: AppFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 32,
                                    getTitlesWidget:
                                        (value, _) => Text(
                                          "${value.toInt()}°",
                                          style: AppFonts.poppins(
                                            color: Colors.white60,
                                            fontSize: 10,
                                          ),
                                        ),
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, _) {
                                      final index = value.toInt();
                                      if (index >= 0 &&
                                          index < dailyLabels.length) {
                                        return Text(
                                          dailyLabels[index],
                                          style: AppFonts.poppins(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: dailySpots,
                                  isCurved: true,
                                  barWidth: 4,
                                  color: Colors.lightBlueAccent,
                                  dotData: FlDotData(show: true),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.lightBlueAccent.withOpacity(0.4),
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else if (_selectedCity == null) ...[
                        // Show placeholder when no city is selected
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 60,
                                color: Colors.white54,
                              ),
                              const Gap(20),
                              Text(
                                'Select a city to view weather',
                                style: AppFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppFonts.poppins(fontSize: 16, color: Colors.white),
            ),
            Text(
              title,
              style: AppFonts.poppins(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}


