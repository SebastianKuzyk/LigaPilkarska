async function fetchPlayerStatistics() {
    const response = await fetch('/api/player-statistics');
    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }
    const statistics = await response.json();
    const statisticsTableBody = document.querySelector('#statisticsTable tbody');
    statisticsTableBody.innerHTML = '';

    statistics.forEach(stat => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${stat.playerName}</td>
            <td>${stat.goals}</td>
            <td>${stat.assists}</td>
            <td>${stat.yellowCards}</td>
            <td>${stat.redCards}</td>
            <td>${stat.cleanSheet}</td>
            <td>
                <button onclick="editStatistics(${stat.playerId}, ${stat.goals}, ${stat.assists}, ${stat.yellowCards}, ${stat.redCards}, ${stat.cleanSheet})">Edytuj</button>
            </td>
        `;
        statisticsTableBody.appendChild(row);
    });
}

async function editStatistics(playerId, currentGoals, currentAssists, currentYellowCards, currentRedCards, currentCleanSheet) {
    const goals = prompt("Podaj nową liczbę bramek:", currentGoals);
    const assists = prompt("Podaj nową liczbę asyst:", currentAssists);
    const yellowCards = prompt("Podaj nową liczbę żółtych kartek:", currentYellowCards);
    const redCards = prompt("Podaj nową liczbę czerwonych kartek:", currentRedCards);
    const cleanSheet = prompt("Podaj nową liczbę czystych kont:", currentCleanSheet);

    if (goals === null || assists === null || yellowCards === null || redCards === null || cleanSheet === null) {
        return;
    }

    const updatedStats = {
        goals: parseInt(goals),
        assists: parseInt(assists),
        yellowCards: parseInt(yellowCards),
        redCards: parseInt(redCards),
        cleanSheet: parseInt(cleanSheet)
    };

    const response = await fetch(`/api/player-statistics/${playerId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(updatedStats)
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchPlayerStatistics();
}

// Inicjalizacja po załadowaniu strony
document.addEventListener('DOMContentLoaded', () => {
    // fetchPlayerStatistics();
});
