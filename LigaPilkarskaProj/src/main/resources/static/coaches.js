async function fetchCoaches() {
    const response = await fetch('/api/coaches');
    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }
    const coaches = await response.json();
    const coachesTableBody = document.querySelector('#coachesTable tbody');
    coachesTableBody.innerHTML = '';

    coaches.forEach(coach => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${coach.firstName}</td>
            <td>${coach.lastName}</td>
            <td>${coach.teamName}</td>
            <td>
                <button onclick="editCoach(${coach.id}, '${coach.firstName}', '${coach.lastName}', '${coach.teamName}')">Edytuj</button>
                <button onclick="deleteCoach(${coach.id})">Usuń</button>
            </td>
        `;
        coachesTableBody.appendChild(row);
    });
}

async function addCoach() {
    const firstName = prompt("Podaj imię trenera:");
    const lastName = prompt("Podaj nazwisko trenera:");
    const teamName = prompt("Podaj nazwę zespołu:");

    if (!firstName || !lastName || !teamName) {
        alert("Wszystkie pola są wymagane!");
        return;
    }

    const coach = { firstName, lastName, teamName };

    const response = await fetch('/api/coaches', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(coach)
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchCoaches();
}

async function editCoach(coachId, currentFirstName, currentLastName, currentTeamName) {
    const firstName = prompt("Podaj nowe imię trenera:", currentFirstName);
    const lastName = prompt("Podaj nowe nazwisko trenera:", currentLastName);
    const teamName = prompt("Podaj nową nazwę zespołu:", currentTeamName);

    if (!firstName || !lastName || !teamName) {
        alert("Wszystkie pola są wymagane!");
        return;
    }

    const coach = { firstName, lastName, teamName };

    const response = await fetch(`/api/coaches/${coachId}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(coach)
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchCoaches();
}

async function deleteCoach(coachId) {
    if (!confirm("Czy na pewno chcesz usunąć tego trenera?")) {
        return;
    }

    const response = await fetch(`/api/coaches/${coachId}`, {
        method: 'DELETE'
    });

    if (!response.ok) {
        console.error('Error:', 'Network response was not ok ' + response.statusText);
        return;
    }

    fetchCoaches();
}

// Inicjalizacja
document.addEventListener('DOMContentLoaded', () => {
    // fetchCoaches();

    const addCoachButton = document.getElementById('addCoachButton');
    addCoachButton.addEventListener('click', addCoach);
});
