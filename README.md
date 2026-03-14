# ApkNotif — Test de Notifications Flutter

Application Flutter de démonstration pour tester les notifications **locales** (via `flutter_local_notifications`) et les notifications **push** déclenchées depuis une API **FastAPI**.

---

## Fonctionnalités

- Notification locale déclenchée manuellement depuis l'interface
- Polling automatique (toutes les 3 secondes) vers une API FastAPI
- Notification locale déclenchée automatiquement à chaque nouveau cours détecté
- Gestion des permissions de notification (Android & iOS)
- Compatible Android et iOS

---

## Architecture

```
apknotif/
├── lib/
│   ├── main.dart                  # Point d'entrée, initialisation
│   ├── pages/
│   │   ├── home_page.dart         # Page avec bouton de notification manuelle
│   │   └── api_page.dart          # Page avec polling FastAPI + notification auto
│   └── services/
│       └── controller_page.dart   # Service de gestion des notifications locales
└── android/
    └── app/src/main/
        └── AndroidManifest.xml    # Permissions Android
```

---

## Prérequis

- Flutter SDK `^3.10.4`
- Dart SDK `^3.10.4`
- Android SDK (API 21+) ou Xcode (iOS 12+)
- Python 3.10+ avec FastAPI (pour le backend)

---

## Installation

### 1. Cloner le projet

```bash
git clone <url-du-repo>
cd apknotif
```

### 2. Installer les dépendances Flutter

```bash
flutter pub get
```

### 3. Lancer l'application

```bash
flutter run
```

---

## Backend FastAPI

L'app consomme un endpoint REST qui retourne une liste de cours.

### Exemple de structure attendue

```json
[
  {
    "id": 1,
    "title": "Introduction à Flutter",
    "description": "Premiers pas avec Flutter et Dart."
  }
]
```

### Endpoint utilisé

```
GET http://<votre-ip-locale>/courses/
```

> Modifiez l'IP dans `lib/pages/api_page.dart` pour correspondre à votre machine.

### Exemple minimal FastAPI

```python
from fastapi import FastAPI

app = FastAPI()

courses = [
    {"id": 1, "title": "Intro Flutter", "description": "Premiers pas avec Flutter."}
]

@app.get("/courses/")
def get_courses():
    return courses
```

```bash
uvicorn main:app --host 0.0.0.0 --port 80
```

---

## Dépendances principales

| Package | Usage |
|---|---|
| `flutter_local_notifications` | Affichage des notifications locales |
| `permission_handler` | Gestion des permissions runtime |
| `http` | Requêtes HTTP vers l'API FastAPI |

---

## Permissions Android

Déclarées dans `AndroidManifest.xml` :

```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
```

La permission `POST_NOTIFICATIONS` (Android 13+) est demandée dynamiquement au runtime via `permission_handler`.

---

## Fonctionnement du polling

`ApiPage` lance un `Timer.periodic` toutes les **3 secondes** qui appelle `GET /courses/`. Si le dernier cours retourné a un `id` différent du précédent, une notification locale est déclenchée automatiquement.

```dart
_timer = Timer.periodic(const Duration(seconds: 3), (timer) {
  fetchLessons();
});
```

---

## Notes

- Firebase est prévu pour les notifications push distantes (FCM). L'intégration est à compléter selon vos besoins.
- L'IP du serveur FastAPI est codée en dur dans `api_page.dart`, pensez à la rendre configurable pour un usage en production.
