// Dynamically read base price from a hidden input in your JSP
let basePrice = parseFloat(document.getElementById("basePriceInput").value);

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

// Generic function to handle selection styling
function setSelected(btn, className) {
    document.querySelectorAll('.' + className).forEach(b => b.classList.remove('selected'));
    btn.classList.add('selected');
}

// Update quantity (+ or -)
function changeQty(change) {
    let qtyInput = document.getElementById("quantity");
    let qty = parseInt(qtyInput.value) + change;

    if (qty < 1) qty = 1;
    if (qty > parseInt(qtyInput.max)) qty = parseInt(qtyInput.max);

    qtyInput.value = qty;
    document.getElementById("qtyInput").value = qty;

    updatePrice();
}

// Calculate total price based on basePrice and quantity
function updatePrice() {
    let qty = parseInt(document.getElementById("quantity").value);
    let total = basePrice * qty;

    document.getElementById("price").innerText = "RM" + total.toFixed(2);
    document.getElementById("priceInput").value = total.toFixed(2);
}

// Sync data before submitting form (optional)
function syncData() {
    document.getElementById("qtyInput").value =
        document.getElementById("quantity").value;

    document.getElementById("flavorInput").value =
        document.querySelector(".flavor-option.selected").innerText;
}
