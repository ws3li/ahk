class PageScript {
  constructor() {
    this.timer = null;

    this.bulkIndex = 1;
    this.bulkFilteredData = [];
    this.shadowRoot = null;

    this.dh = null;
  }

  async start() {
    await this.injectPage();
    this.runCode();
  }

  async injectPage() {
    const response = await fetch(chrome.runtime.getURL("page.html"));
    const pageText = await response.text();

    const divElement = document.createElement("div");
    this.shadowRoot = divElement.attachShadow({ mode: 'closed' });
    this.shadowRoot.innerHTML = pageText;
    this.dh = new DisplayHelper(this.shadowRoot);

    const pageHtml = document.getElementsByTagName("html")[0];
    pageHtml.innerHTML = '';
    pageHtml.appendChild(divElement);
  }

  async runCode() {
    this.shadowRoot.getElementById("submit").addEventListener("click", () => {
      this.dh.clearDisplay();
      this.handleForm();
    });

    this.shadowRoot.getElementById("bulk").addEventListener("click", () => {
      this.dh.clearDisplay();
      this.handleBulk();
    });

    this.shadowRoot.getElementById("add").addEventListener("click", () => {
      this.handleAdd();
    });

    this.shadowRoot.getElementById("monitor").addEventListener("click", () => {
      clearInterval(this.timer);
      this.dh.clearDisplay();
      this.handleMonitor();
    });

    this.shadowRoot.getElementById("stopmonitor").addEventListener("click", () => {
      clearInterval(this.timer);
      this.dh.clearDisplay();
    });

    this.shadowRoot.getElementById("clear").addEventListener("click", () => {
      this.handleClearCache();
    });

    // show monitor items
    let recordedData =
      (await chrome.storage.local.get(["MONITOR"]))["MONITOR"] || [];
      this.dh.displayMonitor(recordedData);
  }

  handleClearCache() {
    this.dh.output("clear cache");
    chrome.storage.local.set({ SAVED: [] });
  }

  async handleMonitor() {
    this.dh.output("monitor");

    let monitorData =
      (await chrome.storage.local.get(["MONITOR"]))["MONITOR"] || [];

    if (monitorData.length <= 0) {
      this.dh.output("nothing to monitor");
      return;
    }

    let collected = [];
    const promises = [];
    monitorData.forEach((record) => {
      const apiRequest = new APIRequest(record.searchterm, this.dh);
      promises.push(apiRequest.getData());
    });

    const response = await Promise.all(promises);
    if (!response) {
      this.dh.output(
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
      this.dh.output("nothing found");
      return;
    }

    // save new data and display
    chrome.storage.local.set({ SAVED: [...savedData, ...newData] });
    this.dh.display(newData);
    this.timer = setTimeout(() => this.handleMonitor(), 60000);
  }

  async handleBulk() {
    this.dh.output(`form bulk search: ${this.bulkIndex}/6`);

    if (this.bulkIndex <= 5) {
      const data = await this.handleForm(true);
      this.bulkFilteredData = this.bulkFilteredData.concat(data);
      this.bulkIndex += 1;
      setTimeout(() => this.handleBulk(), 15000);
    } else {
      this.dh.display(this.bulkFilteredData);
      this.bulkFilteredData = [];
      this.bulkIndex = 1;
    }
  }

  async handleForm(bulk) {
    this.dh.output("form search");

    const searchterm = this.shadowRoot.getElementById("searchterm").value;
    const apiRequest = new APIRequest(searchterm.replaceAll(" ", "+"), this.dh);
    const data = await apiRequest.getData();
    if (!data) {
      this.dh.output(
        "something went wrong. retrying 'handleForm' in 5 seconds."
      );
      setTimeout(() => this.handleForm(), 5000);
      return;
    }

    if (bulk) {
      return data;
    } else {
      this.dh.display(data);
    }
  }

  async handleAdd() {
    this.dh.output("add");

    const uiterm = this.shadowRoot.getElementById("searchterm").value;
    const data = { uiterm, searchterm: uiterm.replaceAll(" ", "+"), id: this.dh.uuid() };
    const recordedData =
      (await chrome.storage.local.get(["MONITOR"]))["MONITOR"] || [];
    const newdata = [...recordedData, data];
    chrome.storage.local.set({ MONITOR: newdata });

    this.dh.displayMonitor(newdata);
  }
}

class APIRequest {
  constructor(searchterm, dh) {
    this.SEARCH_TERM = searchterm;
    this.API_START = "https://www.thecrimsonmarket.com/mana/diablo4/listing?search=";
    this.API_END = `${this.SEARCH_TERM}&realm=season&mode=softcore&page=0&pageSize=50&priceValues[]=0&priceValues[]=100&itemPowerValues[]=0&itemPowerValues[]=925&itemLevelValues[]=0&itemLevelValues[]=100&minItemPower=&maxItemPower=&minItemLevel=&maxItemLevel=&minItemPrice=&maxItemPrice=&itemType=any&itemRarity=any&itemClass=any&onlineOnly=all+users&itemTier=any&gaSort=&priceSort=`;

    this.dh = dh;
  }

  async getData() {
    const initialData = await this.getAPIData();
    if (!initialData) {
      return null;
    }

    let collected = [];
    collected = collected.concat(this.getDetails(initialData));
    return collected;
  }

  async getAPIData() {
    try {
      const response = await fetch(`${this.API_START}${this.API_END}`);
      const json = await response.json();
      return json;
    } catch (err) {
      this.dh.output("fetch error", err);
      return null;
    }
  }

  getDetails(data) {
    const items = [];
    data.listings.forEach((it) => {
      try {
        const newitem = {
          createdAt: new Date(it.createdAt).toLocaleString(),
          updatedAt: new Date(it.updatedAt).toLocaleString(),
          elapsed: new Date() - new Date(it.createdAt),
          page: data.currentPage,
          userId: it.ownerUserName,
          online: it.onlineState,
          price: it.price ? this.dh.numberWithCommas(it.price) : it.price,
          img: `https://www.thecrimsonmarket.com/mana/image/${it.images[0]}`,
          link: `https://www.thecrimsonmarket.com/conversation/${it._id}`,
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
  constructor(shadowRoot)
  {
    this.shadowRoot = shadowRoot;
  }

  numberWithCommas(x) {
    if (isNaN(x)) return x;
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }

  uuid() {
    return "10000000-1000-4000-8000-100000000000".replace(/[018]/g, (c) =>
      (
        +c ^
        (crypto.getRandomValues(new Uint8Array(1))[0] & (15 >> (+c / 4)))
      ).toString(16)
    );
  }

  output(msg, data) {
    if (!data) {
      const note = this.shadowRoot.getElementById("note");
      const textNode = document.createElement("div");

      const date = new Date();
      textNode.innerHTML = `[${date.toLocaleString()}]: ${msg}`;
      note.prepend(textNode);
    }

    console.log(msg, data);
  }

  createElementFromHTML(htmlString) {
    var div = document.createElement("div");
    div.innerHTML = htmlString.trim();

    // Change this to div.childNodes to support multiple top-level nodes.
    return div.firstChild;
  }

  displayMonitor(data) {
    const trademonitorcontainer = this.shadowRoot.getElementById("trademonitor");
    trademonitorcontainer.innerHTML = "";

    data.forEach((d) => {
      const field = `
      <div style="border: 1px solid black; border-radius: 8px; padding: 5px; margin: 3px; display:flex">
      </div>
    `;
      const el = this.createElementFromHTML(field);

      const termElement = this.createElementFromHTML(`<div style="cursor: pointer">term: ${d.uiterm}</div>`);
      termElement.addEventListener("click", async () => {
        navigator.clipboard.writeText(d.uiterm);
      });

      const xElement = this.createElementFromHTML('<div style="cursor: not-allowed; width:20px; height 20px; color: red"> X </div>');
      xElement.addEventListener("click", async () => {
        let recordedData =
          (await chrome.storage.local.get(["MONITOR"]))["MONITOR"] || [];
        recordedData = recordedData.filter((fd) => fd.id !== d.id);
        chrome.storage.local.set({ MONITOR: recordedData });

        this.displayMonitor(recordedData);
      });

      el.appendChild(xElement);
      el.appendChild(termElement);

      trademonitorcontainer.appendChild(el);
    });


  }

  display(alldata) {
    const responseContainer = this.shadowRoot.getElementById("responsecontainer");

    alldata = alldata.sort((x, y) => Number(x.elapsed) - Number(y.elapsed));
    alldata.forEach((data) => {
      const card = `
        <div style="display: flex; flex-direction: column; padding: 12px; border: 1px solid black; margin: 5px; border-radius: 12px; width: 350px; cursor: pointer">
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
            elapsed: ${this.parseMillisecondsIntoReadableTime(data.elapsed)}
          </div>
          <div style="display: flex; flex-direction: row">
            user: ${data.userId}
          </div>
          <div style="display: flex; flex-direction: row">
            created at: ${data.createdAt}
          </div>
          <div style="display: flex; flex-direction: row">
            updated at: ${data.updatedAt}
          </div>
          <div style="display: flex; flex-direction: row">
            item type: ${data.itemType}
          </div>
          <br>
          <img style="object-fit: contain; height: 450px;" src="${data.img}" />
        </div>
      `;

      const cardElement = this.createElementFromHTML(card);
      cardElement.addEventListener("click", () =>
        window.open(data.link, "_blank").focus()
      );
      responseContainer.appendChild(cardElement);
    });

    this.beep();
    this.output("req complete");
  }

  clearDisplay() {
    const responseContainer = this.shadowRoot.getElementById("responsecontainer");
    responseContainer.innerHTML = "";
  }

  beep() {
    const snd = new Audio(
      "https://cdn.uppbeat.io/audio-files/550fafd5d5403a2f6e11b6feefd0899e/5813248995dfa6aca7fce524188eb5d7/d5b64c2af9644f381f878b6041cfaf56/STREAMING-pop-up-bubble-gfx-sounds-1-00-00.mp3"
    );
    snd.volume = 0.2;
    snd.play();
  }

  parseMillisecondsIntoReadableTime(milliseconds){
    //Get hours from milliseconds
    var hours = milliseconds / (1000*60*60);
    var absoluteHours = Math.floor(hours);
    var h = absoluteHours > 9 ? absoluteHours : '0' + absoluteHours;
  
    //Get remainder from hours and convert to minutes
    var minutes = (hours - absoluteHours) * 60;
    var absoluteMinutes = Math.floor(minutes);
    var m = absoluteMinutes > 9 ? absoluteMinutes : '0' +  absoluteMinutes;
  
    //Get remainder from minutes and convert to seconds
    var seconds = (minutes - absoluteMinutes) * 60;
    var absoluteSeconds = Math.floor(seconds);
    var s = absoluteSeconds > 9 ? absoluteSeconds : '0' + absoluteSeconds;
  
  
    return h + 'h : ' + m + 'm : ' + s + 's ';
  }
}

const pageScript = new PageScript();
pageScript.start();
