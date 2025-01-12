async function fetchStadiums() {
    const response = await fetch('/api/stadiums');
    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }
    const stadiums = await response.json();
    const stadiumsTableBody = document.querySelector('#stadiumTable tbody');
    stadiumsTableBody.innerHTML = '';

    stadiums.forEach(stadium => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${stadium.stadiumName}</td>
            <td>
                <button onclick="editStadium(${stadium.stadiumId}, '${stadium.stadiumName}')">Edytuj</button>
                <button onclick="deleteStadium(${stadium.stadiumId})">Usuń</button>
            </td>
        `;
        stadiumsTableBody.appendChild(row);
    });
}

async function addStadium() {
    const stadiumName = prompt("Podaj nazwę stadionu:");

    if (!stadiumName) {
        alert("Nazwa stadionu jest wymagana.");
        return;
    }

    const stadium = { stadiumName };

    const response = await fetch('/api/stadiums', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(stadium)
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchStadiums(); // Odświeżenie tabeli
}

async function editStadium(stadiumId, currentStadiumName) {
    const stadiumName = prompt("Podaj nową nazwę stadionu:", currentStadiumName);

    if (!stadiumName) {
        alert("Nazwa stadionu jest wymagana.");
        return;
    }

    const stadium = { stadiumName };

    const response = await fetch(`/api/stadiums/${stadiumId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(stadium)
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchStadiums(); // Odświeżenie tabeli
}

async function deleteStadium(stadiumId) {
    if (!confirm("Czy na pewno chcesz usunąć ten stadion?")) return;

    const response = await fetch(`/api/stadiums/${stadiumId}`, {
        method: 'DELETE'
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchStadiums(); // Odświeżenie tabeli
}

// Inicjalizacja po załadowaniu strony
document.addEventListener('DOMContentLoaded', () => {
    fetchStadiums();

    const addStadiumButton = document.getElementById('addStadiumButton');
    addStadiumButton.addEventListener('click', addStadium);
});
