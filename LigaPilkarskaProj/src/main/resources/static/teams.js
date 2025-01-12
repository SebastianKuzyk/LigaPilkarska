async function fetchTeams() {
    const response = await fetch('/api/teams');
    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }
    const teams = await response.json();
    const teamsTableBody = document.querySelector('#teamsTable tbody');
    teamsTableBody.innerHTML = '';

    teams.forEach(team => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${team.teamName}</td>
            <td>${team.stadiumName}</td>
            <td>${team.city}</td>
            <td>${team.points}</td>
            <td>${team.matchesPlayed}</td>
            <td>${team.wins}</td>
            <td>${team.draws}</td>
            <td>${team.losses}</td>
            <td>${team.goalsScored}</td>
            <td>${team.goalsConceded}</td>
            <td>
                <button onclick="editTeam(${team.teamId}, '${team.teamName}', '${team.stadiumName}', '${team.city}')">Edytuj</button>
                <button onclick="deleteTeam(${team.teamId})">Usuń</button>
            </td>
        `;
        teamsTableBody.appendChild(row);
    });
}

async function addTeam() {
    const teamName = prompt("Podaj nazwę zespołu:");
    const stadiumName = prompt("Podaj nazwę stadionu:");
    const city = prompt("Podaj miasto:");

    if (!teamName || !stadiumName || !city) {
        alert("Wszystkie pola są wymagane.");
        return;
    }

    const team = { teamName, stadiumName, city };

    const response = await fetch('/api/teams', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(team)
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchTeams(); // Odświeżenie tabeli
}

async function editTeam(teamId, currentTeamName, currentStadiumName, currentCity) {
    const teamName = prompt("Podaj nową nazwę zespołu:", currentTeamName);
    const stadiumName = prompt("Podaj nową nazwę stadionu:", currentStadiumName);
    const city = prompt("Podaj nowe miasto:", currentCity);

    if (!teamName || !stadiumName || !city) {
        alert("Wszystkie pola są wymagane.");
        return;
    }

    const team = { teamName, stadiumName, city };

    const response = await fetch(`/api/teams/${teamId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(team)
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchTeams(); // Odświeżenie tabeli
}

async function deleteTeam(teamId) {
    if (!confirm("Czy na pewno chcesz usunąć ten zespół?")) return;

    const response = await fetch(`/api/teams/${teamId}`, {
        method: 'DELETE'
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchTeams(); // Odświeżenie tabeli
}

// Inicjalizacja po załadowaniu strony
document.addEventListener('DOMContentLoaded', () => {
    fetchTeams();

    const addTeamButton = document.getElementById('addTeamButton');
    if (addTeamButton) {
        addTeamButton.addEventListener('click', addTeam);
    }
});
