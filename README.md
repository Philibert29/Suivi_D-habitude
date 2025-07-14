# 📊 Suivi d'Habitudes

Une application de bureau développée en **Flutter Desktop** permettant de suivre ses habitudes au quotidien, avec une interface claire, des statistiques hebdomadaires, et des rappels programmables.

## 👤 Auteur
- **Nom :** Bastien Philibert
- **Éditeur :** Bastien Philibert

---

## 🚀 Fonctionnalités

- ✅ Ajout et suppression d’habitudes
- 📆 Sélection du jour d’apparition pour chaque habitude
- ✔️ Checklist quotidienne
- 📈 Statistiques hebdomadaires (taux de complétion)
- 🔔 Rappel quotidien avec notification (Android/Linux uniquement)
- 💾 Sauvegarde et authentification via Supabase
- 🖥️ Application packagée pour Windows (.exe)

---

## 📦 Installation

### ✅ Version installable (Windows)

> Téléchargez le fichier `habit_tracker.exe` depuis le dossier `/release` ou via le lien fourni (à adapter).

**⚠️ Note importante :**
- Les notifications ne sont **pas supportées sous Windows**.
- L’application reste 100 % fonctionnelle sans cette fonctionnalité.

---

## 🔧 Lancer depuis le code source

### Prérequis

- Flutter SDK (version stable)
- Un compte Supabase (configuré dans `main.dart`)
- Packages installés :
  ```bash
  flutter pub get

## Exécution

flutter run -d windows

## Structure du Projet

lib/
├── features/
│   ├── auth/              # Authentification Supabase
│   ├── habits/            # HomePage, services et modèles
│   └── stats/             # Statistiques hebdomadaires
├── core/
│   └── services/          # Notification et stockage local
main.dart                  # Point d’entrée de l’application

## Technologies

- Flutter Desktop
- Supabase
- Inno Setup (création de l’installateur Windows)
- Dart

## Notes

- Les notifications locales sont fonctionnelles uniquement sur Linux et Android.
- Testé et fonctionnel sur Windows 10+ (sans notifications).
- Projet réalisé dans le cadre du module Développement Desktop (Ynov B3).