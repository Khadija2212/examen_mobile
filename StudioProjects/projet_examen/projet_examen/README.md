## Projet examen – Application Flutter Météo

Application Flutter qui récupère des données météo en temps réel pour plusieurs villes,
affiche une jauge de progression animée et permet de consulter les résultats sur une
carte Google Maps.

### Membres du groupe

- Nom Complet 1 – Matricule
- Nom Complet 2 – Matricule
- Nom Complet 3 – Matricule

Remplacez les lignes ci‑dessus par les vrais noms des membres du groupe.

### Fonctionnalités principales

- Écran d’accueil avec message d’intro et bouton « Lancer l’expérience ».
- Écran principal avec :
  - Jauge circulaire animée qui se remplit automatiquement.
  - Appels API météo périodiques pour 5 villes (Paris, London, New York, Tokyo, Dakar).
  - Messages d’attente dynamiques qui tournent en boucle.
  - Gestion d’erreur avec possibilité de retenter.
  - Quand la jauge est pleine : affichage d’un tableau interactif + bouton « Recommencer ».
- Tableau des résultats (DataTable) : clic sur une ville → écran de détails.
- Écran de détails : informations complètes + localisation précise sur Google Maps.
- Support complet du mode clair et du mode sombre (ThemeData + darkTheme).

### API Météo (OpenWeather)

Le service d’API se trouve dans `lib/services/weather_service.dart`.

- Remplacez la valeur `VOTRE_CLE_OPENWEATHER_ICI` par votre vraie clé OpenWeather :
  - Créez un compte sur `https://openweathermap.org/`
  - Récupérez votre API key
  - Mettez‑la dans le constructeur de `WeatherService` dans `LoadingScreen`.

### Google Maps

L’écran `CityDetailScreen` utilise le plugin `google_maps_flutter`.

- Ajoutez une clé API Google Maps pour Android / iOS et suivez la doc officielle :
  - `https://pub.dev/packages/google_maps_flutter`
- Configurez les fichiers natifs (`AndroidManifest.xml`, `AppDelegate`, etc.) selon la doc.

### Lancement du projet

```bash
flutter pub get
flutter run
```

