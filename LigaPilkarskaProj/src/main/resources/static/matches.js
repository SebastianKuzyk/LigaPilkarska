async function fetchMatches() {
    const response = await fetch('/api/matches');
    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }
    const matches = await response.json();
    const matchesTableBody = document.querySelector('#matchesTable tbody');
    matchesTableBody.innerHTML = '';

    matches.forEach(match => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${match.homeTeamName}</td>
            <td>${match.homeTeamScore}</td> 
            <td>${match.awayTeamScore}</td>
            <td>${match.awayTeamName}</td>
            <td>${match.matchDate}</td>
            <td>${match.stadiumName}</td>
            <td>${match.refereeName}</td>
            <td>
                <button onclick="editMatch(${match.id}, '${match.homeTeamName}', '${match.awayTeamName}', ${match.homeTeamScore}, ${match.awayTeamScore}, '${match.matchDate}', '${match.stadiumName}', '${match.refereeName}')">Edytuj</button>
                <button onclick="deleteMatch(${match.id})">Usuń</button>
            </td>
        `;
        matchesTableBody.appendChild(row);
    });
}

async function addMatch() {
    const homeTeamName = prompt("Podaj nazwę drużyny gospodarzy:");
    const homeTeamScore = parseInt(prompt("Podaj wynik gospodarzy:"), 10);
    const awayTeamName = prompt("Podaj nazwę drużyny gości:");
    const awayTeamScore = parseInt(prompt("Podaj wynik gości:"), 10);
    const matchDate = prompt("Podaj datę meczu (YYYY-MM-DD):");
    const stadiumName = prompt("Podaj nazwę stadionu:");
    const refereeName = prompt("Podaj nazwisko sędziego:");

    if (!homeTeamName || !awayTeamName || isNaN(homeTeamScore) || isNaN(awayTeamScore) || !matchDate || !stadiumName || !refereeName) {
        alert("Wszystkie pola są wymagane!");
        return;
    }

    const match = { homeTeamName, awayTeamName, homeTeamScore, awayTeamScore, matchDate, stadiumName, refereeName };

    const response = await fetch('/api/matches', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(match)
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchMatches();
}

async function editMatch(matchId, currentHomeTeam, currentAwayTeam, currentHomeScore, currentAwayScore, currentDate, currentStadium, currentReferee) {
    const homeTeamName = prompt("Podaj nową nazwę drużyny gospodarzy:", currentHomeTeam);
    const awayTeamName = prompt("Podaj nową nazwę drużyny gości:", currentAwayTeam);
    const homeTeamScore = parseInt(prompt("Podaj nowy wynik gospodarzy:", currentHomeScore), 10);
    const awayTeamScore = parseInt(prompt("Podaj nowy wynik gości:", currentAwayScore), 10);
    const matchDate = prompt("Podaj nową datę meczu (YYYY-MM-DD):", currentDate);
    const stadiumName = prompt("Podaj nową nazwę stadionu:", currentStadium);
    const refereeName = prompt("Podaj nowe nazwisko sędziego:", currentReferee);

    if (!homeTeamName || !awayTeamName || isNaN(homeTeamScore) || isNaN(awayTeamScore) || !matchDate || !stadiumName || !refereeName) {
        alert("Wszystkie pola są wymagane!");
        return;
    }

    const match = { homeTeamName, awayTeamName, homeTeamScore, awayTeamScore, matchDate, stadiumName, refereeName };

    const response = await fetch(`/api/matches/${matchId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(match)
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchMatches();
}

async function deleteMatch(matchId) {
    if (!confirm("Czy na pewno chcesz usunąć ten mecz?")) {
        return;
    }

    const response = await fetch(`/api/matches/${matchId}`, {
        method: 'DELETE'
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchMatches();
}

// Inicjalizacja
document.addEventListener('DOMContentLoaded', () => {
    // fetchMatches();

    const addMatchButton = document.getElementById('addMatchButton');
    addMatchButton.addEventListener('click', addMatch);
});
