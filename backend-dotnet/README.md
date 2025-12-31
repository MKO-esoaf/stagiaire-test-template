# Backend .NET

## Prérequis
- .NET 6 ou supérieur

## Lancer le backend

```bash
cd backend-dotnet
dotnet run
```

Le service écoute sur http://localhost:5000

## Endpoints
- **GET /api/hello** : `?name=VotreNom` (optionnel) — Retourne "Hello, world!" ou "Hello, VotreNom!"
- **POST /api/greet** : Body JSON `{ "name": "VotreNom" }` (min 2 caractères) — Répond "Hello, VotreNom!"
- **GET /api/health** : Vérifie que l'API fonctionne

Toutes les réponses sont au format :
```json
{
	"success": true,
	"message": "..."
}
```

En cas d'erreur de validation, `success` est `false` et `message` explique l'erreur.