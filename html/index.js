let invoices = [];
$(function () {
  // Hide Div //
  $(".container").hide();
  $(".billing").hide();

  window.addEventListener("message", function (event) {
    let data = event.data;

    if (data.type === "openui") {
      $(".container").show();
    }

    if (data.type === "closeui") {
      $(".container").hide();
    }
    if (data.type === "openbilling") {
      invoices = data.bills;
      setInvoices(invoices);
      $(".billing").show();
    }
    if (data.type === "closebilling") {
      $(".billing").hide();
      removeAllChildNodes(document.getElementById("customul"));
    }
  });
});

document.getElementById("submitbtn").addEventListener("click", () => {
  let name = document.getElementById("name").value;
  let id = document.getElementById("id").value;
  let amount = document.getElementById("amount").value;
  let desc = document.getElementById("desc").value;

  // Hide Div //
  $(".container").hide();

  // Release Focus //
  axios.post(`https://${GetParentResourceName()}/sbmtbtn`, {
    name,
    id,
    amount,
    desc,
  });
});

// Billing UI //
let br = document.createElement("br");
let br2 = document.createElement("br");
let popupOpen = false;
let container = document.getElementById("customul");

function removeAllChildNodes(parent) {
  while (parent.firstChild) {
    parent.removeChild(parent.firstChild);
  }
}
function setInvoices() {
  // Create Items
  invoices.forEach(function (item) {
    // Charge Text
    let charge = document.createElement("li");
    // let chargetext = document.createTextNode(`${item.citizenid}`);
    // charge.appendChild(chargetext);

    // Pay Button Text
    let paybutton = document.createElement("button");
    let paybtntext = document.createTextNode("Pay");
    paybutton.appendChild(paybtntext);
    paybutton.setAttribute("id", "paybutton");

    // Yes Button
    let yesbutton = document.createElement("button");
    let yesbtntext = document.createTextNode("Yes!");
    yesbutton.appendChild(yesbtntext);
    yesbutton.setAttribute("id", "yesbutton");

    // No Button
    let nobutton = document.createElement("button");
    let nobtntext = document.createTextNode("No?");
    nobutton.appendChild(nobtntext);
    nobutton.setAttribute("id", "nobutton");

    // Set Display to None
    yesbutton.style.display = "none";
    nobutton.style.display = "none";

    // Pay Button OnClick
    paybutton.addEventListener("click", () => {
        customul.style.display = "none";
        paybutton.style.display = "none";
        infobutton.style.display = "none";
        yesbutton.style.display = "block";
        nobutton.style.display = "block";
        yesbutton.style.marginLeft = 'auto';
        yesbutton.style.marginRight = '100px';
        nobutton.style.marginLeft = 'auto';
        nobutton.style.marginRight = '101px';
    });
      
  yesbutton.addEventListener('click', () => {
    CheckAccount(item.amount,item.citizenid,item.description)
  });
  
nobutton.addEventListener("click", () => {
    customul.style.display = "block";
  paybutton.style.display = "inline-block";
  infobutton.style.display = "inline-block";
  nobutton.style.display = "none";
  yesbutton.style.display = "none";
  $('.billing').hide();
  $('.billing').show();
});

    // Info Button Text
    let infobutton = document.createElement("button");
    infobutton.setAttribute("id", "infobutton");
    let infobuttontxt = document.createTextNode("Information");
    infobutton.appendChild(infobuttontxt);

    infobutton.addEventListener("click", () => {
      ShowInfo(item.description);
    });

    // Information Pop-Up
    // Main Pop-Up
    let popup = document.createElement("div");
    popup.setAttribute("id", "popup");
    popup.hidden = true;

    // Pop-Up Heading
    let infodivhead = document.createElement("h1");
    let infodivtxt = document.createTextNode(`Invoice`);
    infodivhead.appendChild(infodivtxt);

    // Amount Information
    let amountelement = document.createElement("h3");
    let amounttext = document.createTextNode(`Amount: $${item.amount}`);
    amountelement.appendChild(amounttext);

    // Item Information
    let itemelement = document.createElement("h3");
    let itemtext = document.createTextNode(`Item: ${item.description}`);
    itemelement.appendChild(itemtext);

    // Attach it to Pop-Up
    popup.appendChild(infodivhead);
    popup.appendChild(amountelement);
    popup.appendChild(itemelement);

    // Pop-Up Close Button
    let closeinfo = document.createElement("button");
    let btntext = document.createTextNode("Close");
    closeinfo.appendChild(btntext);
    closeinfo.setAttribute("id", "infoclose");

    // Add Close Button
    popup.appendChild(closeinfo);

    // Functions
    function PayBill(id, price, desc) {
      // Trigger Pay Bill Event?
      console.log(`Charging ${price} to customer!`);
      axios.post(`https://${GetParentResourceName()}/paybill`, {
        id,
        price,
        desc,
      });
    }
      
   function CheckAccount(cost,id,desc) {
    console.log(cost,id,desc)
      axios.post(`https://${GetParentResourceName()}/checkaccount`, {cost})
      .then((response) => {
          let data = response.data;
          let result = data[0];
          if (result) {
            PayBill(id, cost, desc);
            yesbutton.style.display = 'none';
            nobutton.style.display = 'none';
          } else {
            yesbutton.classList.add('shake');
            yesbutton.classList.add('red-button');
            yesbutton.classList.add('red-button:hover');
        
            // Remove the red-button class after a certain duration
            setTimeout(() => {
              yesbutton.classList.remove('red-button');
              yesbutton.classList.remove('shake');
            }, 800); // Adjust the duration (in milliseconds) as needed
          }    
      })
      .catch((error) => {
          console.log(error);
      });
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
    }

    // Pop-Up Close Button Handler
    closeinfo.addEventListener("click", () => {
      popup.hidden = true;
      container.hidden = false;
      popupOpen = false;
    });

    document.getElementById("customul").appendChild(charge);
    document.getElementById("customul").appendChild(paybutton);
    document.getElementById("customul").appendChild(yesbutton);
    document.getElementById("customul").appendChild(nobutton);
    document.getElementById("customul").appendChild(infobutton);
    document.getElementById("listcontainer").appendChild(popup);
  });
}

// Close Button Handlers
document.getElementById("invoiceclose").addEventListener("click", () => {
  $(".container").hide();
  axios.post(`https://${GetParentResourceName()}/closeui`, {});
});

document.getElementById("billingclose").addEventListener("click", () => {
  $(".billing").hide();
  removeAllChildNodes(document.getElementById("customul"));
  axios.post(`https://${GetParentResourceName()}/closeui`, {});
});
