# TAC Industries — POC App Flow Specification

Status: Draft v1 · 2026-10-29 · Owner: Biswajit Das · Reviewer: Jenish Justin
Purpose: The spec for the **clickable front-end POC** shown at the Friday brief. It is also the screen list for the Flutter POC later.

> **No backend.** Every screen uses mock data and simulated actions. OTP, Google sign-in, location, payments and chat are demo stand-ins and must be labelled that way in the UI.

---

## 1. What the manager asked (source of truth)

| Date | Ask (Jenish Justin) |
|---|---|
| Oct 24 | Stack: Flutter + NestJS + PostgreSQL. "Validate this and start to implement the POC kind of flow first." |
| Oct 27 | "Keep me updated on the steps… share screenshots wherever available." |
| Oct 27 (WhatsApp) | "**Set a theme first, including color combinations.** Create a flow like **search the location and riders, book a ride, etc. without backend.**" |
| Oct 28 | "Prepare a front-end flow using simple HTML and scripts. **If we click, it has to show the next action.** Friday we show this in the brief." Miro is suggested, but HTML is fine. |
| Oct 29 | "HTML is also fine, but I want the flow like **if I click, it has to take me to the next points.**" |

**Deliverable for Friday:** one HTML file that opens in a browser and works like a phone app. Each tap moves to the next screen, and a flow map lets the reviewer jump to any step.

---

## 2. Theme and colour combinations (do this first)

Taken from the TAC onboarding reference designs (orange + white + navy).

### Colour tokens

| Token | Hex | Use |
|---|---|---|
| `primary` | `#F36B21` | Main CTAs, active states, pins, links |
| `primaryLight` | `#FF8A36` | Gradient end for CTA buttons |
| `primaryDark` | `#D94910` | Pressed state, splash gradient start |
| `primarySoft` | `#FFF0E7` | Chips, selected cards, badges background |
| `navy` | `#15243C` | Headings, dark surfaces, app bar on dark |
| `ink` | `#243044` | Body text |
| `muted` | `#6D7788` | Secondary text, hints |
| `line` | `#E2E7EE` | Borders, dividers |
| `bg` | `#F4F6F9` | Screen background behind cards |
| `surface` | `#FFFFFF` | Cards, inputs, sheets |
| `success` / eco | `#167C59` | Confirmed booking, CO₂ saved, verified badge |
| `warning` | `#E8A317` | Few seats left, pending request |
| `error` | `#B54732` | Validation errors, cancelled |
| `mapWater` / `mapLand` | `#CFE6F5` / `#EEF3E6` | Static map illustrations |

**Gradients:** CTA = `primary → primaryLight` (left→right). Splash = `primaryDark → primaryLight` (135°).

### Typography (Inter, or system fallback)
| Style | Size / weight |
|---|---|
| Display (screen titles) | 26–28 / 800 |
| Title (card headers) | 18 / 700 |
| Body | 14–15 / 400 |
| Label / button | 14 / 700 |
| Caption | 12 / 500, `muted` |

### Shape and spacing
- 8-pt spacing grid; screen side padding 20.
- Radius: buttons 14, inputs 12, cards 16, sheets 24 (top).
- Button height 52; input height 52; min touch target 44.
- Shadow: soft, `0 4 16 rgba(21,36,60,0.06)`.

### Logo note
The reference designs use an **orange** TAC mark. The company social profile uses a **navy/blue** mark. Ask Jenish which one is approved. Until then, use a text placeholder and do not redraw the logo.

---

## 3. Full journey overview

```
ONBOARDING                         RIDER (main demo path)                        AFTER TRIP
01 Splash                          07 Home (map + "Where to?")                    14 Trip in progress
02 Welcome ──(alt) Google stub     08 Search: From / To / Date / Seats            15 Trip complete + rate driver
03 Phone number                    09 Available rides (list of drivers)
04 Verify OTP                      10 Ride details (route, driver, car)
05 Your details                    11 Book: seats, pickup, payment (mock)
06 Location ──(alt) Manual address 12 Booking confirmed
                                   13 My rides (upcoming / past)

DRIVER (secondary path, from Home toggle "Offer a ride")
D1 Offer a ride: route + date/time → D2 Seats & price per seat → D3 Ride published
```

**Primary demo path for Friday:** 01 → 06 → 07 → 08 → 09 → 10 → 11 → 12 → 14 → 15.
The alternative paths (Google, manual address, driver, no rides found) are reachable by tapping, but they are not the main line.

---

## 4. Screen-by-screen spec

Each screen lists: **what it shows**, **tap actions → next screen**, **demo states**.

### Onboarding (already built in `tac_clickable_onboarding_flow.html`)

| # | Screen | Shows | Tap → Next |
|---|---|---|---|
| 01 | Splash | Logo, "Rides for a cleaner, closer Ireland.", 3 benefits | Get started → 02 |
| 02 | Welcome | "Share the ride. A cleaner Ireland together.", map illustration, Save money · Meet people · Reduce emissions | Continue with phone → 03 · Continue with Google → G (stub) |
| 03 | Phone number | +353 selector, number field | Continue (≥7 digits) → 04 · Back → 02 |
| 04 | Verify OTP | 4 boxes, "Sent to +353 …", resend 0:24, Change | Verify → 05 · Change → 03 |
| 05 | Your details | First name, last name (required) | Continue → 06 |
| 06 | Location | Map preview, "Turn on location" | Allow → 07 · Enter address manually → 06b |
| 06b | Manual address | Address field | Save → 07 |
| G | Google (stub) | "Not configured in demo" | Back → 02 |

**Change from the current build:** onboarding must now end at **07 Home**, not a "You're ready" end screen.

### Rider flow (new — to build)

#### 07 · Home
- Static map of the area with the user's pin ("Dublin 2").
- Greeting "Hi Tega 👋" (uses the name from 05).
- Segmented toggle: **Find a ride** | **Offer a ride**.
- "Where to?" search card. Below it: recent places (Galway, Cork Airport, Limerick).
- Bottom nav: Home · My rides · Messages · Profile.
- Taps: Where to? / recent place → 08 · Offer a ride → D1 · My rides → 13 · Messages/Profile → toast "Not in POC".

#### 08 · Search
- From (prefilled "Current location – Dublin 2"), To (autocomplete list from mock places), Date (Today / Tomorrow / pick), Seats (1–4 stepper).
- Swap From/To button.
- Taps: pick destination + **Search rides** (disabled until To is set) → 09 · Back → 07.

#### 09 · Available rides
- Header: "Dublin → Galway · Tomorrow · 1 seat", plus an Edit button that goes back to 08.
- Filter chips: Earliest · Cheapest · Top rated · Women only (visual only).
- 3–4 mock ride cards (see §5). Each card shows driver photo/initials, name, ★ rating, departure → arrival time, pickup point, price per seat, seats left, eco tag "Saves 9 kg CO₂".
- Taps: card → 10 · Edit → 08.
- **Empty state (alt):** searching "Belmullet" shows "No rides yet". The user can tap **Create ride alert** (toast) or **Change search** (→ 08).

#### 10 · Ride details
- Route map (static) with pickup and drop-off pins, plus a timeline: 08:30 Dublin, Heuston → 11:00 Galway, Eyre Square.
- Driver block: name, rating, rides completed, ✓ Verified ID, ✓ Verified phone.
- Car: Toyota Corolla · Silver · 191-D-12345 (sample).
- Preferences: 🚭 No smoking · 🎵 Music OK · 🧳 1 bag.
- Price per seat, seats left.
- Taps: **Book seat** → 11 · Message driver → toast "Chat not in POC" · Back → 09.

#### 11 · Book ride
- Seats stepper (max = seats left), pickup point choice (2 radio options), note to driver (optional).
- Payment method: Card •••• 4242 (mock) / Cash to driver.
- Price summary: seats × price + €0.50 service fee = total.
- Taps: **Confirm booking** → 1.5 s loading spinner → 12 · Back → 10.

#### 12 · Booking confirmed
- ✓ success state in green: "Seat booked with Seán".
- Summary card (route, time, pickup, total, booking ref `TAC-48213`).
- Eco message: "You'll save ~9 kg CO₂ on this trip 🌱".
- Taps: **View my rides** → 13 · **Start trip (demo)** → 14 · Back to home → 07.

#### 13 · My rides
- Tabs: Upcoming (shows the booking just made) · Past (2 mock trips).
- Taps: upcoming card → 12 · Home → 07.

#### 14 · Trip in progress (demo)
- Map with car pin moving along the route (CSS animation), "Arriving in 12 min", driver card, **SOS** button (toast "Safety feature — later phase").
- Taps: **End trip (demo)** → 15.

#### 15 · Trip complete + rating
- Fare paid, CO₂ saved, 5-star rating, quick tags (Punctual · Friendly · Safe driving).
- Taps: **Submit** → toast "Thanks!" → 07.

### Driver flow (secondary)

| # | Screen | Shows | Tap → Next |
|---|---|---|---|
| D1 | Offer a ride | From / To, date, departure time | Next → D2 · Back → 07 |
| D2 | Seats & price | Seats stepper (1–4), suggested price per seat (€12), car selection | Publish ride → D3 |
| D3 | Ride published | Success state, summary, "We'll notify you when passengers book" | Back to home → 07 |

---

## 5. Mock data (Ireland, EUR)

**Places:** Dublin (Heuston, Dublin 2, Airport), Galway (Eyre Square), Cork (Kent Station, Airport), Limerick (Colbert Station), Athlone, Belfast.

**Ride results for Dublin → Galway:**

| Driver | Rating | Depart → Arrive | Pickup | €/seat | Seats left | Car |
|---|---|---|---|---|---|---|
| Seán M. | ★ 4.9 (128) | 08:30 → 11:00 | Heuston Station | €14 | 3 | Toyota Corolla |
| Aoife K. | ★ 4.8 (64) | 10:15 → 12:40 | Red Cow Luas | €12 | 1 | VW Golf |
| Ciarán O. | ★ 4.6 (31) | 13:00 → 15:30 | Dublin 2 | €11 | 2 | Skoda Octavia |
| Niamh B. | ★ 5.0 (12) | 17:45 → 20:10 | UCD Belfield | €15 | 4 | Tesla Model 3 ⚡ |

All names, plates and card numbers are fictional.

---

## 6. Interaction rules for the HTML prototype

1. **Every visible button does something.** It either goes to a screen or shows a toast that explains why the feature isn't in the POC.
2. **Flow map panel** beside the phone lists all screens, grouped as Onboarding · Rider · Driver. Clicking a screen jumps to it, and the current screen is highlighted.
3. **Back** always works, both in the phone and in the side panel.
4. Light validation only: phone ≥7 digits, names required, destination required.
5. Data entered earlier carries forward (name on Home, destination on results, seats on booking).
6. Show a "Demo — no backend" label in the footer and in the side panel.
7. Single self-contained `.html` file: no build step, opens offline, works on a phone browser too.
8. **Restart demo** button resets to 01.

---

## 7. Mapping to the backend architecture (later, not in this POC)

| Screen(s) | NestJS module (from architecture PDF) | Later integration |
|---|---|---|
| 03–04 | Auth | SMS OTP provider, JWT |
| 05, 15 | Users, profiles | Profile, ratings |
| 06, 07, 08 | — / Search | Maps & geocoding provider |
| 09 | Search | PostGIS route matching |
| 10 | Rides, Vehicles, Verification | Ride + vehicle + verified status |
| 11–13 | Bookings, Payments | Seat lock, payment provider, ledger |
| 10 "Message driver" | Messaging | WebSocket chat |
| 14 SOS | Trust and safety | Reports, SOS |
| 12, D3 | Notifications | Push (FCM), SMS, email |
| D1–D3 | Rides | Publish ride |

---

## 8. Open questions for Jenish

1. Approved logo (orange vs navy) and app name shown to users.
2. Is the driver flow (D1–D3) wanted on Friday, or is the rider flow enough?
3. Payment: card in-app, cash, or both, for the demo?
4. Should "Women only" and similar safety filters appear?
5. After Friday: same flow in Flutter (Android first) with the same mock data?
