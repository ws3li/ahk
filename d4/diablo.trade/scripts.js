class PageScript {
  constructor() {
    this.timer = null;

    this.bulkIndex = 1;
    this.bulkFilteredData = [];
  }

  async start() {
    await this.injectPage();
    this.runCode();
  }

  async injectPage() {
    const response = await fetch(chrome.runtime.getURL("page.html"));
    const pageText = await response.text();

    const parser = new DOMParser();
    const dom = parser.parseFromString(pageText, "text/html");

    let content = dom.querySelector("#d4-trade-main");
    document.getElementsByTagName("html")[0].appendChild(content);
  }

  async runCode() {
    document.getElementById("submit").addEventListener("click", () => {
      DisplayHelper.clearDisplay();
      this.handleForm();
    });

    document.getElementById("bulk").addEventListener("click", () => {
      DisplayHelper.clearDisplay();
      this.handleBulk();
    });

    document.getElementById("add").addEventListener("click", () => {
      this.handleAdd();
    });

    document.getElementById("monitor").addEventListener("click", () => {
      clearInterval(this.timer);
      DisplayHelper.clearDisplay();
      this.handleMonitor();
    });

    document.getElementById("stopmonitor").addEventListener("click", () => {
      clearInterval(this.timer);
      DisplayHelper.clearDisplay();
    });

    document.getElementById("clear").addEventListener("click", () => {
      this.handleClearCache();
    });

    // show monitor items
    let recordedData =
      (await chrome.storage.local.get(["MONITOR"]))["MONITOR"] || [];
    DisplayHelper.displayMonitor(recordedData);
  }

  handleClearCache() {
    DisplayHelper.output("clear cache");
    chrome.storage.local.set({ SAVED: [] });
  }

  async handleMonitor() {
    DisplayHelper.output("monitor");

    let monitorData =
      (await chrome.storage.local.get(["MONITOR"]))["MONITOR"] || [];

    if (monitorData.length <= 0) {
      DisplayHelper.output("nothing to monitor");
      return;
    }

    let collected = [];
    const promises = [];
    monitorData.forEach((record) => {
      const apiRequest = new APIRequest(
        1,
        2,
        record.equipment,
        record.af1,
        record.af2
      );
      promises.push(apiRequest.getData());
    });

    const response = await Promise.all(promises);
    if (!response) {
      DisplayHelper.output(
        "something went wrong. retrying 'handleMonitor' in 5 seconds."
      );
      setTimeout(() => this.handleMonitor(), 5000);
      return;
    }

    response.forEach((r) => {
      collected = collected.concat(r);
    });

    // get only new data (match with save)
    let savedData = (await chrome.storage.local.get(["SAVED"]))["SAVED"] || [];
    const newData = [];
    for (let i = 0; i < collected.length; i++) {
      const cData = collected[i];
      let foundinDB = false;

      for (let j = 0; j < savedData.length; j++) {
        const sData = savedData[j];
        if (cData.id === sData.id) {
          foundinDB = true;
          break;
        }
      }

      if (!foundinDB) {
        newData.push(cData);
      }
    }

    if (newData.length === 0) {
      this.timer = setTimeout(() => this.handleMonitor(), 60000);
      DisplayHelper.output("nothing found");
      return;
    }

    // save new data and display
    chrome.storage.local.set({ SAVED: [...savedData, ...newData] });
    DisplayHelper.display(newData);
    this.timer = setTimeout(() => this.handleMonitor(), 60000);
  }

  async handleBulk() {
    DisplayHelper.output(`form bulk search: ${this.bulkIndex}/6`);

    if (this.bulkIndex <= 5) {
      const pagestart = 100 * (this.bulkIndex - 1) + 1;
      const pageend = 100 * this.bulkIndex;

      const data = await this.handleForm(pagestart, pageend);
      this.bulkFilteredData = this.bulkFilteredData.concat(data);
      this.bulkIndex += 1;
      setTimeout(() => this.handleBulk(), 15000);
    } else {
      DisplayHelper.display(this.bulkFilteredData);
      this.bulkFilteredData = [];
      this.bulkIndex = 1;
    }
  }

  async handleForm(ps, pe) {
    DisplayHelper.output("form search");

    const pagesEv = document.getElementById("pages");
    const pages = pagesEv.options[pagesEv.selectedIndex].value;
    const [pageStart, pageEnd] = pages.split("-");

    const equipmentEv = document.getElementById("equipment");
    const equipment = equipmentEv.options[equipmentEv.selectedIndex].value;

    const af1Ev = document.getElementById("aff1");
    const af1 = af1Ev.options[af1Ev.selectedIndex].value;

    const af2Ev = document.getElementById("aff2");
    const af2 = af2Ev.options[af2Ev.selectedIndex].value;

    const aff1ga = document.getElementById("aff1_check").checked;
    const aff2ga = document.getElementById("aff2_check").checked;

    const apiRequest = new APIRequest(
      ps || pageStart,
      pe || pageEnd,
      equipment,
      af1,
      af2,
      aff1ga,
      aff2ga
    );
    const filteredData = await apiRequest.getData();
    if (!filteredData) {
      DisplayHelper.output(
        "something went wrong. retrying 'handleForm' in 5 seconds."
      );
      setTimeout(() => this.handleForm(), 5000);
      return;
    }

    if (ps && pe) {
      return filteredData;
    } else {
      DisplayHelper.display(filteredData);
    }
  }

  async handleAdd() {
    DisplayHelper.output("add");

    const equipmentEv = document.getElementById("equipment");
    const equipment = equipmentEv.options[equipmentEv.selectedIndex].value;

    const af1Ev = document.getElementById("aff1");
    const af1 = af1Ev.options[af1Ev.selectedIndex].value;

    const af2Ev = document.getElementById("aff2");
    const af2 = af2Ev.options[af2Ev.selectedIndex].value;

    const data = { equipment, af1, af2, id: DisplayHelper.uuid() };
    const recordedData =
      (await chrome.storage.local.get(["MONITOR"]))["MONITOR"] || [];
    const newdata = [...recordedData, data];
    chrome.storage.local.set({ MONITOR: newdata });

    DisplayHelper.displayMonitor(newdata);
  }
}

class APIRequest {
  constructor(pageStart, pageEnd, equipment, af1, af2, aff1ga, aff2ga) {
    this.API_EQUIPMENT = equipment;
    this.AFFIX_1 = af1.toLowerCase();
    this.AFFIX_2 = af2.toLowerCase();

    this.PAGE_START = Number(pageStart);
    this.PAGE_END = Number(pageEnd);

    this.API_RARITY = "legendary";
    this.AFFIX_1_GA = aff1ga || false;
    this.AFFIX_2_GA = aff2ga || false;

    this.API_START = "https://diablo.trade/api/items/search?cursor=";
    this.API_END = `&equipment=${this.API_EQUIPMENT}&mode=season%20softcore&rarity=${this.API_RARITY}`;
  }

  async getData() {
    const initialData = await this.getAPIData(1);
    if (!initialData) {
      return null;
    }

    const maxPageCount = initialData.json.total / 20;
    DisplayHelper.output("Max page:", maxPageCount);

    // call once to get the page count
    const promises = [];

    for (let i = this.PAGE_START; i < this.PAGE_END && i < maxPageCount; i++) {
      promises.push(this.getAPIData(i));
    }

    // get all pages
    const allData = await Promise.all(promises);
    let collected = [];
    allData.forEach((iData) => {
      if (iData) {
        collected = collected.concat(this.getDetails(iData));
      }
    });

    return this.filterByAffixes(collected);
  }

  filterByAffixes(collected) {
    const filtered = collected.filter((cData) => {
      const af1 = this.AFFIX_1;
      const af1GA = this.AFFIX_1_GA;
      const af2 = this.AFFIX_2;
      const af2GA = this.AFFIX_2_GA;

      let found = 0;
      if (cData.name1.toLowerCase().includes(af1)) {
        if (af1GA) {
          if (cData.ga1) found++;
        } else {
          found++;
        }
      }

      if (cData.name2.toLowerCase().includes(af1)) {
        if (af1GA) {
          if (cData.ga2) found++;
        } else {
          found++;
        }
      }

      if (cData.name3.toLowerCase().includes(af1)) {
        if (af1GA) {
          if (cData.ga3) found++;
        } else {
          found++;
        }
      }

      if (cData.name1.toLowerCase().includes(af2)) {
        if (af2GA) {
          if (cData.ga1) found++;
        } else {
          found++;
        }
      }

      if (cData.name2.toLowerCase().includes(af2)) {
        if (af2GA) {
          if (cData.ga2) found++;
        } else {
          found++;
        }
      }

      if (cData.name3.toLowerCase().includes(af2)) {
        if (af2GA) {
          if (cData.ga3) found++;
        } else {
          found++;
        }
      }

      return found === 2;
    });

    return filtered;
  }

  async getAPIData(page) {
    try {
      const response = await fetch(`${this.API_START}${page}${this.API_END}`);
      const json = await response.json();
      return { json, page };
    } catch (err) {
      DisplayHelper.output("fetch error", err);
      return null;
    }
  }

  getDetails(data) {
    const items = [];
    data.json.data.forEach((it) => {
      try {
        const newitem = {
          name1: it.affixes[0].name,
          name2: it.affixes[1].name,
          name3: it.affixes[2].name,

          value1: it.affixes[0].value,
          value2: it.affixes[1].value,
          value3: it.affixes[2].value,

          ga1: it.affixes[0].isGreater,
          ga2: it.affixes[1].isGreater,
          ga3: it.affixes[2].isGreater,

          createdAt: new Date(it.createdAt).toLocaleString(),
          page: data.page,
          userId: it.userId.name,
          online: it.userId.online,
          price: it.price ? DisplayHelper.numberWithCommas(it.price) : it.price,
          exactPrice: it.exactPrice,
          link: `https://diablo.trade/listings/items/${it._id}`,
          id: it._id,
          itemType: it.itemType,
        };

        items.push(newitem);
      } catch {}
    });

    return items;
  }
}

class DisplayHelper {
  static numberWithCommas(x) {
    if (isNaN(x)) return x;
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }

  static uuid() {
    return "10000000-1000-4000-8000-100000000000".replace(/[018]/g, (c) =>
      (
        +c ^
        (crypto.getRandomValues(new Uint8Array(1))[0] & (15 >> (+c / 4)))
      ).toString(16)
    );
  }

  static output(msg, data) {
    if (!data) {
      const note = document.getElementById("note");
      const textNode = document.createElement("div");

      const date = new Date();
      textNode.innerHTML = `[${date.toLocaleString()}]: ${msg}`;
      note.prepend(textNode);
    }

    console.log(msg, data);
  }

  static createElementFromHTML(htmlString) {
    var div = document.createElement("div");
    div.innerHTML = htmlString.trim();

    // Change this to div.childNodes to support multiple top-level nodes.
    return div.firstChild;
  }

  static displayMonitor(data) {
    const trademonitorcontainer = document.getElementById("trademonitor");
    trademonitorcontainer.innerHTML = "";

    data.forEach((d) => {
      const field = `
      <div style="cursor: not-allowed; border: 1px solid black; border-radius: 8px; padding: 5px; margin: 3px;">
        eq: ${d.equipment}, af1: ${d.af1}, af2: ${d.af2}
      </div>
    `;

      const el = DisplayHelper.createElementFromHTML(field);
      el.addEventListener("click", async () => {
        let recordedData =
          (await chrome.storage.local.get(["MONITOR"]))["MONITOR"] || [];
        recordedData = recordedData.filter((fd) => fd.id !== d.id);
        chrome.storage.local.set({ MONITOR: recordedData });

        DisplayHelper.displayMonitor(recordedData);
      });
      trademonitorcontainer.appendChild(el);
    });
  }

  static display(alldata) {
    const responseContainer = document.getElementById("responsecontainer");

    alldata = alldata.sort((x, y) => Number(x.online) - Number(y.online));
    alldata.forEach((data) => {
      const card = `
        <div style="display: flex; flex-direction: column; padding: 12px; border: 1px solid black; margin: 5px; border-radius: 12px; width: 350px; height: 250px; cursor: pointer">
          <div style="display: flex; flex-direction: row">
            ${
              data.online
                ? "<div style='color: green'>online</div>"
                : "<div style='color: red'>offline</div>"
            }
          </div>
          <div style="display: flex; flex-direction: row">
            price: ${data.price}
          </div>
          <div style="display: flex; flex-direction: row">
            user: ${data.userId}
          </div>
          <div style="display: flex; flex-direction: row">
            created at: ${data.createdAt}
          </div>
          <div style="display: flex; flex-direction: row">
            item type: ${data.itemType}
          </div>
          <br>
          <div style="display: flex; flex-direction: row; ${
            data.ga1 ? "font-weight: bold" : ""
          }">
            ${data.ga1 ? "☆" : "  "} ${data.name1.replace("# ", "")} ${
        data.value1
      }
          </div>
          <div style="display: flex; flex-direction: row; ${
            data.ga2 ? "font-weight: bold" : ""
          }">
             ${data.ga2 ? "☆" : "  "} ${data.name2.replace("# ", "")} ${
        data.value2
      }
          </div>
          <div style="display: flex; flex-direction: row; ${
            data.ga3 ? "font-weight: bold" : ""
          }">
             ${data.ga3 ? "☆" : "  "} ${data.name3.replace("# ", "")} ${
        data.value3
      }
          </div>
        </div>
      `;

      const cardElement = DisplayHelper.createElementFromHTML(card);
      cardElement.addEventListener("click", () =>
        window.open(data.link, "_blank").focus()
      );
      responseContainer.prepend(cardElement);
    });

    DisplayHelper.beep();
    DisplayHelper.output("req complete");
  }

  static clearDisplay() {
    const responseContainer = document.getElementById("responsecontainer");
    responseContainer.innerHTML = "";
  }

  static beep() {
    const snd = new Audio(
      "https://cdn.uppbeat.io/audio-files/550fafd5d5403a2f6e11b6feefd0899e/5813248995dfa6aca7fce524188eb5d7/d5b64c2af9644f381f878b6041cfaf56/STREAMING-pop-up-bubble-gfx-sounds-1-00-00.mp3"
    );
    snd.volume = 0.2;
    snd.play();
  }
}

const pageScript = new PageScript();
pageScript.start();
