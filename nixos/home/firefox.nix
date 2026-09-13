{ pkgs, config, ... }:
{
  programs.firefox = {
  enable = true;

  languagePacks = [
    "ru" 
    "en-US"
  ];

  profiles.default = {
    id = 0;
    isDefault = true;

    settings = {
      "browser.startup.homepage" = "about:home";
      "privacy.trackingprotection.enabled" = true;
      "gfx.webrender.all" = true;

      # --- Telemetry settings --- #
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.server" = "data:,";
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      "toolkit.telemetry.coverage.opt-out" = true;
      "toolkit.coverage.opt-out" = true;
      "toolkit.coverage.endpoint.base" = "";
      "browser.ping-centre.telemetry" = false;
      "app.shield.optoutstudies.enabled" = false;
      "app.normandy.enabled" = false;
      "app.normandy.api_url" = "";
      "breakpad.reportURL" = "";
      "browser.tabs.crashReporting.sendReport" = false;
      
      # --- Firefox account pushiness --- #
      "extensions.pocket.enabled" = false;
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
      "browser.newtabpage.activity-stream.feeds.snippets" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.default.sites" = "";

      # --- Tracking protection --- #
      "privacy.trackingprotection.socialtracking.enabled" = true;
      "privacy.trackingprotection.emailtracking.enabled" = true;
      "privacy.donottrackheader.enabled" = true;
      "privacy.globalprivacycontrol.enabled" = true;

       # --- WebRTC IP leak ---
       "media.peerconnection.ice.default_address_only" = true;
       "media.peerconnection.ice.no_host" = true;
        
       # --- Prefetch / speculative connections ---
       "network.prefetch-next" = false;
       "network.dns.disablePrefetch" = true;
       "network.predictor.enabled" = false;
       "network.http.speculative-parallel-limit" = 0;
       "browser.urlbar.speculativeConnect.enabled" = false;

       # --- Search --- #
       "browser.urlbar.suggest.quicksuggest.sponsored" = false;
       "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
       "browser.urlbar.trending.featureGate" = false;
       "browser.search.suggest.enabled" = false;
       "browser.urlbar.suggest.searches" = false;

       # --- Permissions --- #
       "geo.enabled" = false;
       "device.sensors.enabled" = false;
       "dom.gamepad.enabled" = false;
       "dom.battery.enabled" = false;

       # --- Media --- #
       "media.autoplay.default" = 5;

       # --- Theme --- #
       "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    };

    extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      adaptive-tab-bar-colour
      ];
    };
  };
}
