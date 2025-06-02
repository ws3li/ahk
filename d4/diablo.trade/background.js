class Main {
  init() {
    console.log("start");

    chrome.action.onClicked.addListener(this.browserActionClicked);
  }

  browserActionClicked(tab) {
    console.log("clicked");

    chrome.scripting
      .executeScript({
        target: { tabId: tab.id },
        files: ["./scripts.js"],
      })
      .then(() => console.log("script injected"));
  }
}

const main = new Main();
main.init();
