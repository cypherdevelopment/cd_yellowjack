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
  
    // Information Pop-Up
  
    // Main Pop-Up
    let popup = document.createElement("div");
    let popuptext = document.createTextNode("Heading");
    popup.appendChild(popuptext);
    popup.setAttribute("id", "popup");
    popup.hidden = true;
  
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
  
  $(function () {
    $("#billing-container").hide();
  
    window.addEventListener("message", function (event) {
      let data = event.data;
  
      if (data.type === "openbilling") {
        $("#billing-container").show();
      }
  
      if (data.type === "closebilling") {
        $("#billing-container").hide();
      }
    });
  });
  
  // Main-UI Close Button Handler
  document.getElementById("close").addEventListener("click", () => {
    $("#billing-container").hide();
    axios.post(`https://${GetParentResourceName()}/closeui`, {});
  });