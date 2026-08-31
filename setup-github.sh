#!/usr/bin/env bash
# Configura label e branch protection su un repo GitHub.
# Uso:  cd nel-tuo-repo && bash /percorso/setup-github.sh
# Prereq: gh installato e autenticato (gh auth login). Da lanciare DENTRO il repo.
set -euo pipefail

REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
echo "Repo: $REPO"

echo "== Pulizia default poco utili =="
for l in "good first issue" duplicate invalid question wontfix enhancement; do
  gh label delete "$l" --yes 2>/dev/null || true
done

echo "== Creazione label =="
create() { gh label create "$1" -c "$2" -d "$3" --force; }
# TYPE
create "type:bug"       D73A4A "Malfunzionamento"
create "type:feature"   0E8A16 "Nuova funzionalità"
create "type:refactor"  FBCA04 "Refactor / debito tecnico"
create "type:docs"      0075CA "Documentazione"
create "type:test"      BFD4F2 "Test"
create "type:chore"     EDEDED "Manutenzione / config"
# PRIORITY (= severità Gemini)
create "priority:critical" B60205 "Blocca o sfruttabile ora"
create "priority:high"     D93F0B "Da fare presto"
create "priority:medium"   FBCA04 "Normale"
create "priority:low"      0E8A16 "Bassa"
# AREA
create "area:api"       1D76DB "Endpoint / route"
create "area:data"      1D76DB "Redis / storage"
create "area:infra"     5319E7 "Docker / CI"
create "area:security"  B60205 "Sicurezza"
# STATUS
create "status:needs-changes" E99695 "Richiede modifiche"
create "status:in-review"     FEF2C0 "In review"
create "status:blocked"       000000 "Bloccato"
# COMMUNITY
create "help wanted"     008672 "Serve aiuto"

echo "== Branch protection su main =="
# require_code_owner_reviews e' su false: cosi' il template funziona SENZA
# personalizzare il CODEOWNERS. Personalizza CODEOWNERS e metti CODEOWNERS=true
# per obbligare la review dell'owner.
CODEOWNERS=${CODEOWNERS:-false}
gh api -X PUT "repos/$REPO/branches/main/protection" \
  -H "Accept: application/vnd.github+json" \
  -F "required_pull_request_reviews[required_approving_review_count]=1" \
  -F "required_pull_request_reviews[require_code_owner_reviews]=$CODEOWNERS" \
  -F "required_pull_request_reviews[dismiss_stale_reviews]=true" \
  -F "required_conversation_resolution=true" \
  -F "enforce_admins=false" \
  -F "restrictions=null" \
  -F "required_status_checks=null" \
  || echo "  (branch protection: se fallisce, il repo e' privato su piano Free -> fallo dalla UI)"

echo "Fatto."
