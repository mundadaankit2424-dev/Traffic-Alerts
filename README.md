# Commute — Pune

Installable mobile web app for route estimates, departure-time comparisons, and scheduled ETA notifications. The GitHub Pages site serves the app. A Cloudflare Worker privately calls Google Routes, keeps request usage capped, and sends web push notifications.

## Included features

- Save multiple home-to-office routes on this phone.
- **Check live traffic** to show best-guess ETA, usual time, cautious estimate, distance, and an estimated light/moderate/heavy label in the app. If notifications are allowed, a manual check also shows a phone notification.
- Compare two planned departure times, such as 5 PM and 6 PM.
- Schedule an ETA push for a saved route at a chosen India time on weekdays or every day. Tapping the notification opens the app with the estimate; Google Maps is available for navigation.
- Show current weather for the route's two places using Open-Meteo.

## Publish the app files

Copy the contents of this bundle to the root of the public `Pune-commute` repository, including the complete `worker/` folder. Commit and push. GitHub Pages should publish the top-level `index.html`, manifest, service worker, and icon from the `main` branch root.

## One-time service setup

GitHub Pages cannot securely hold a Google API key or run scheduled jobs. These are required to make the live ETA and automatic notifications work.

1. Create a Google Cloud project, enable **Routes API**, enable billing, and make an API key restricted to Routes API. Keep the key private.
2. Install Node.js 20 or newer. In a terminal, enter `worker/` and run `npm install`.
3. Run `npm run db:create`; copy the returned database ID into `database_id` in `wrangler.jsonc` in place of `REPLACE_WITH_D1_DATABASE_ID`.
4. Run `npm run db:init` to create the tables.
5. Run `npm run vapid` and `npm run token`. Save the generated output privately. Never commit private keys or the app token.
6. Set these Worker secrets using Wrangler: `npx wrangler secret put GOOGLE_MAPS_API_KEY`, `APP_TOKEN`, `VAPID_PUBLIC_KEY`, `VAPID_PRIVATE_KEY`, and `VAPID_SUBJECT`. For `VAPID_SUBJECT`, use a contact value such as `mailto:you@example.com`.
7. Run `npm run deploy`. Copy the deployed Worker URL.
8. On the phone, open the published app over HTTPS and install it from the browser menu. Open **Connect traffic service**, enter the Worker URL and app token, and save. Save a route, enable phone notifications, then choose its notification time and repeat days.

The GitHub Pages origin and URL are set in `worker/wrangler.jsonc`; change them if the Pages address changes. On iPhone, web push requires adding the site to the Home Screen and iOS/iPadOS 16.4 or later. Keep notifications enabled for the installed app.

## Cost, privacy, and limits

- Google requires a billing-enabled project for Routes API. This Worker stops app requests at **4,000 Routes requests per month**; one estimate uses two requests and a comparison uses four. Google pricing/free allowances vary by billing region and can change. Other API usage on the same billing account can consume its free allowance, so the cap does not guarantee zero charges. Use a separate billing account with budget alerts and API quotas if you proceed.
- Cloudflare Workers and D1 have free plan limits, which can change. If usage limits are exceeded, scheduled notifications can pause.
- Do not put secrets in GitHub. The web app stores the Worker URL and app token in this phone's local browser storage. Saved route addresses stay on the phone until you schedule notifications; scheduled route addresses are stored in the Worker database to check them at the chosen times.
- Open-Meteo place geocoding receives the place text. Its free API is for personal, non-commercial use and requires attribution.

## Notes

The Google Routes best-guess and pessimistic durations are estimates. The app's traffic label compares estimated and usual duration; it is not a road-incident feed. Forecasts for future departure times can differ from actual traffic. Push delivery depends on the phone's OS, network, and battery settings.
