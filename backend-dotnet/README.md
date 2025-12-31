# Backend .NET

Instructions pour lancer le service.
## Prérequis
- .NET 6 ou supérieur

## Lancer le backend

```bash
cd backend-dotnet
dotnet run
```

Le service écoute sur http://localhost:5000

## Endpoints
- **GET /hello** : Retourne un message "Hello, world!"
- **POST /greet** : Prend un JSON `{ "name": "VotreNom" }` et répond "Hello, VotreNom!"