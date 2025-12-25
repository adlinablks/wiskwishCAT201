document.addEventListener("DOMContentLoaded", function () {

    // --- Functions ---
    function selectTier(btn, tier) {
        setSelected(btn, 'tier-option');
        document.getElementById("tierInput").value = tier;
        updatePrice();
    }

    function selectSize(btn, size) {
        setSelected(btn, 'size-option');
        document.getElementById("sizeInput").value = size;
        updatePrice();
    }

    function selectFlavor(btn, flavor) {
        setSelected(btn, 'flavor-option');
        document.getElementById("flavorInput").value = flavor;
    }

    function setSelected(btn, className) {
        document.querySelectorAll('.' + className)
            .forEach(b => b.classList.remove('selected'));
        btn.classList.add('selected');
    }

    function changeQty(change) {
        let qtyInput = document.getElementById("quantity");
        let qty = parseInt(qtyInput.value) + change;

        if (qty < 1) qty = 1;
        if (qty > parseInt(qtyInput.max)) qty = parseInt(qtyInput.max);

        qtyInput.value = qty;
        document.getElementById("qtyInput").value = qty;

        updatePrice();
    }

    function updatePrice() {
        // Read base price dynamically every time
        let basePrice = parseFloat(document.getElementById("basePriceInput").value);


        let qty = parseInt(document.getElementById("quantity").value);
        let tier = document.getElementById("tierInput").value;
        let size = document.getElementById("sizeInput").value;

        let tierExtra = 0;
        let sizeExtra = 0;
        // Tier pricing
        if (tier === "2") tierExtra = 50;

        // Size pricing
        if (size === "10") sizeExtra = 30;

        let unitPrice = basePrice + tierExtra + sizeExtra;
        let total = unitPrice * qty;

        document.getElementById("price").innerText = "RM" + total.toFixed(2);
        document.getElementById("priceInput").value = total.toFixed(2);
    }

    function syncData() {
        document.getElementById("qtyInput").value =
            document.getElementById("quantity").value;

        document.getElementById("flavorInput").value =
            document.querySelector(".flavor-option.selected").innerText;
    }


    window.selectTier = selectTier;
    window.selectSize = selectSize;
    window.selectFlavor = selectFlavor;
    window.changeQty = changeQty;
    window.syncData = syncData;


    updatePrice();
});



