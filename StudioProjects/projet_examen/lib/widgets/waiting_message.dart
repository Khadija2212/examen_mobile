import 'dart:async';
import 'package:projet_examen/models/config.dart';
import 'package:projet_examen/models/ville.dart';
import 'package:projet_examen/screens/second_screen.dart';
import 'package:projet_examen/widgets/meteo_table.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/weather_service.dart';

class WaitingMessage extends StatefulWidget {
  const WaitingMessage({super.key});

  @override
  State<WaitingMessage> createState() => _WaitingMessageState();
}

class _WaitingMessageState extends State<WaitingMessage> {
  bool isFinish = false;
  List<String> villesNames = ['Dakar', 'Paris', 'Tokyo', 'New York', 'London'];
  List<Ville> villes = [];
  List<Map<String, dynamic>> meteoDataList = [];

  int compteur = 0;
  int index = 0;
  String message = 'Démarrage';

  late Timer _timer;
  late Timer _timerProgress;

  double counterProgress = 0;
  double progressBar = 0;
  double widthProgress = 0;

  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
    _startTimerProgress();
  }

  @override
  void dispose() {
    _timer.cancel();
    _timerProgress.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      setState(() {
        compteur += 6;
        index = index > 2 ? 0 : index;
        message = [
          'Nous téléchargeons les données...',
          'C\'est presque fini...',
          'Plus que quelques secondes avant d\'avoir le résultat...'
        ][index];
        index++;
        if (compteur >= 60) {
          timer.cancel();
        }
      });
    });
  }

  void _startTimerProgress() {
    _fetchWeatherData(0);

    _timerProgress = Timer.periodic(const Duration(seconds: 12), (timer) {
      int currentCityIndex = (counterProgress ~/ 12) + 1;

      if (currentCityIndex < villesNames.length) {
        _fetchWeatherData(currentCityIndex);
      }

      setState(() {
        counterProgress += 12;
        progressBar = (counterProgress / 60) * 100;
        if (progressBar > 100) progressBar = 100;
        widthProgress = (progressBar / 100) * progressbarwidht;

        if (counterProgress >= 60) {
          isFinish = true;
          timer.cancel();
        }
      });
    });
  }

  void _fetchWeatherData(int index) {
    if (index < villesNames.length) {
      setState(() {
        isLoading = true;
      });

      final meteo = Meteo();
      meteo.fetchWeatherData(villesNames[index]).then((data) {
        setState(() {
          meteoDataList.add(data);
          villes.add(Ville(
            nom: data['name'],
            couverture: data['weather'][0]['description'],
            temperature: data['main']['temp'],
            humidite: data['main']['humidity'].toString(),
          ));
          isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          hasError = true;
          errorMessage = 'Erreur lors du chargement des données: $error';
          isLoading = false;
        });
      });
    }
  }

  void _restart() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SecondScreen(),
      ),
    );
  }

  Widget _getWeatherIcon(String condition) {
    if (condition.toLowerCase().contains('rain') ||
        condition.toLowerCase().contains('pluie')) {
      return Lottie.asset("assets/lotties/nuage.json");
    } else if (condition.toLowerCase().contains('cloud') ||
        condition.toLowerCase().contains('nuage')) {
      return Lottie.asset("assets/lotties/nuage.json");
    } else if (condition.toLowerCase().contains('snow') ||
        condition.toLowerCase().contains('neige')) {
      return Lottie.asset("assets/lotties/nuageux.json");
    } else {
      return Lottie.asset("assets/lotties/ensoleille.json");
    }
  }

  @override
  Widget build(BuildContext context) {
    return hasError
        ? _buildErrorWidget()
        : isFinish
            ? _buildResultWidget()
            : _buildLoadingWidget();
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 20),
          Text(
            errorMessage,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(backScafoldColor),
              foregroundColor: Colors.white,
            ),
            onPressed: _restart,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MeteoTable(villes: villes, meteoDataList: meteoDataList),
        const SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(backScafoldColor),
            foregroundColor: Colors.white,
            minimumSize: const Size(250, 50),
          ),
          onPressed: _restart,
          child: const Text(
            'Recommencer',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: buttonFontSize,
              fontFamily: family,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentVille = villes.isNotEmpty ? villes.last : null;
    final textColor = isDark ? Colors.white70 : const Color(0xFF333A73);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Carte de chargement
          Container(
            height: 350,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(backScafoldColor),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black54
                      : Colors.black.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  currentVille?.nom ?? 'Chargement...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: family,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: currentVille != null
                      ? _getWeatherIcon(currentVille.couverture)
                      : Lottie.asset("assets/lotties/nuage.json"),
                ),
                const SizedBox(height: 30),
                Text(
                  currentVille != null
                      ? '${currentVille.temperature}°C'
                      : "Chargement...",
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: family,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  currentVille?.couverture ?? "...",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontFamily: family,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  currentVille != null
                      ? 'Humidité: ${currentVille.humidite}%'
                      : "...",
                  style: const TextStyle(
                    color: Colors.white60,
                    fontFamily: family,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Message d'attente
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontFamily: family,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),

          // Barre de progression adaptée
          Container(
            width: progressbarwidht,
            height: progressbarheight,
            decoration: BoxDecoration(
              color: isDark ? Colors.white12 : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  width: widthProgress,
                  height: progressbarheight,
                  decoration: BoxDecoration(
                    color: const Color(backColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Positioned(
                  right: 10,
                  child: Text(
                    '${progressBar.ceil()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}