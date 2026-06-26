# 🔍 F1 Tracker — Research

## Box Box Club (Inspiration)

**Box Box Club** — app F1 iOS avec 3M+ utilisateurs.

### Features clés
- **Widgets** : Lock Screen & Home Screen widgets (race countdown, standings, driver stats)
- **Live Activity** : suivi de course en temps réel sur l'écran de verrouillage
- **Calendrier** : programme complet des Grands Prix avec notifications
- **Standings** : classements pilotes & constructeurs
- **Résultats** : practice, qualifying, sprint, race
- **Design** : coloré, vibrant, chaque écurie a sa couleur distinctive, dark mode first

### Ce qui fait son succès
- **Widgets iOS** = killer feature (suivi sans ouvrir l'app)
- **Live Activity** = immersion pendant les courses
- **Couleurs d'écurie** = identification instantanée (rouge Ferrari, silver Mercedes, etc.)
- **Minimalisme** = pas de bloat, juste l'essentiel
- **Graphismes** = illustrations stylisées, pas de photos génériques

### Ce qu'on peut améliorer
- UI plus « automobile » / racing feel
- Mieux exploiter Liquid Glass (iOS 26)
- Navigation plus fluide
- Plus de données télemétriques (via OpenF1)
- Design plus personnel, moins générique

## APIs F1 Disponibles

### 1. Jolpica F1 API (successeur d'Ergast)
- **URL** : `https://api.jolpica.com/ergast/f1/`
- **Gratuit** : Oui, pas d'auth
- **Rate limit** : ~4 req/s (200/h soft limit)
- **Données** : Historiques complètes (1950→présent)
  - Drivers, Constructors, Circuits, Seasons, Races
  - Results, Qualifying, Sprint, Standings, Lap Times
  - Pit Stops, Finishing Status
- **Avantage** : Données historiques riches, compatible Ergast
- **Inconvénient** : Pas de live telemetry, pas de données temps réel

### 2. OpenF1 API
- **URL** : `https://api.openf1.org/v1/`
- **Gratuit** : Oui (historique depuis 2023), pas d'auth
- **Paid** : Données temps réel nécessitent abonnement
- **Endpoints** (18 au total) :
  - `/car_data` — telemetry (speed, brake, throttle, DRS, gear, RPM) @ 3.7Hz
  - `/championship_drivers` — classement pilotes (beta)
  - `/championship_teams` — classement constructeurs (beta)
  - `/drivers` — infos pilotes
  - `/intervals` — écarts entre pilotes
  - `/laps` — temps par tour
  - `/location` — position GPS sur circuit
  - `/meetings` — weekends de Grand Prix
  - `/overtakes` — dépassements
  - `/pit` — arrêts au stand
  - `/position` — positions pendant la course
  - `/race_control` — messages race control (flags, penalties)
  - `/sessions` — sessions (FP1, FP2, FP3, Q, Sprint, Race)
  - `/session_result` — résultats de session
  - `/starting_grid` — grille de départ
  - `/stints` — stint composés (medium, soft, hard)
  - `/team_radio` — radio team
  - `/weather` — météo sur circuit
- **Avantage** : Données ultra-riches, telemetry en temps réel, données live
- **Inconvénient** : Historique limité (2023+), temps réel = payant

### Stratégie API
- **Jolpica** pour les données historiques (saisons avant 2023, palmarès complet)
- **OpenF1** pour les données récentes et détaillées (telemetry, live)
- Cache local SQLite pour offline-first
- Sync intelligente : Jolpica pour bootstrap, OpenF1 pour enrichir

## Concurrents sur l'App Store

| App | Forces | Faiblesses |
|-----|--------|------------|
| **Box Box Club** | Widgets, Live Activity, 3M users | Design un peu générique, paywall agressif |
| **F1 TV** | Officiel, live streaming | Trop cher, UX lourde, pas de widgets |
| **F1 Dashboard** | Data-rich | Design daté, pas de Liquid Glass |
| **FastF1 Companion** | Telemetry | Pas de widgets, UX technique |

## Notre Positionnement

**Nom de code** : `GridPulse` (pulse du départ, vibe F1)

**Différenciateurs** :
1. **Liquid Glass iOS 26** — premier app F1 avec le nouveau design
2. **Car-oriented design** — pas juste des stats, une identité visuelle racing
3. **Dual API** — Jolpica (historique) + OpenF1 (live/rich)
4. **Widgets + Live Activity** — comme Box Box mais plus beau
5. **Minimalisme coloré** — couleurs d'écurie comme language visuel
6. **Gratuit** avec features premium optionnelles (pas de paywall agressif)