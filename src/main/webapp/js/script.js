// Function to handle clicking the option badges
function selectOption(element, category) {
    // Find the specific row (Tier, Flavour, or Size)
    const row = element.closest('.customization-row');

    // Remove 'active' from all badges in this row
    row.querySelectorAll('.option-badge').forEach(badge => {
        badge.classList.remove('active');
    });

    // Add 'active' to the clicked badge
    element.classList.add('active');
}

// Function to show the confirmation popup
function showConfirmation(button) {
    // Find the whole cake item
    const item = button.closest('.inventory-item');

    // Mark this item as the one we are currently editing
    document.querySelectorAll('.inventory-item').forEach(i => i.classList.remove('active-selecting'));
    item.classList.add('active-selecting');

    const cakeName = item.querySelector('.item-name').innerText;
    const selections = item.querySelectorAll('.option-badge.active');

    // Validation: Ensure one button from each of the 3 rows is selected
    if (selections.length < 3) {
        alert("Please select one Tier, one Flavour, and one Size!");
        return;
    }

    // Build the summary text for the popup
    let summary = "<b>Cake:</b> " + cakeName + "<br><br>";
    selections.forEach(s => {
        const category = s.closest('.customization-row').querySelector('.customization-label').innerText;
        summary += `<b>${category}</b> ${s.innerText}<br>`;
    });

    // Put summary into your existing modal
    document.getElementById('modalTitle').innerText = "Confirm Selection";
    document.getElementById('modalInfo').innerHTML = summary;

    // Show the modal (adds the CSS class that sets display: flex)
    document.getElementById('updateModal').classList.add('show');
}

function closeModal() {
    document.getElementById('updateModal').classList.remove('show');
}

// This is what runs when you click 'Save' in the popup
function saveQuantity() {
    const activeItem = document.querySelector('.inventory-item.active-selecting');
    if (!activeItem) return;

    // 1. Get values from the active item
    const cakeId = activeItem.querySelector('.item-id').innerText;
    const tier = activeItem.querySelector('.customization-row:nth-child(1) .option-badge.active').innerText;
    const flavour = activeItem.querySelector('.customization-row:nth-child(2) .option-badge.active').innerText;
    const size = activeItem.querySelector('.customization-row:nth-child(3) .option-badge.active').innerText;

    // 2. Fill the hidden form (we will add this to your JSP)
    document.getElementById('formCakeId').value = cakeId;
    document.getElementById('formTier').value = tier;
    document.getElementById('formFlavour').value = flavour;
    document.getElementById('formSize').value = size;

    // 3. Submit to Servlet
    console.log("Submitting to Servlet..."); // This helps you see it's working in F12 console
    document.getElementById('hiddenOrderForm').submit();
}