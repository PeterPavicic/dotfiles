// Shared prefs for every Firefox/Zen profile, linked in by
// other/link_mozilla_profiles.sh. Firefox applies these on each startup and
// only overrides the prefs listed here, so everything else in prefs.js
// (e.g. browser.uidensity for compact mode) stays per-machine.

// Load chrome/userChrome.css (Zen enables this by default, Firefox doesn't)
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Let the page area be transparent too, not just the toolbars
user_pref("browser.tabs.allow_transparent_browser", true);
