# 🏎️ GridPulse

> F1 Tracker iOS — Écuries, Grands Prix, Classements

App iOS pour suivre la Formule 1, inspirée de **Box Box**, avec un design orienté bagnoles — minimalisme mais couleur.

## ✨ Features

- 🏠 **Home** — Countdown prochain GP, résultats récents, classements
- 🏁 **Schedule** — Calendrier complet des Grands Prix, détails circuit
- 📊 **Standings** — Classements pilotes & constructeurs
- 🏎️ **Race Weekend** — Résultats FP, qualif, sprint, course
- 🔴 **Live Activity** — Suivi en temps réel sur l'écran de verrouillage
- 📱 **Widgets** — Countdown, standings, résultats
- 🎨 **Liquid Glass** — Design iOS 26+ avec couleurs d'écurie

## 🛠 Stack

| Layer | Choix |
|-------|-------|
| Language | Swift 6 |
| UI | SwiftUI, iOS 26+ (Liquid Glass) |
| Min target | iOS 26.0 |
| Architecture | MVVM + Repository |
| Network | URLSession + async/await |
| Cache | SwiftData |
| APIs | Jolpica F1 (historique) + OpenF1 (live) |
| CI/CD | Xcode Cloud |
| Widgets | WidgetKit + Live Activity |
| i18n | Localizable.xcstrings (EN + FR) |

## 📁 Structure

```
GridPulse/
├── GridPulse-iOS/          # App principale
├── GridPulse-Shared/       # Modèles & services partagés
├── GridPulse-Tests/        # Tests unitaires & UI
├── ci_scripts/             # Xcode Cloud CI
└── .swiftlint.yml          # Linting config
```

## 🔌 APIs

- **Jolpica F1** — Données historiques (1950→présent), gratuit, pas d'auth
- **OpenF1** — Données live & telemetry (2023+), gratuit pour l'historique

## 🎨 Design

Minimalisme automobile. Couleurs d'écurie comme langage visuel. Glass morphism iOS 26. Lignes nettes, pas de chrome.

Voir [ARCHITECTURE.md](./ARCHITECTURE.md) pour les détails.

## 📋 Development Phases

### Phase 1 — Foundation (v0.1.0)
- Xcode project + SwiftData models
- Jolpica API (drivers, constructors, schedule, standings)
- Home, Schedule, Standings tabs
- Team colors + Glass components

### Phase 2 — Race Weekend (v0.2.0)
- Race detail view (sessions, results)
- OpenF1 integration
- Driver & Constructor detail views

### Phase 3 — Live (v0.3.0)
- OpenF1 live data
- Live Activity
- Push notifications
- Widgets

### Phase 4 — Polish (v1.0.0)
- i18n (EN + FR)
- Accessibility (VoiceOver, Dynamic Type)
- iPad
- App Store submission

## 🏗 CI/CD

Xcode Cloud uniquement (pas de GitHub Actions pour Apple).

## 📄 License

MIT