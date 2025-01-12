document.addEventListener("DOMContentLoaded", () => {
    const urlParams = new URLSearchParams(window.location.search);
    const teamId = urlParams.get("teamId");

    if (!teamId) {
        alert("❌ Błąd: Nie znaleziono ID drużyny w URL.");
        return;
    }

    console.log("📅 Załadowano stronę meczów dla teamId:", teamId);
    fetchTeamDetails(teamId);
    fetchTeamRanking(teamId);
    fetchAllMatches(teamId);
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
        document.title = `Lista meczów | ${teamData.teamName}`;
        document.getElementById("team-name").textContent = teamData.teamName || "Brak danych";
        document.getElementById("coach-name-value").textContent = teamData.coachName || "Brak danych";
    } catch (error) {
        console.error("❌ Błąd pobierania danych drużyny:", error);
    }
}

// ⚽ Pobieranie wszystkich meczów drużyny
function fetchAllMatches(teamId) {
    fetch(`/api/match-details/${teamId}/all`)
        .then(response => response.json())
        .then(matches => {
            console.log("⚽ Wszystkie mecze:", matches);

            const tableBody = document.getElementById("matches-table");
            tableBody.innerHTML = ""; // Czyszczenie tabeli przed dodaniem nowych danych

            if (matches.length === 0) {
                tableBody.innerHTML = `<tr><td colspan="6">Brak dostępnych meczów</td></tr>`;
                return;
            }

            matches.forEach(match => {
                const row = document.createElement("tr");
                row.innerHTML = `
                    <td>${match.matchDate}</td>
                    <td>${match.homeTeamName}</td>
                    <td>${match.awayTeamName}</td>
                    <td>${match.homeTeamScore} - ${match.awayTeamScore}</td>
                    <td>${match.stadiumName}</td>
                    <td>${match.locationType}</td>
                `;
                tableBody.appendChild(row);
            });
        })
        .catch(error => {
            console.error("❌ Błąd pobierania meczów:", error);
            document.getElementById("matches-table").innerHTML = `<tr><td colspan="6">Błąd ładowania danych</td></tr>`;
        });
}

// 📌 Funkcja powrotu
function goBack() {
    window.history.back();
}
