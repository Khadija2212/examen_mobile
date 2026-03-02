import 'package:flutter/material.dart';
import 'package:projet_examen/models/config.dart';
import 'package:projet_examen/models/ville.dart';
import 'package:projet_examen/screens/ville_details_screen.dart';

class MeteoTable extends StatelessWidget {
  final List<Ville> villes;
  final List<Map<String, dynamic>> meteoDataList;

  const MeteoTable({
    Key? key,
    required this.villes,
    required this.meteoDataList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(backScafoldColor),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
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
          Expanded(
            child: ListView.builder(
              itemCount: villes.length,
              itemBuilder: (context, index) {
                final ville = villes[index];
                final meteoData = index < meteoDataList.length ? meteoDataList[index] : null;

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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: family,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${ville.temperature}°C',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: family,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ville.couverture,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: family,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
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