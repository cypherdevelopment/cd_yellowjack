$(function() {
    // Hide Div //
    $('.container').hide();

    window.addEventListener("message", function(event) {
        let data = event.data; 

        if (data.type === "openui") {
            $('.container').show();
        }

        if (data.type === "closeui") {
            $(".container").hide();
        }

    })
})

document.getElementById('submitbtn').addEventListener('click', () => {
    // Hide Div // 
    $('.container').hide();

    // Release Focus //
    axios.post(`https://${GetParentResourceName()}/cancelbtn`, {});

})