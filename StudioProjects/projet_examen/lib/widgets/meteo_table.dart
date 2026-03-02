import 'package:flutter/material.dart';
import 'package:projet_examen/models/config.dart';
import 'package:projet_examen/models/ville.dart';
import 'package:projet_examen/screens/ville_details_screen.dart';

class MeteoTable extends StatelessWidget {
  final List<Ville> villes;
  final List<Map<String, dynamic>> meteoDataList;

  const MeteoTable({
    super.key,
    required this.villes,
    required this.meteoDataList,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Couleurs adaptées selon le thème
    final cardBg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final headerBg = const Color(backScafoldColor);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDark ? Colors.white70 : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : Colors.grey.withValues(alpha: 0.3);
    final shadowColor = isDark ? Colors.black54 : Colors.black12;

    return Container(
      height: 350,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // En-tête du tableau
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            width: double.infinity,
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Text(
              'Météo des villes',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: family,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Liste des villes
          Expanded(
            child: ListView.builder(
              itemCount: villes.length,
              itemBuilder: (context, index) {
                final ville = villes[index];
                final meteoData =
                    index < meteoDataList.length ? meteoDataList[index] : null;

                return InkWell(
                  onTap: () {
                    if (meteoData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VilleDetailsScreen(
                            ville: ville,
                            meteoData: meteoData,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            ville.nom,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: family,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${ville.temperature}°C',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: family,
                              color: subTextColor,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ville.couverture,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: family,
                              color: subTextColor,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: isDark ? Colors.white38 : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}