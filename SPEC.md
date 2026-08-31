# Contatore — Spec

## Obiettivo
Pagina con pulsante che incrementa un contatore client-side. Ad ogni click il frontend invia il valore corrente a un backend stateless che calcola radice quadrata, quadrato e valore moltiplicato per π.

## Stack
- Frontend: `index.html` (HTML/CSS/JS vanilla, nessuna dipendenza)
- Backend: `app.py` (FastAPI), serve anche `index.html`
- Esecuzione: `uvicorn app:app`, porta 8000

## Requisiti funzionali
- Pulsante **+1** al centro: incrementa contatore locale (var JS, non persistito)
- Pulsante **Reset**: azzera contatore locale e pulisce area risultati, nessuna chiamata al backend
- Refresh pagina: contatore riparte da 0 (nessuna persistenza server o browser storage)
- Ad ogni click su **+1**: frontend chiama backend con il valore aggiornato del contatore, mostra i 3 risultati ricevuti

## API
`GET /compute/{n}`

- `n`: intero nel path, `>= 0` (validato via FastAPI `Path(ge=0)`)

Response `200`:
```json
{"sqrt": 1.73, "square": 9, "times_pi": 9.42}
```
- Tutti i valori numerici arrotondati a 2 decimali
- Calcolo stateless: nessun DB, nessuna sessione, nessun log persistente

Response `422`: automatico da FastAPI se `n` non è un intero `>= 0`.

`GET /`
- Serve `index.html`

## Gestione errori (frontend)
- Chiamata a `/calcola` fallita (rete, 5xx, 422): contatore locale resta al valore già incrementato, si mostra un banner di errore non bloccante, l'area risultati mantiene l'ultimo valore valido (non si azzera)
- Nessun retry automatico

## UI
- Layout centrato, minimal, CSS inline in `index.html`, nessuna libreria esterna
- Elementi: pulsante "+1", pulsante "Reset", contatore, area risultati (√, ², ×π)

## Testing
- Verifica manuale in browser (esercitazione didattica): click incrementa e mostra risultati corretti, reset azzera, refresh azzera, errore backend mostra banner senza perdere il contatore
- Nessuna suite automatica

## Fuori scope
- Persistenza contatore (DB, sessione, localStorage)
- Autenticazione
- Decremento contatore
- Log/telemetria backend
