document.addEventListener("DOMContentLoaded", () => {
    fetchTeamsRanking();
    fetchBestAttackAndDefense();
    fetchAveragePoints();
    fetchHomeAwayPerformance();
    fetchMostCommonResults();

    // Obsługa przycisku powrotu do strony głównej
    const backBtn = document.getElementById("backBtn");
    if (backBtn) {
        backBtn.addEventListener("click", () => {
            window.location.href = "index.html";
        });
    }
});

// 🏆 Ranking drużyn
async function fetchTeamsRanking() {
    try {
        const response = await fetch("/api/team-stats/ranking");
        if (!response.ok) throw new Error(`Błąd HTTP: ${response.status}`);

        const teams = await response.json();
        const tableBody = document.getElementById("teamsRankingBody");

        if (!tableBody) return console.error("❌ Element teamsRankingBody nie został znaleziony!");

        tableBody.innerHTML = "";
        teams.forEach(team => {
            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${team.ranking}</td>
                <td>${team.teamName}</td>
                <td>${team.points}</td>
                <td>${team.goalDifference}</td>
                <td>${team.yellowCards}</td>
                <td>${team.redCards}</td>
            `;
            tableBody.appendChild(row);
        });
    } catch (error) {
        console.error("❌ Błąd pobierania rankingu drużyn:", error);
    }
}

// ⚽ Najlepsza ofensywa i defensywa
async function fetchBestAttackAndDefense() {
    try {
        const [attackResponse, defenseResponse] = await Promise.all([
            fetch("/api/team-stats/attack"),
            fetch("/api/team-stats/defense")
        ]);

        if (!attackResponse.ok || !defenseResponse.ok) {
            throw new Error("❌ Błąd HTTP podczas pobierania ofensywy i defensywy");
        }

        const attackData = await attackResponse.json();
        const defenseData = await defenseResponse.json();

        const attackLabels = attackData.map(team => team.teamName);
        const attackValues = attackData.map(team => team.goalsScored);

        const defenseLabels = defenseData.map(team => team.teamName);
        const defenseValues = defenseData.map(team => team.goalsConceded);

        createPieChart("bestAttackChart", attackLabels, attackValues, "Najlepsza ofensywa");
        createPieChart("bestDefenseChart", defenseLabels, defenseValues, "Najlepsza defensywa");
    } catch (error) {
        console.error("❌ Błąd pobierania danych ofensywy i defensywy:", error);
    }
}

// 📊 Średnia liczba punktów
async function fetchAveragePoints() {
    try {
        const response = await fetch("/api/team-stats/average-points");
        if (!response.ok) throw new Error(`Błąd HTTP: ${response.status}`);

        const data = await response.json();
        createBarChart("averagePointsChart", data.map(team => team.teamName), data.map(team => team.avgPointsPerMatch), "Średnia liczba punktów");
    } catch (error) {
        console.error("❌ Błąd pobierania średnich punktów:", error);
    }
}

// 🏟️ Mecze domowe vs wyjazdowe
async function fetchHomeAwayPerformance() {
    try {
        const response = await fetch("/api/team-stats/home-away");
        if (!response.ok) throw new Error(`Błąd HTTP: ${response.status}`);

        const data = await response.json();

        const labels = data.map(team => team.teamName);
        const homeValues = data.map(team => team.avgHomePoints);
        const awayValues = data.map(team => team.avgAwayPoints);

        createGroupedBarChart("homeAwayChart", labels, homeValues, awayValues, "średnia liczba punktów, jakie drużyna zdobywa w meczach domowych vs wyjazdowych");
    } catch (error) {
        console.error("❌ Błąd pobierania danych o meczach domowych i wyjazdowych:", error);
    }
}

// 🔥 Najczęstsze wyniki meczów
async function fetchMostCommonResults() {
    try {
        const response = await fetch("/api/team-stats/most-common-results");
        if (!response.ok) throw new Error(`Błąd HTTP: ${response.status}`);

        const results = await response.json();
        console.log("📊 Najczęstsze wyniki meczów:", results);

        const tableBody = document.getElementById("commonResultsTable");
        if (!tableBody) return console.error("❌ Nie znaleziono elementu #commonResultsTable w HTML!");

        tableBody.innerHTML = ""; // Czyszczenie tabeli

        results.forEach(result => {
            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${result.matchResult}</td>
                <td>${result.matchCount}</td>
                <td>${result.percentage}%</td>
            `;
            tableBody.appendChild(row);
        });

        createBarChart("commonResultsChart", results.map(res => res.matchResult), results.map(res => res.matchCount), "Najczęstsze wyniki meczów");
    } catch (error) {
        console.error("❌ Błąd pobierania najczęstszych wyników meczów:", error);
    }
}

// 🔹 Funkcje do wykresów Chart.js
function createPieChart(id, labels, data, title) {
    const ctx = document.getElementById(id);
    if (!ctx) return console.error(`❌ Nie znaleziono elementu #${id}`);

    new Chart(ctx, {
        type: "pie",
        data: {
            labels: labels,
            datasets: [{
                data: data,
                backgroundColor: ["#FF6384", "#36A2EB", "#FFCE56", "#4CAF50", "#FF9800"]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                title: { display: true, text: title }
            }
        }
    });
}


function createBarChart(id, labels, data, title) {
    const ctx = document.getElementById(id);
    if (!ctx) return console.error(`❌ Nie znaleziono elementu #${id}`);

    new Chart(ctx, {
        type: "bar",
        data: {
            labels: labels,
            datasets: [{
                label: title,
                data: data,
                backgroundColor: "rgba(211, 47, 47, 0.7)",
                borderColor: "rgba(211, 47, 47, 1)",
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: { beginAtZero: true }
            },
            plugins: {
                title: { display: false, text: title }
            }
        }
    });
}

function createGroupedBarChart(id, labels, homeData, awayData, title) {
    const ctx = document.getElementById(id);
    if (!ctx) return console.error(`❌ Nie znaleziono elementu #${id}`);

    new Chart(ctx, {
        type: "bar",
        data: {
            labels: labels,
            datasets: [
                { label: "Domowe", data: homeData, backgroundColor: "blue" },
                { label: "Wyjazdowe", data: awayData, backgroundColor: "red" }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { title: { display: true, text: title } },
            scales: { x: { stacked: false }, y: { stacked: false } }
        }
    });
}
