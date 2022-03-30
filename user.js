// Mozilla User Preferences
// Configured with the following sources:
//  - https://ffprofile.com/
//
// compare with https://github.com/claustromaniac/Compare-UserJS
//
// TODO:
// - https://github.com/arkenfox/user.js
// - https://github.com/pyllyukko/user.js
// - https://www.ghacks.net/2015/08/18/a-comprehensive-list-of-firefox-privacy-and-security-settings/

// ???
user_pref("app.normandy.api_url", "");
user_pref("app.normandy.enabled", false);
// keep firefox studies enabled
user_pref("app.shield.optoutstudies.enabled", false);

// downloads and alerts that new updates are available, but auto-update itself is turned off
user_pref("app.update.auto", false);
user_pref("beacon.enabled", false);
user_pref("breakpad.reportURL", "");

// don't show warning on about:config page
user_pref("browser.aboutConfig.showWarning", false);

// disable caching to disk
user_pref("browser.cache.disk.capacity", 25600);
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.disk.smart_size.enabled", false);
user_pref("browser.cache.offline.enable", false);

// don't submit crash reports
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
user_pref("browser.crashReports.unsubmittedCheck.enabled", false);
user_pref("browser.fixup.alternate.enabled", false);
user_pref("browser.formfill.enable", false);
user_pref("browser.newtab.preload", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.enhanced", false);
user_pref("browser.newtabpage.introShown", true);
user_pref("browser.ping-centre.telemetry", false);


// disable info leak with safe browsing
user_pref("browser.safebrowsing.appRepURL", "");
user_pref("browser.safebrowsing.blockedURIs.enabled", false);
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.url", "");
user_pref("browser.safebrowsing.enabled", false);
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);

// don't suggest ssearch results
user_pref("browser.search.suggest.enabled", false);

// search widget in navbar
user_pref("browser.search.widget.inNavBar", true);
user_pref("browser.selfsupport.url", "");
user_pref("browser.send_pings", false);
user_pref("browser.sessionstore.privacy_level", 2);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.toolbars.bookmarks.visibility", "always");
user_pref("browser.urlbar.groupLabels.enabled", false);
user_pref("browser.urlbar.quicksuggest.enabled", false);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("browser.urlbar.trimURLs", false);
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("device.sensors.ambientLight.enabled", false);
user_pref("device.sensors.enabled", false);
user_pref("device.sensors.motion.enabled", false);
user_pref("device.sensors.orientation.enabled", false);
user_pref("device.sensors.proximity.enabled", false);
user_pref("devtools.screenshot.clipboard.enabled", true);
user_pref("dom.battery.enabled", false);
user_pref("dom.event.clipboardevents.enabled", false);
// don't let websites fuck up the context menu
user_pref("dom.event.contextmenu.enabled", false);
user_pref("dom.storage.enabled", false);
user_pref("dom.webaudio.enabled", false);
user_pref("experiments.activeExperiment", false);
user_pref("experiments.enabled", false);
user_pref("experiments.manifest.uri", "");
user_pref("experiments.supported", false);
user_pref("extensions.CanvasBlocker@kkapsner.de.whiteList", "");
user_pref("extensions.ClearURLs@kevinr.whiteList", "");
user_pref("extensions.Decentraleyes@ThomasRientjes.whiteList", "");
user_pref("extensions.FirefoxMulti-AccountContainers@mozilla.whiteList", "");
user_pref("extensions.getAddons.cache.enabled", false);
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.greasemonkey.stats.optedin", false);
user_pref("extensions.greasemonkey.stats.url", "");

// disable pocket
user_pref("extensions.pocket.enabled", false);

user_pref("extensions.screenshots.upload-disabled", true);
user_pref("extensions.shield-recipe-client.api_url", "");
user_pref("extensions.shield-recipe-client.enabled", false);
user_pref("extensions.webservice.discoverURL", "");

// disable geolocation
user_pref("geo.enabled", false);

// disable webassembly
user_pref("javascript.options.wasm", false);
user_pref("javascript.options.wasm_baselinejit", false);
user_pref("javascript.options.wasm_ionjit", false);

user_pref("keyword.enabled", false);
user_pref("media.autoplay.default", 1);
user_pref("media.autoplay.enabled", false);
user_pref("media.eme.enabled", false);
user_pref("media.gmp-widevinecdm.enabled", false);
user_pref("media.hardwaremediakeys.enabled", false);
user_pref("media.navigator.enabled", false);

// completely disable webrtc
user_pref("media.peerconnection.enabled", false);

// prevent leaking local ip
user_pref("media.peerconnection.ice.default_address_only", true);

user_pref("media.video_stats.enabled", false);
user_pref("network.IDN_show_punycode", true);
user_pref("network.allow-experiments", false);
// disable connection tests
user_pref("network.captive-portal-service.enabled", false);

// https://developer.mozilla.org/en-US/docs/Web/Privacy/State_Partitioning#disable_dynamic_state_partitioning
user_pref("network.cookie.cookieBehavior", 5);
user_pref("network.cookie.lifetimePolicy", 2);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);

// https://wiki.mozilla.org/Security/Referrer
// https://wiki.archlinux.org/title/Firefox/Privacy#Disable_HTTP_referer
// send the header only when clicking on links and similar elements
user_pref("network.http.sendRefererHeader", 1);
// send a referrer only on same-origin
user_pref("network.http.referer.XOriginPolicy", 2);
// Send only the scheme, host, and port in the Referer header.
user_pref("network.http.referer.trimmingPolicy", 2);
// When sending across origin, send only the scheme, host, and port in the Referer header.
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);
// network.IDN_show_punycode
user_pref("network.IDN_show_punycode", true);

user_pref("network.http.speculative-parallel-limit", 0);
user_pref("network.predictor.enable-prefetch", false);
user_pref("network.predictor.enabled", false);
user_pref("network.prefetch-next", false);
user_pref("network.trr.custom_uri", "https://dns11.quad9.net/dns-query");
user_pref("network.trr.mode", 2);

// DNS trusted recursive receiver
user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");

user_pref("pdfjs.enableScripting", false);

// Printer Settings default have no header/footer info
user_pref("print.print_footerleft", "");
user_pref("print.print_footerright", "");
user_pref("print.print_headerleft", "");
user_pref("print.print_headerright", "");

user_pref("privacy.clearOnShutdown.cookies", true);
user_pref("privacy.clearOnShutdown.downloads", false);
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.donottrackheader.enabled", true);
user_pref("privacy.donottrackheader.value", 1);
user_pref("privacy.firstparty.isolate", true);
user_pref("privacy.history.custom", true);
user_pref("privacy.purge_trackers.date_in_cookie_database", "0");
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
user_pref("privacy.trackingprotection.pbmode.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.userContext.enabled", true);
user_pref("privacy.usercontext.about_newtab_segregation.enabled", true);
user_pref("security.ssl.disable_session_identifiers", true);
user_pref("security.ssl.require_safe_negotiation", true);
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
user_pref("services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite", false);
user_pref("signon.autofillForms", false);
user_pref("signon.rememberSignons", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.archive.enabled", true);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.cachedClientID", "");
user_pref("toolkit.telemetry.enabled", false)
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.hybridContent.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.pioneer-new-studies-available", true);
user_pref("toolkit.telemetry.prompted", 2);
user_pref("toolkit.telemetry.rejected", true);
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("toolkit.telemetry.server", "");
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.unifiedIsOptIn", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);

// disable webGL
//user_pref("webgl.disabled", true);


user_pref("browser.contextual-services.contextId", "");
user_pref("browser.newtabpage.activity-stream.impressionId", "");
user_pref("browser.sessionstore.upgradeBackup.latestBuildID", "");
user_pref("dom.push.userAgentID", "");
user_pref("extensions.lastAppBuildId", "");
user_pref("security.sandbox.content.tempDirSuffix", "");
user_pref("toolkit.startup.last_success", 0);
user_pref("browser.startup.lastColdStartupCheck", 0);
user_pref("privacy.sanitize.pending", "[{\"id\":\"shutdown\",\"itemsToClear\":[\"cache\",\"cookies\",\"offlineApps\",\"formdata\",\"sessions\"],\"options\":{}},{\"id\":\"newtab-container\",\"itemsToClear\":[],\"options\":{}}]");
user_pref("services.settings.last_etag", "");
