document.addEventListener("DOMContentLoaded", () => {
    const urlParams = new URLSearchParams(window.location.search);
    const teamId = urlParams.get("teamId");

    if (!teamId) {
        alert("❌ Błąd: Nie znaleziono ID drużyny w URL.");
        return;
    }

    console.log("📋 Załadowano stronę zawodników dla teamId:", teamId);
    fetchPlayers(teamId);
    fetchTeamDetails(teamId);
    fetchTeamRanking(teamId);
});

// 📊 Pobieranie pozycji drużyny w rankingu
async function fetchTeamRanking(teamId) {
    try {
        const response = await fetch(`/api/team-ranking/${teamId}`);
        if (!response.ok) throw new Error(`Błąd HTTP: ${response.status}`);
        
        const ranking = await response.json();
        console.log("📊 Pozycja w rankingu:", ranking);

        document.getElementById("team-ranking").textContent = `Aktualna pozycja w rankingu: ${ranking}`;
    } catch (error) {
        console.error("❌ Błąd pobierania rankingu:", error);
    }
}

// 🏆 Pobieranie informacji o drużynie
async function fetchTeamDetails(teamId) {
    try {
        const response = await fetch(`/api/team-details/${teamId}`);
        if (!response.ok) throw new Error(`❌ Błąd HTTP: ${response.status}`);

        const teamData = await response.json();
        console.log("✅ Dane zespołu z API:", teamData);

        if (!teamData || Object.keys(teamData).length === 0) {
            console.warn("⚠️ Brak danych drużyny.");
            return;
        }
        document.title = `Lista zawodników | ${teamData.teamName}`;
        document.getElementById("team-name").textContent = teamData.teamName || "Brak danych";
        document.getElementById("coach-name-value").textContent = teamData.coachName || "Brak danych";
    } catch (error) {
        console.error("❌ Błąd pobierania danych drużyny:", error);
        document.getElementById("team-name").textContent = "Błąd ładowania danych";
    }
}

// 📌 Pobieranie zawodników dla danej drużyny
function fetchPlayers(teamId) {
    fetch(`/api/team-details/${teamId}/players`)
        .then(response => response.json())
        .then(players => {
            console.log("✅ Pobranie zawodników:", players);

            const tableBody = document.getElementById("players-table");
            tableBody.innerHTML = ""; // Czyszczenie tabeli

            if (players.length === 0) {
                tableBody.innerHTML = `<tr><td colspan="8">Brak dostępnych zawodników</td></tr>`;
                return;
            }

            players.forEach(player => {
                const row = document.createElement("tr");
                row.innerHTML = `
                    <td>${player.firstName}</td>
                    <td>${player.lastName}</td>
                    <td>${player.positionName}</td>
                    <td>${player.goals}</td>
                    <td>${player.assists}</td>
                    <td>${player.cleanSheets}</td>
                    <td>${player.yellowCards}</td>
                    <td>${player.redCards}</td>
                `;
                tableBody.appendChild(row);
            });
        })
        .catch(error => {
            console.error("❌ Błąd pobierania zawodników:", error);
            document.getElementById("players-table").innerHTML = `<tr><td colspan="8">Błąd ładowania danych</td></tr>`;
        });
}

// 📌 Funkcja powrotu
function goBack() {
    window.history.back();
}
