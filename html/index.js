let invoices = [];
$(function() {
    // Hide Div //
$('.container').hide();
$('.billing').hide();

    window.addEventListener("message", function(event) {
        let data = event.data; 

        if (data.type === "openui") {
            $('.container').show();
        }

        if (data.type === "closeui") {
            $(".container").hide();
        }
        if (data.type === "openbilling") {
            invoices = data.bills
            setInvoices()
            $(".billing").show();
        }
        if (data.type === "closebilling") {
            $(".billing").hide();
            removeAllChildNodes(document.getElementById("customul"))
        }

    })
})

document.getElementById('submitbtn').addEventListener('click', () => {

    let name = document.getElementById('name').value
    let id = document.getElementById('id').value
    let amount = document.getElementById('amount').value
    let desc = document.getElementById('desc').value

    // Hide Div // 
    $('.container').hide();

    // Release Focus //
    axios.post(`https://${GetParentResourceName()}/sbmtbtn`, {name,id,amount,desc});

})

// Billing UI //
// Array of Invoice
// let invoices = [
//     {
//       name: "Invoice 1",
//       price: 200,
//       item: "beer",
//     },
//     {
//       name: "Invoice 2",
//       price: 350,
//       item: "vodka",
//     },
//     {
//       name: "Invoice 3",
//       price: 200,
//       item: "henny",
//     },
//     {
//       name: "Invoice 4",
//       price: 400,
//       item: "whiskey",
//     },
//   ];
  
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
    let paybtntext = document.createTextNode("$"+item.amount);
    paybutton.appendChild(paybtntext);
    paybutton.setAttribute("id", "paybutton");
    paybutton.style.color = "red";
  
    // Pay Button OnClick
    paybutton.addEventListener("click", () => {
      document.getElementById("customul").removeChild(paybutton)
      document.getElementById("customul").removeChild(infobutton)
      PayBill(item.citizenid,item.amount,item.description);
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
    let popuptext = document.createTextNode("Heading");
    popup.appendChild(popuptext);
    popup.setAttribute("id", "popup");
    popup.hidden = true;
  
    // Pop-Up Close Button
    let closeinfo = document.createElement("button");
    let btntext = document.createTextNode("Close");
    closeinfo.appendChild(btntext);
    closeinfo.setAttribute("id", "infoclose");
  
    // Add Close Button
    popup.appendChild(closeinfo);
  
    // Functions
    function PayBill(id,price,desc) {
      // Trigger Pay Bill Event?
      console.log(`Charging ${price} to customer!`);
      axios.post(`https://${GetParentResourceName()}/paybill`, {id,price,desc});
    }
  
    function ShowInfo(item) {
      if (popupOpen === false) {
        popup.hidden = false;
        container.hidden = true;
        popupOpen = true;
        let newtext = document.createTextNode(item);
        popup.replaceChild(newtext,popuptext);
      } else {
        popup.hidden = true;
        container.hidden = false;
      }
      console.log(`${item} was sold`);
    }
  
    // Pop-Up Close Button Handler
    closeinfo.addEventListener("click", () => {
      popup.hidden = true;
      container.hidden = false;
      popupOpen = false;
    });
  
    document.getElementById("customul").appendChild(charge);
    document.getElementById("customul").appendChild(paybutton);
    document.getElementById("customul").appendChild(infobutton);
    document.getElementById("listcontainer").appendChild(popup);
  });
  }
  
  // Main-UI Close Button Handler
  document.getElementById("mainclose").addEventListener("click", () => {
    $(".billing").hide();
    removeAllChildNodes(document.getElementById("customul"))
    axios.post(`https://${GetParentResourceName()}/closeui`, {});
  });