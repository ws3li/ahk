let API_EQUIPMENT = "chestarmor"; // helm, boots, chestarmor, amulet
let API_RARITY = "legendary";

let AFFIX_1 = "essence";
let AFFIX_1_GA = false;
let AFFIX_2 = "maximum life";

let AFFIX_2_GA = false;

let BATCH_NUMBER = 1; // start at 1
let PAGE_START = BATCH_NUMBER === 0 ? 1 : (BATCH_NUMBER - 1) * 100 + 1;
let PAGE_END = BATCH_NUMBER === 0 ? 2 : BATCH_NUMBER * 100;

let API_START = "https://diablo.trade/api/items/search?cursor=";
let API_END = `&equipment=${API_EQUIPMENT}&mode=season%20softcore&rarity=${API_RARITY}`;

let loopIndex = 0;

function lookup() {
  const types = [
    { equipment: "chestarmor", affix_1: "essence", affix_2: "maximum life" },
    { equipment: "chestarmor", affix_1: "essence", affix_2: "armor" },
    { equipment: "helm", affix_1: "essence", affix_2: "armor" },
    { equipment: "helm", affix_1: "essence", affix_2: "maximum life" },
    { equipment: "boots", affix_1: "essence", affix_2: "movement speed" },
    { equipment: "amulet", affix_1: "blood", affix_2: "blood" },
  ];

  if (loopIndex >= types.length) {
    loopIndex = 0;
    setTimeout(() => lookup(), 60000);
  }

  const t = types[loopIndex];

  BATCH_NUMBER = 0;
  API_EQUIPMENT = t.equipment;
  AFFIX_1 = t.affix_1;
  AFFIX_2 = t.affix_2;

  start();

  loopIndex += 1;
  setTimeout(() => lookup(), 3000);
}

async function start() {
  const initialData = await getAPIData(1);
  const maxCount = initialData.json.total / 20;
  console.log("Max page:", maxCount);

  const promises = [];
  for (let i = PAGE_START; i < PAGE_END && i < maxCount; i++) {
    promises.push(getAPIData(i));
  }

  const allData = await Promise.all(promises);
  let collected = [];
  allData.forEach((iData) => {
    collected = collected.concat(getDetails(iData));
  });

  const filt = collected.filter((cData) => {
    const af1 = AFFIX_1;
    const af1GA = AFFIX_1_GA;
    const af2 = AFFIX_2;
    const af2GA = AFFIX_2_GA;

    let found = 0;
    if (cData.name1.toLowerCase().includes(af1)) {
      if (af1GA) {
        if (cData.isGreater1) found++;
      } else {
        found++;
      }
    }

    if (cData.name2.toLowerCase().includes(af1)) {
      if (af1GA) {
        if (cData.isGreater2) found++;
      } else {
        found++;
      }
    }

    if (cData.name3.toLowerCase().includes(af1)) {
      if (af1GA) {
        if (cData.isGreater3) found++;
      } else {
        found++;
      }
    }

    if (cData.name1.toLowerCase().includes(af2)) {
      if (af2GA) {
        if (cData.isGreater1) found++;
      } else {
        found++;
      }
    }

    if (cData.name2.toLowerCase().includes(af2)) {
      if (af2GA) {
        if (cData.isGreater2) found++;
      } else {
        found++;
      }
    }

    if (cData.name3.toLowerCase().includes(af2)) {
      if (af2GA) {
        if (cData.isGreater3) found++;
      } else {
        found++;
      }
    }

    return found === 2;
  });

  display(filt);
}

function getDetails(data) {
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
        price: it.price,
        exactPrice: it.exactPrice,
        link: `https://diablo.trade/listings/items/${it._id}`,
      };

      items.push(newitem);
    } catch {}
  });

  return items;
}

async function getAPIData(page) {
  const response = await fetch(`${API_START}${page}${API_END}`, {
    mode: "no-cors",
  });
  const json = await response.json();
  return { json, page };
}

function display(alldata) {
  if (alldata.length <= 0) {
    console.log("nothing found");
    return;
  }

  alldata = alldata
    .sort((x, y) => Number(x.online) - Number(y.online))
    .reverse();
  alldata.forEach((data) => {
    const orange = "color: #ea982c";
    const black = "color: black";

    const template = `----------------------------------------------------------------------------------------------
        online: ${data.online}
        price: ${data.price}
        user: ${data.userId}
        createdAt: ${data.createdAt}

        ${data.ga1 ? "☆" : "  "} ${data.name1.replace("# ", "")} ${data.value1}
        ${data.ga2 ? "☆" : "  "} ${data.name2.replace("# ", "")} ${data.value2}
        ${data.ga3 ? "☆" : "  "} ${data.name3.replace("# ", "")} ${data.value3}
        `;

    console.log(template);
    console.log(`\t `, data.link);
  });
}

start();
