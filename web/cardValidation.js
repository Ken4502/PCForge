document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector("form");
    const cardNumberInput = document.getElementById("cardNumber");
    const expiryInput = document.getElementById("expiryDate");
    const ccvInput = document.getElementById("ccv");

    // Real-time formatting
    cardNumberInput.addEventListener("input", function (e) {
        let value = e.target.value.replace(/\D/g, '').substring(0, 16); // Only digits, max 16
        value = value.replace(/(.{4})/g, '$1-').trim();
        if (value.endsWith('-')) value = value.slice(0, -1);
        e.target.value = value;
    });

    expiryInput.addEventListener("input", function (e) {
        let value = e.target.value.replace(/\D/g, '').substring(0, 4); // Only digits, max 4
        if (value.length >= 3) {
            value = value.substring(0, 2) + '/' + value.substring(2);
        }
        e.target.value = value;
    });

    ccvInput.addEventListener("input", function (e) {
        e.target.value = e.target.value.replace(/\D/g, '').substring(0, 3); // Only 3 digits
    });

    // Submission validation
    form.addEventListener("submit", function (e) {
        const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
        if (paymentMethod === "card") {
            const cardNumber = cardNumberInput.value.replace(/-/g, '');
            const expiryDate = expiryInput.value;
            const ccv = ccvInput.value;

            // Card number validation
            if (!/^\d{16}$/.test(cardNumber)) {
                alert("Invalid card number. It must be 16 digits.");
                e.preventDefault();
                return;
            }

            // Expiry validation
            const match = expiryDate.match(/^(\d{2})\/(\d{2})$/);
            if (!match) {
                alert("Invalid expiry date format. Use MM/YY.");
                e.preventDefault();
                return;
            }

            const expMonth = parseInt(match[1], 10);
            const expYear = parseInt(match[2], 10) + 2000;

            if (expMonth < 1 || expMonth > 12) {
                alert("Expiry month must be between 01 and 12.");
                e.preventDefault();
                return;
            }

            const now = new Date();
            const currentMonth = now.getMonth() + 1;
            const currentYear = now.getFullYear();

            if (expYear < currentYear || (expYear === currentYear && expMonth < currentMonth)) {
                alert("Your card has expired.");
                e.preventDefault();
                return;
            }

            // CVV validation
            if (!ccv || ccv.length !== 3 || !/^\d{3}$/.test(ccv)) {
                alert("Invalid CVV. It must be exactly 3 digits.");
                e.preventDefault();
                return;
            }

        }
    });
});


