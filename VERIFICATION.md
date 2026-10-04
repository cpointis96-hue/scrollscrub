# Vérification du prototype

Contrôles effectués le 4 octobre 2026 sur la copie préparée pour le portfolio, avec Node.js 26.7.0, npm, Vite 7.3.6 et Chromium piloté par Playwright.

| Contrôle | Résultat | Portée |
|---|---|---|
| `npm ci --ignore-scripts` | Réussi, 15 paquets installés | Installation depuis le lockfile |
| `npm run build` | Réussi | Compilation Vite ; 10 modules transformés |
| `bash scripts/segment-components.sh` | Réussi, 11 couches générées | ImageMagick ; copies mises à jour dans `public/assets/components/`, puis build relancé avec succès |
| Serveur de développement | HTTP 200 | Écoute sur `127.0.0.1:4174` |
| Premier affichage | `Assembly ready` | Les références et les couches sont chargées |
| Fin de défilement | `Assembly complete` | Progression déclenchée par le scroll, pas par un appel direct au moteur |
| Mouvement réduit | Assemblage affiché directement | Préférence `prefers-reduced-motion: reduce` émulée, page rechargée |
| Largeur mobile | Aucun débordement horizontal à 390 px | Viewport 390 × 844 en mode mouvement réduit |
| Erreurs JavaScript | Aucune pendant ces parcours | Les erreurs de page sont collectées par Playwright |
| Captures | Réalisées | Intro et assemblage à 1440 × 900 ; vue mobile |

La génération des couches se fait avec `bash scripts/segment-components.sh`. La préparation corrige un point de reprise : les couches recalculées sont copiées vers le dossier public utilisé par le navigateur.

Ces contrôles ne prouvent pas la fluidité sur tout matériel, la qualité des assets dans toutes les tailles, la compatibilité Safari/Firefox, l’accessibilité complète ou le fonctionnement d’un service commercial. L’ancienne extraction vidéo n’a pas été exécutée dans cette préparation : elle ne participe pas au fonctionnement de la version courante.
