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

  // Temps pour le message
  late Timer _timer;

  // Timer pour la progression de la barre
  late Timer _timerProgress;

  // Compte les secondes passées
  double counterProgress = 0;

  // Pourcentage de la progression
  double progressBar = 0;

  // Largeur de la barre de progression
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

  // Timer pour la barre de progression et les appels API
  void _startTimerProgress() {
    // Premier appel API immédiat
    _fetchWeatherData(0);

    _timerProgress = Timer.periodic(const Duration(seconds: 12), (timer) {
      int currentCityIndex = (counterProgress ~/ 12) + 1;

      if (currentCityIndex < villesNames.length) {
        _fetchWeatherData(currentCityIndex);
      }

      setState(() {
        // Incrémentation du compteur (12 secondes)
        counterProgress += 12;

        // Mise à jour de la progression en pourcentage (100% divisé par 5 villes = 20% par ville)
        progressBar = (counterProgress / 60) * 100;
        if (progressBar > 100) progressBar = 100;

        // Mise à jour de la largeur de la barre de progression
        widthProgress = (progressBar / 100) * progressbarwidht;

        // Vérifier si la progression est terminée
        if (counterProgress >= 60) {
          isFinish = true;
          timer.cancel();
        }
      });
    });
  }

  // Méthode pour récupérer les données météo d'une ville
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
        print('Erreur lors du chargement de l\'API: $error');
      });
    }
  }

  // Méthode pour recommencer
  void _restart() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SecondScreen(),
      ),
    );
  }

  // Méthode pour afficher l'icône météo appropriée
  Widget _getWeatherIcon(String condition) {
    if (condition.toLowerCase().contains('rain') ||
        condition.toLowerCase().contains('pluie')) {
      return Lottie.asset("assets/lotties/rain.json");
    } else if (condition.toLowerCase().contains('cloud') ||
        condition.toLowerCase().contains('nuage')) {
      return Lottie.asset("assets/lotties/nuage.json");
    } else if (condition.toLowerCase().contains('snow') ||
        condition.toLowerCase().contains('neige')) {
      return Lottie.asset("assets/lotties/snow.json");
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

  // Widget pour afficher l'erreur
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 20),
          Text(
            errorMessage,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(backScafoldColor)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: _restart,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  // Widget pour afficher le résultat (tableau des villes)
  Widget _buildResultWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MeteoTable(
          villes: villes,
          meteoDataList: meteoDataList,
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(const Color(backScafoldColor)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            minimumSize: MaterialStateProperty.all<Size>(const Size(250, 50)),
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

  // Widget pour afficher le chargement
  Widget _buildLoadingWidget() {
    // Récupérer la dernière ville chargée pour l'afficher
    final currentVille = villes.isNotEmpty ? villes.last : null;
    final currentData = meteoDataList.isNotEmpty ? meteoDataList.last : null;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Box pour afficher le temps de la ville en cours de chargement
          Container(
            height: 350,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(backScafoldColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Nom de la ville
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
                // Animation météo
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: currentVille != null
                      ? _getWeatherIcon(currentVille.couverture)
                      : Lottie.asset("assets/lotties/loading.json"),
                ),
                const SizedBox(height: 30),
                // Température
                Text(
                  currentVille != null ? '${currentVille.temperature}°C' : "Chargement...",
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: family,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 15),
                // Condition météo
                Text(
                  currentVille?.couverture ?? "...",
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: family,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15),
                // Humidité
                Text(
                  currentVille != null ? 'Humidité: ${currentVille.humidite}%' : "...",
                  style: const TextStyle(
                    color: Colors.white,
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
            style: const TextStyle(
              fontSize: 16,
              fontFamily: family,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),

          // Barre de progression
          Container(
            width: progressbarwidht,
            height: progressbarheight,
            decoration: BoxDecoration(
              color: Colors.grey[300],
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