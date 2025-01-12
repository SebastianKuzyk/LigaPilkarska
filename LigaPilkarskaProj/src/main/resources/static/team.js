document.addEventListener("DOMContentLoaded", () => {
    const urlParams = new URLSearchParams(window.location.search);
    const teamId = urlParams.get("teamId");

    if (!teamId) {
        alert("❌ Błąd: Nie znaleziono ID drużyny w URL.");
        return;
    }

    console.log("🔍 Załadowano stronę dla teamId:", teamId);

    fetchTeamDetails(teamId);
    fetchTopPlayers(teamId);
    fetchRecentMatches(teamId);
    fetchTeamRanking(teamId);

    // 📌 Obsługa kliknięcia przycisku"
    document.getElementById("showAllPlayersBtn").addEventListener("click", () => {
        window.location.href = `players.html?teamId=${teamId}`;
    });
    document.getElementById("showAllMatchesBtn").addEventListener("click", () => {
        const teamId = new URLSearchParams(window.location.search).get("teamId");
        window.location.href = `matches.html?teamId=${teamId}`;
    });    
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
        document.title = `Drużyna | ${teamData.teamName}`;
        document.getElementById("team-name").textContent = teamData.teamName || "Brak danych";
        document.getElementById("stadium-name").textContent = teamData.stadiumName || "Brak danych";
        document.getElementById("city-name").textContent = teamData.city || "Brak danych";
        document.getElementById("coach-name-value").textContent = teamData.coachName || "Brak danych";
    } catch (error) {
        console.error("❌ Błąd pobierania danych drużyny:", error);
        document.getElementById("team-name").textContent = "Błąd ładowania danych";
    }
}

// 📊 Pobieranie statystyk zawodników
async function fetchTopPlayers(teamId) {
    try {
        const response = await fetch(`/api/player-details/${teamId}`);
        if (!response.ok) throw new Error(`❌ Błąd HTTP: ${response.status}`);

        const players = await response.json();
        console.log("📊 Statystyki zawodników:", players);

        if (!players || players.length === 0) {
            console.warn("⚠️ Brak danych o najlepszych zawodnikach.");
            return;
        }

        // Tworzymy obiekt, aby łatwo przypisać wartości do odpowiednich elementów
        const statsMap = {
            "Najwięcej goli": "top-goals",
            "Najwięcej asyst": "top-assists",
            "Najlepszy bramkarz": "top-goalkeeper",
            "Najwięcej żółtych kartek": "top-yellow-cards",
            "Najwięcej czerwonych kartek": "top-red-cards"
        };

        // Najpierw ustawiamy domyślne wartości "---"
        Object.values(statsMap).forEach(id => {
            document.getElementById(id).textContent = "---";
        });

        // Aktualizujemy wartości tylko jeśli statisticValue > 0
        players.forEach(player => {
            if (player.statisticValue > 0 && statsMap[player.statisticType]) {
                document.getElementById(statsMap[player.statisticType]).textContent = 
                    `${player.firstName} ${player.lastName} (${player.statisticValue})`;
            }
        });
    } catch (error) {
        console.error("❌ Błąd pobierania statystyk zawodników:", error);
    }
}


// ⚽ Pobieranie ostatnich meczów drużyny
async function fetchRecentMatches(teamId) {
    try {
        const response = await fetch(`/api/match-details/${teamId}/recent`);
        if (!response.ok) throw new Error(`❌ Błąd HTTP: ${response.status}`);

        const matches = await response.json();
        console.log("⚽ Ostatnie mecze:", matches);

        const tableBody = document.getElementById("matches-table");
        tableBody.innerHTML = "";

        if (!matches || matches.length === 0) {
            console.warn("⚠️ Brak danych o ostatnich meczach.");
            const row = document.createElement("tr");
            row.innerHTML = `<td colspan="5">Brak dostępnych meczów</td>`;
            tableBody.appendChild(row);
            return;
        }

        matches.forEach(match => {
            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${match.homeTeamName || "Brak danych"}</td>
                <td>${match.homeTeamScore !== null ? match.homeTeamScore : "?"} - ${match.awayTeamScore !== null ? match.awayTeamScore : "?"}</td>
                <td>${match.awayTeamName || "Brak danych"}</td>
                <td>${match.stadiumName || "Brak danych"}</td>
                <td>${match.locationType || "Brak danych"}</td>
            `;
            tableBody.appendChild(row);
        });
    } catch (error) {
        console.error("❌ Błąd pobierania meczów:", error);
    }
}

function goBack() {
    window.history.back();
}