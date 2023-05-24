// Billing UI //
// Array of Invoice
let invoices = [
  {
    name: "Invoice 1",
    price: 200,
    item: "beer",
  },
  {
    name: "Invoice 2",
    price: 350,
    item: "vodka",
  },
  {
    name: "Invoice 3",
    price: 200,
    item: "beer",
  },
  {
    name: "Invoice 4",
    price: 400,
    item: "whiskey",
  },
];

let popupOpen = false;
let container = document.getElementById("customul");

// Create Items
invoices.forEach(function (item) {
  // Charge Text
  let charge = document.createElement("li");
  let chargetext = document.createTextNode(`${item.name}`);
  charge.setAttribute("id", "listitem");
  charge.appendChild(chargetext);

  // Pay Button Text
  let paybutton = document.createElement("button");
  let paybtntext = document.createTextNode("Pay Bill");
  paybutton.appendChild(paybtntext);
  paybutton.setAttribute("id", "paybutton");

  // Pay Button OnClick
  paybutton.addEventListener("click", () => {
    PayBill(item.price);
  });

  // Info Button Text
  let infobutton = document.createElement("button");
  infobutton.setAttribute("id", "infobutton");
  let infobuttontxt = document.createTextNode("Information");
  infobutton.appendChild(infobuttontxt);

  infobutton.addEventListener("click", () => {
    ShowInfo(item.item);
  });

  // Line Break
  let br = document.createElement("br");
  let br2 = document.createElement("br");
  let br3 = document.createElement("br");
  let br4 = document.createElement("br");

  // Main Pop-Up
  let popup = document.createElement("div");
  popup.setAttribute("id", "popup");
  popup.hidden = true;

  // Pop-Up Heading
  let infodivhead = document.createElement("h1");
  let infodivtxt = document.createTextNode(`${item.name}`);
  infodivhead.appendChild(infodivtxt);

  // Amount Information
  let amountelement = document.createElement("h3");
  let amounttext = document.createTextNode(`Amount: $${item.price}`);
  amountelement.appendChild(amounttext);

  // Item Information
  let itemelement = document.createElement("h3");
  let itemtext = document.createTextNode(`Item: ${item.item}`);
  itemelement.appendChild(itemtext);

  // Attach it to Pop-Up
  popup.appendChild(infodivhead);
  popup.appendChild(amountelement);
  popup.appendChild(itemelement);

  // Pop-Up Close Button
  let closebutton = document.createElement("button");
  let btntext = document.createTextNode("Close");
  closebutton.appendChild(btntext);
  closebutton.setAttribute("id", "closebtn");

  // Add Close Button
  popup.appendChild(closebutton);

  // Functions
  function PayBill(price) {
    // Trigger Pay Bill Event?
    console.log(`Charging ${price} to customer!`);
  }

  function ShowInfo(item) {
    if (popupOpen === false) {
      popup.hidden = false;
      container.hidden = true;
      popupOpen = true;
    } else {
      popup.hidden = true;
      container.hidden = false;
    }
    console.log(`${item} was sold`);
  }

  // Pop-Up Close Button Handler
  closebutton.addEventListener("click", () => {
    popup.hidden = true;
    container.hidden = false;
    popupOpen = false;
  });

  document.getElementById("customul").appendChild(charge);
  document.getElementById("customul").appendChild(paybutton);
  document.getElementById("customul").appendChild(infobutton);
  document.getElementById("listcontainer").appendChild(popup);
});

// Main-UI Close Button Handler
document.getElementById("close").addEventListener("click", () => {
  $(".billing").hide();
  axios.post(`https://${GetParentResourceName()}/closeui`, {});
});
