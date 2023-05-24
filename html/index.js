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
            $(".billing").show();
        }
        if (data.type === "closebilling") {
            $(".billing").hide();
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