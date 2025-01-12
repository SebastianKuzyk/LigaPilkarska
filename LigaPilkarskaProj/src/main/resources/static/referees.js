async function fetchReferees() {
    const response = await fetch('/api/referees');
    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }
    const referees = await response.json();
    const refereesTableBody = document.querySelector('#refereeTable tbody');
    refereesTableBody.innerHTML = '';

    referees.forEach(referee => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${referee.firstName}</td>
            <td>${referee.lastName}</td>
            <td>
                <button onclick="editReferee(${referee.refereeId}, '${referee.firstName}', '${referee.lastName}')">Edytuj</button>
                <button onclick="deleteReferee(${referee.refereeId})">Usuń</button>
            </td>
        `;
        refereesTableBody.appendChild(row);
    });
}

async function addReferee() {
    const firstName = prompt("Podaj imię sędziego:");
    const lastName = prompt("Podaj nazwisko sędziego:");

    if (!firstName || !lastName) {
        alert("Imię i nazwisko sędziego są wymagane.");
        return;
    }

    const referee = { firstName, lastName };

    const response = await fetch('/api/referees', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(referee)
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchReferees(); // Odświeżenie tabeli
}

async function editReferee(refereeId, currentFirstName, currentLastName) {
    const firstName = prompt("Podaj nowe imię sędziego:", currentFirstName);
    const lastName = prompt("Podaj nowe nazwisko sędziego:", currentLastName);

    if (!firstName || !lastName) {
        alert("Imię i nazwisko sędziego są wymagane.");
        return;
    }

    const referee = { firstName, lastName };

    const response = await fetch(`/api/referees/${refereeId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(referee)
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchReferees(); // Odświeżenie tabeli
}

async function deleteReferee(refereeId) {
    if (!confirm("Czy na pewno chcesz usunąć tego sędziego?")) return;

    const response = await fetch(`/api/referees/${refereeId}`, {
        method: 'DELETE'
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchReferees(); // Odświeżenie tabeli
}

// Inicjalizacja po załadowaniu strony
document.addEventListener('DOMContentLoaded', () => {
    // fetchReferees();

    const addRefereeButton = document.getElementById('addRefereeButton');
    addRefereeButton.addEventListener('click', addReferee);
});
