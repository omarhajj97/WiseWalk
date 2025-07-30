import 'package:flutter/material.dart';
import 'package:wise_walk/dataclasses/forecast.dart';
import 'package:wise_walk/dataclasses/hourly_forecast.dart';
import 'package:wise_walk/formatters/time_formatter.dart';
import 'package:wise_walk/widgets/format_weather_detail.dart';

class WeatherDetailsDialog extends StatefulWidget {
  final Forecast currentForecast;
  final List<HourlyForecast> hourlyForecast;

  const WeatherDetailsDialog({
    super.key,
    required this.currentForecast,
    required this.hourlyForecast,
  });

  @override
  State<WeatherDetailsDialog> createState() => _WeatherDetailsDialogState();
}

class _WeatherDetailsDialogState extends State<WeatherDetailsDialog> {
  bool _showHourlyForecast = false;
  @override
  Widget build(BuildContext context) {
    final visibleForecasts = _showHourlyForecast
        ? widget.hourlyForecast
        : widget.hourlyForecast.take(6).toList();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(children: [Icon(Icons.cloud),SizedBox(width: 8,), const Text('Weather Details'),]),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            formatWeatherDetail(
              context,
              'assets/icons/atmospheric-conditions.png',
              'Condition',
              widget.currentForecast.weather,
            ),
            formatWeatherDetail(
              context,
              'assets/icons/thermometer.png',
              'Temperature',
              '${widget.currentForecast.temperature.round()}°C',
            ),
            if (widget.currentForecast.windSpeed != null)
              formatWeatherDetail(
                context,
                'assets/icons/wind.png',
                'Wind',
                '${widget.currentForecast.windSpeed} m/s',
              ),
            if (widget.currentForecast.humidity != null)
              formatWeatherDetail(
                context,
                'assets/icons/humidity.png',
                'Humidity',
                '${widget.currentForecast.humidity}%',
              ),
            if (widget.currentForecast.visibility != null)
              formatWeatherDetail(
                context,
                'assets/icons/visibility.png',
                'Visibility',
                '${(widget.currentForecast.visibility! / 1000).toStringAsFixed(1)} km',
              ),
            if (widget.currentForecast.uvIndex != null &&
                widget.currentForecast.uvLevel != null)
              formatWeatherDetail(
                context,
                'assets/icons/uv-index (1).png',
                'UV Index',
                '${widget.currentForecast.uvIndex!.toStringAsFixed(1)} (${widget.currentForecast.uvLevel})',
              ),
            if (widget.currentForecast.rain != null &&
                widget.currentForecast.rain! > 0)
              formatWeatherDetail(
                context,
                'assets/icons/rain.png',
                'Rainfall',
                '${widget.currentForecast.rain!.toStringAsFixed(1)} mm',
              ),
            const SizedBox(height: 12),
            if (widget.hourlyForecast.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [Icon(Icons.more_time_rounded,size:20),SizedBox(width: 6,), Text(
                    'Hourly Forecast:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ]  ),
                TextButton.icon(
                    icon: Icon(
                      _showHourlyForecast
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                    label: Text(_showHourlyForecast ? 'Hide' : 'Show'),
                    onPressed: () {
                      setState(
                        () => _showHourlyForecast = !_showHourlyForecast,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_showHourlyForecast)
                ...visibleForecasts.map((forecast) {
                  final formattedTime = TimeFormatter.formatTime(
                    forecast.timeOfForecast,
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 50, child: Text(formattedTime)),
                            Image.network(
                              forecast.weatherIconPath,
                              height: 24,
                              width: 24,
                            ),
                            SizedBox(
                              width: 60,
                              child: Text('${forecast.temperature.round()}°C'),
                            ),
                            Expanded(
                              child: Text(
                                '${forecast.rainProbability}% chance of rain',
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 6),
                      ],
                    ),
                  );
                }),
            ] else
              const Text("No hourly forecast available."),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
