// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:weather_desktop/core/constants/app_colors.dart';
import 'package:weather_desktop/core/constants/app_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background animation hook
          Container(decoration: BoxDecoration(color: AppColors.backgroundDark)),
          // Frosted Glass Background
          Container(
            decoration: BoxDecoration(
              // ignore: deprecated member use
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
                      // 🔹 Current Weather Summary
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "New York, USA",
                                style: AppFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "12:34 PM - Sunny",
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
                                "29°C",
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
                      SizedBox(
                        height: 120,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 100,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.white24, Colors.white10],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Mon",
                                    style: AppFonts.poppins(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  const Icon(
                                    Icons.wb_cloudy,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "26°C",
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
                      ),

                      const Gap(24),
                      // 🔸 AQI + Sunrise/Sunset + Details
                      Row(
                        children: [
                          _infoCard("AQI", "42", Icons.air, Colors.greenAccent),
                          _infoCard(
                            "Sunrise",
                            "6:20 AM",
                            Icons.wb_twilight,
                            Colors.orangeAccent,
                          ),
                          _infoCard(
                            "Sunset",
                            "6:45 PM",
                            Icons.nightlight_round,
                            Colors.purpleAccent,
                          ),
                        ],
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          _infoCard(
                            "Humidity",
                            "74%",
                            Icons.water_drop,
                            Colors.lightBlue,
                          ),
                          _infoCard(
                            "Wind",
                            "18 km/h",
                            Icons.air_rounded,
                            Colors.cyan,
                          ),
                          _infoCard(
                            "Pressure",
                            "1012 hPa",
                            Icons.speed,
                            Colors.tealAccent,
                          ),
                        ],
                      ),
                      const Gap(24),
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
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, _) {
                                    final days = [
                                      'Mon',
                                      'Tue',
                                      'Wed',
                                      'Thu',
                                      'Fri',
                                      'Sat',
                                      'Sun',
                                    ];
                                    return Text(
                                      days[value.toInt()],
                                      style: AppFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                                  interval: 1,
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
                                spots: [
                                  FlSpot(0, 24),
                                  FlSpot(1, 26),
                                  FlSpot(2, 22),
                                  FlSpot(3, 25),
                                  FlSpot(4, 28),
                                  FlSpot(5, 27),
                                  FlSpot(6, 26),
                                ],
                                isCurved: true,
                                barWidth: 4,
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.withOpacity(0.4),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                color: Colors.lightBlueAccent,
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Center(
      //   child: Text(
      //     'Home',
      //     style: AppFonts.poppins(
      //       fontSize: 15,
      //       fontWeight: FontWeight.w500,
      //       color: AppColors.lightBlueGrey,
      //     ),
      //   ),
      // ),
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
