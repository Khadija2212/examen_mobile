# MétéoVision 🌤️

> Application mobile Flutter de météo en temps réel — Projet de groupe

---

👥 Équipe de développement

 - Khadidiatou Diouf

 - Mouhammadou Makhtar Diop

 - Mamadou Mbaye
---

## 📱 Présentation

**MétéoVision** est une application mobile développée avec Flutter permettant d'afficher les conditions météorologiques en temps réel pour plusieurs grandes villes du monde.

L'application offre une interface moderne et intuitive, avec un design soigné et plusieurs fonctionnalités interactives comme une carte dynamique, un mode sombre / clair, et des animations fluides.

Elle utilise l’API OpenWeatherMap afin de récupérer les données météorologiques et les afficher de manière claire et structurée.

---

🚀 Fonctionnalités principales

✔️ Consultation de la météo en temps réel
✔️ Affichage des informations météo pour plusieurs villes
✔️ Carte interactive basée sur OpenStreetMap
✔️ Mode sombre / mode clair (Dark / Light Mode)
✔️ Interface moderne avec animations Lottie
✔️ Chargement progressif des données météo
✔️ Gestion des erreurs réseau


## �️ Technologies utilisées

- **Framework** : Flutter (Dart)
- **API** : [OpenWeatherMap](https://openweathermap.org/api)
- **Carte** : flutter_map + OpenStreetMap
- **Gestion d'état** : Provider
- **Animations** : Lottie 

---

## ⚙️ Installation et lancement

### Première fois (clone)

```bash
git clone https://github.com/Khadija2212/examen_mobile.git
cd examen_mobile/StudioProjects/projet_examen
flutter pub get
flutter run
```

### Mise à jour (projet déjà cloné)

```bash
git pull
flutter pub get
flutter run
```

> Si vous rencontrez des erreurs, essayez :
> ```bash
> flutter clean
> flutter pub get
> flutter run
> ```

---

## 📁 Structure du projet

```
lib/
├── main.dart
├── models/
│   ├── config.dart               # Constantes (couleurs, polices)
│   └── ville.dart                # Modèle Ville
├── services/
│   └── weather_service.dart      # Appels API OpenWeatherMap
├── theme/
│   └── theme_manager.dart        # Thème clair / sombre
├── screens/
│   ├── home_screen.dart          # Écran d'accueil
│   ├── second_screen.dart        # Écran principal
│   └── ville_details_screen.dart # Détails + Carte
└── widgets/
    ├── waiting_message.dart      # Chargement & résultats
    └── meteo_table.dart          # Liste des villes
```

---

## � Villes disponibles

🇸🇳 Dakar · 🇫🇷 Paris · 🇯🇵 Tokyo · 🇺🇸 New York · 🇬🇧 London

---

## ✨ Fonctionnalités

- Météo en temps réel via OpenWeatherMap
- Carte interactive centrée sur la ville sélectionnée
- Mode sombre / mode clair avec toggle
- Design premium (glassmorphism, dégradés, animations)
- Chargement optimisé avec progression ville par ville
- Gestion des erreurs réseau
