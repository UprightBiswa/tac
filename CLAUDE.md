# TAC Industries — Ride-sharing POC

## Project
TAC Industries is building an **Ireland-focused carpooling / ride-sharing app**. Riders and drivers share journeys, with a focus on lower emissions and stronger communities.
- Developer: Biswajit Das. Manager / reviewer: **Jenish Justin**.
- Current phase: **front-end POC only, no backend.**

## Agreed stack (Oct 24, confirmed)
- Frontend: **Flutter** (Android first, iOS later)
- Backend: **NestJS** (TypeScript, Node), as a modular monolith
- Database: **PostgreSQL** (PostGIS later)
- The long-term architecture is in `NestJS_Backend_Architecture 1.pdf` (not in repo). It has 5 layers:
  1. Client: Flutter app and admin web
  2. Edge: load balancer, EU region
  3. NestJS modules: Auth, Users, Vehicles, Rides, Search, Bookings, Payments, Messaging, Trust & safety, Notifications, Admin
  4. Data: Postgres, Redis, BullMQ
  5. Outside services: SMS, payments, ID verification, maps, FCM, email, EU file storage

  **None of the backend is in POC scope yet.**

## Current deliverable (due Friday 2026-10-30 brief)
Jenish asked for:
1. **A theme with colour combinations, set first.**
2. **A clickable HTML + JS flow:** each tap goes to the next screen. It covers onboarding, then **search location → see available riders → book a ride**, etc. All mock data, **no backend**.

The full screen-by-screen spec, theme tokens and mock data are in **[docs/FLOW.md](docs/FLOW.md)**. Build from that spec.

## Files
| File | What it is |
|---|---|
| `tac_onboarding_poc_plan.html` | Static team plan: 6 onboarding screens, architecture, API proposal, milestones, team-input checklist |
| `tac_clickable_onboarding_flow.html` | **The Friday deliverable.** A clickable phone prototype of the full flow in `docs/FLOW.md`: onboarding (01–06, Google stub, manual address), rider (07 Home → 15 Rate) and driver (D1–D3). It has 3 tabs: Clickable demo (screen list, phone, and a "Next actions" side panel), Flow map, and Theme & colours. Single file, mock data only. |
| `tac_app/` | **Flutter POC** (Android first). Same screens + mock data as the HTML flow. Riverpod 3, go_router, Dio, secure storage. See `tac_app/README.md` for structure, env and security rules. Run: `flutter run --dart-define-from-file=env/dev.json` |
| `docs/FLOW.md` | Spec for the full clickable POC: theme, onboarding, rider, driver, and the backend mapping |

## Next steps
1. ~~Build the full clickable prototype~~ Done (2026-10-29) in `tac_clickable_onboarding_flow.html`.
2. Share it with Jenish for review before Friday, then apply the fixes.
3. After approval: build a Flutter POC with the same screens and mock data (feature-first structure, `lib/app/theme`, `lib/features/...`). It should run on a physical Android device. Screenshots go to Jenish.
4. Later: NestJS `health`, `auth/otp/*` and `users/me` endpoints. The API proposal is in `tac_onboarding_poc_plan.html`.

## Conventions
- **Prototype HTML:** one self-contained file with inline CSS/JS. No build step and no external network calls, so it opens offline by double-click. It must work at phone width.
- **Theme:** use the tokens in `docs/FLOW.md` §2. Primary orange `#F36B21`, navy `#15243C`, white surfaces.
- **Be honest in demos:** OTP, Google sign-in, location, payments and chat are simulated. Label them as demo; never imply real verification or payment happened.
- **Mock data:** Irish places, EUR prices, fictional names, plates and card numbers only. No real personal data.
- **Logo:** don't redraw or invent the TAC logo. Use a text placeholder until the approved asset is supplied, and check whether the orange or navy variant is approved.
- Out of scope until requested: real auth, payments, chat, PostGIS matching, Redis/BullMQ, deployment.

## Open items with the team
Repo/app ID, Flutter state-management choice, ORM, SMS provider, Google OAuth decision, maps provider, staging host, approved logo/fonts. See the checklist in `tac_onboarding_poc_plan.html`.
