async function fetchPlayers() {
    const response = await fetch('/api/players/details'); // Pobieranie graczy z nazwami drużyn i pozycji
    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }
    const players = await response.json();
    const playersTableBody = document.querySelector('#playersTable tbody');
    playersTableBody.innerHTML = '';

    players.forEach(player => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${player.firstName}</td>
            <td>${player.lastName}</td>
            <td>${player.positionName}</td>
            <td>${player.teamName}</td>
            <td>
                <button onclick="editPlayer(${player.id}, '${player.firstName}', '${player.lastName}', '${player.positionName}', '${player.teamName}')">Edytuj</button>
                <button onclick="deletePlayer(${player.id})">Usuń</button>
            </td>
        `;
        playersTableBody.appendChild(row);
    });
}

async function addPlayer() {
    const firstName = prompt("Podaj imię zawodnika:");
    const lastName = prompt("Podaj nazwisko zawodnika:");
    const positionName = prompt("Podaj nazwę pozycji:");
    const teamName = prompt("Podaj nazwę drużyny:");

    if (!firstName || !lastName || !positionName || !teamName) {
        alert("Wszystkie pola muszą być poprawnie wypełnione!");
        return;
    }

    const player = { firstName, lastName, positionName, teamName };

    const response = await fetch('/api/players/details', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(player)
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchPlayers(); // Odświeżenie listy po dodaniu gracza
    fetchPlayerStatistics();
}

async function editPlayer(playerId, currentFirstName, currentLastName, currentPosition, currentTeam) {
    const firstName = prompt("Podaj nowe imię zawodnika:", currentFirstName);
    const lastName = prompt("Podaj nowe nazwisko zawodnika:", currentLastName);
    const positionName = prompt("Podaj nową nazwę pozycji:", currentPosition);
    const teamName = prompt("Podaj nową nazwę drużyny:", currentTeam);

    if (!firstName || !lastName || !positionName || !teamName) {
        alert("Wszystkie pola muszą być poprawnie wypełnione!");
        return;
    }

    const player = { firstName, lastName, positionName, teamName };

    const response = await fetch(`/api/players/details/${playerId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(player)
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchPlayers(); // Odświeżenie listy po edycji
    fetchPlayerStatistics();
}

async function deletePlayer(playerId) {
    if (!confirm("Czy na pewno chcesz usunąć tego zawodnika?")) return;

    const response = await fetch(`/api/players/details/${playerId}`, {
        method: 'DELETE'
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchPlayers(); // Odświeżenie listy po usunięciu
    fetchPlayerStatistics();
}

// Inicjalizacja
document.addEventListener('DOMContentLoaded', () => {
    // fetchPlayers(); // Automatyczne załadowanie listy graczy po starcie strony

    const addPlayerButton = document.getElementById('addPlayerButton');
    addPlayerButton.addEventListener('click', addPlayer);
});
