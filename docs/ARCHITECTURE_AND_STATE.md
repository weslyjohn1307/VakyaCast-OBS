# Architecture, State & Synchronization Specification (`ARCHITECTURE_AND_STATE.md`)

## 1. Multi-Channel Synchronization Engine
`broadcastStateToOverlays()` synchronizes the control surface (`?mode=studio` or `?mode=dock`) with all active overlay instances (`?mode=overlay`):
- **Channel 1 — `BroadcastChannel('vakyacast_bible_lt_channel')`**: Zero-latency in-memory message bus across tabs/windows sharing the same browser context.
- **Channel 2 — `localStorage` (`vakyacast_lt_live_state_v1`)**: Persistent state storage and cross-tab `window.onstorage` fallback.
- **Channel 3 — `window.postMessage` (`VAKYACAST_SYNC`)**: Direct window reference messaging for the `↗ Pop-out Overlay` window.
- **Channel 4 — Local HTTP Sync Bridge (`127.0.0.1:8765`)**: PowerShell `HttpListener` bridge (`scripts/Start-Browser-To-OBS-Bridge.bat`) that relays JSON state between external browsers (Chrome/Edge/Firefox) and OBS Studio's isolated CEF Browser Source.

## 2. Read-Only Overlay Isolation (Zero-Flash Guarantee)
When `window.location.search` contains `mode=overlay`:
- `state.isLive` defaults to `false` unless `localStorage` explicitly indicates `isLive: true`.
- `broadcastStateToOverlays()` returns early so a refreshing OBS Browser Source never overwrites the operator's control state.
- `.lt-wrapper.lt-hidden` and `.media-overlay-wrapper.media-hidden` apply `visibility: hidden; opacity: 0; pointer-events: none;`.
