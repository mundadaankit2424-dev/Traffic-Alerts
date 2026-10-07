CREATE TABLE IF NOT EXISTS push_subscriptions (id TEXT PRIMARY KEY, endpoint TEXT NOT NULL UNIQUE, p256dh TEXT NOT NULL, auth TEXT NOT NULL, created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS schedules (id TEXT PRIMARY KEY, subscription_id TEXT NOT NULL REFERENCES push_subscriptions(id) ON DELETE CASCADE, route_id TEXT NOT NULL, origin TEXT NOT NULL, destination TEXT NOT NULL, label TEXT NOT NULL, local_time TEXT NOT NULL, days TEXT NOT NULL, enabled INTEGER NOT NULL DEFAULT 1, last_sent TEXT);
CREATE INDEX IF NOT EXISTS schedules_enabled_time ON schedules(enabled, local_time);
CREATE TABLE IF NOT EXISTS api_usage (month TEXT PRIMARY KEY, calls INTEGER NOT NULL DEFAULT 0);
