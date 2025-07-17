// Service Worker for Tab Ahead
// This replaces the background page (bg.html) in Manifest V3

// The service worker will be installed and activated automatically
// No specific background functionality is needed for this extension
// as the popup handles all the tab querying and switching logic

console.log('Tab Ahead service worker loaded');

// Optional: Add any background functionality here if needed in the future
// For example, listening for tab events, managing extension state, etc. 

// TODO: Not sure if this is needed anymore. On manifest v2, we used a bg.html file:
// This is really just to render some
// background page forcing Chrome to
// preload the plugin code such that the
// popup opens quickly later on.
// See http://stackoverflow.com/questions/20139744/browseraction-opens-slowly-unless-already-open-in-a-tab
// and http://stackoverflow.com/questions/26276815/my-chrome-extension-popup-opens-after-a-few-seconds-its-slow-compared-to-other
