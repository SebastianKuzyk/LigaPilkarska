document.addEventListener('DOMContentLoaded', () => {
    const datePicker = document.getElementById('matchDate');
    fetchAllMatchDates();

    if (datePicker) {
        datePicker.addEventListener('change', async () => {
            const date = datePicker.value;
            if (date) {
                await fetchMatchesByDate(date);
            } else {
                alert('Proszę wybrać datę.');
            }
        });
    }

    // Pobieranie wszystkich dostępnych dat meczów
    async function fetchAllMatchDates() {
        try {
            const response = await fetch('/api/matches/dates');
            if (!response.ok) throw new Error(`Network response was not ok: ${response.statusText}`);
            const data = await response.json();
            console.log('Match Dates:', data);
        } catch (error) {
            console.error('Error fetching match dates:', error);
        }
    }

    // Pobieranie meczów dla wybranej daty
    async function fetchMatchesByDate(date) {
        try {
            const response = await fetch(`/api/matches/by-date?date=${date}`);
            if (!response.ok) throw new Error(`Network response was not ok: ${response.statusText}`);
            
            const data = await response.json();
            console.log('Matches:', data);
    
            const resultDiv = document.getElementById('matchesResult');
            resultDiv.innerHTML = '';
    
            if (!data || data.length === 0) {
                const noMatchesMessage = document.createElement('div');
                noMatchesMessage.classList.add('no-matches');
                noMatchesMessage.textContent = "Brak meczów w tej dacie.";
                resultDiv.appendChild(noMatchesMessage);
            } else {
                const container = document.createElement('div');
                container.classList.add('matches-container');
    
                data.forEach(match => {
                    const isFuture = new Date(match.matchDate) > new Date();
                    const matchCard = document.createElement('div');
                    matchCard.classList.add('match-card');
    
                    matchCard.innerHTML = `
                        <span class="team-name">${match.homeTeamName}</span>
                        <span class="match-score">${isFuture ? '-' : `${match.homeTeamScore} - ${match.awayTeamScore}`}</span>
                        <span class="team-name" style="text-align: right;">${match.awayTeamName}</span>
                    `;
    
                    container.appendChild(matchCard);
                });
    
                resultDiv.appendChild(container);
            }
        } catch (error) {
            console.error('Error fetching matches by date:', error);
            document.getElementById('matchesResult').innerHTML = '<div class="no-matches">Wystąpił błąd podczas pobierania danych.</div>';
        }
    }    
    

    // Pobieranie wszystkich nazw drużyn (opcjonalne, jeśli ma być używane)
    async function fetchAllTeamNames() {
        try {
            const response = await fetch('/api/teams');
            if (!response.ok) throw new Error(`Network response was not ok: ${response.statusText}`);
            const teams = await response.json();
            console.log('Teams:', teams);
        } catch (error) {
            console.error('Error fetching team names:', error);
        }
    }

    async function fetchTeamsRanking() {
        try {
            const response = await fetch('/api/teams/ranking');
            if (!response.ok) throw new Error(`Network response was not ok: ${response.statusText}`);
        
            const teams = await response.json();
    
            const rankingBody = document.getElementById('teamsRankingBody');
            rankingBody.innerHTML = '';
    
            teams.forEach(team => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${team.ranking}</td>
                    <td><a href="#" class="team-link" data-id="${team.teamId || team.team_id}" data-name="${team.teamName}">${team.teamName}</a></td>
                `;
                rankingBody.appendChild(row);
            });
    
            // Obsługa kliknięcia w drużynę
            document.querySelectorAll('.team-link').forEach(link => {
                link.addEventListener('click', function (event) {
                    event.preventDefault();
                    const teamId = this.dataset.id;
                    const teamName = this.dataset.name;
                    window.location.href = `team.html?teamId=${teamId}`;
                });
            });
    
        } catch (error) {
            console.error('Error fetching teams ranking:', error);
            document.getElementById('teamsRankingBody').innerHTML = 'Wystąpił błąd podczas pobierania danych.';
        }
    }
    
    
    // Funkcja ładująca stronę drużyny
    function loadTeamPage(teamId, teamName) {
        const mainContent = document.querySelector('main');
        mainContent.innerHTML = `
            <h2>${teamName}</h2>
            <p>Ładowanie danych drużyny...</p>
        `;
    
        fetch(`/api/teams/${teamId}`)
            .then(response => response.json())
            .then(teamData => {
                mainContent.innerHTML = `
                    <h2>${teamName}</h2>
                    <p>Miejsce w rankingu: ${teamData.ranking}</p>
                    <h3>Lista zawodników</h3>
                    <ul>${teamData.players.map(player => `<li>${player.firstName} ${player.lastName}</li>`).join('')}</ul>
                    <button onclick="location.reload()">Wróć</button>
                `;
            })
            .catch(error => {
                console.error('Error fetching team details:', error);
                mainContent.innerHTML = `<p>Nie udało się załadować danych.</p>`;
            });
    }
    
    // Automatyczne ładowanie rankingu drużyn
    fetchTeamsRanking();
    

    // Pobieranie najlepszych strzelców, asystentów i bramkarzy
    async function fetchTopPlayers(endpoint, resultBodyId) {
        try {
            const response = await fetch(endpoint);
            if (!response.ok) throw new Error(`Network response was not ok: ${response.statusText}`);
            
            const data = await response.json();
            console.log(`Top players from ${endpoint}:`, data);

            const resultBody = document.getElementById(resultBodyId);
            if (!resultBody) {
                console.error(`Element #${resultBodyId} not found.`);
                return;
            }
            resultBody.innerHTML = '';

            data.forEach(player => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${player.firstName}</td>
                    <td>${player.lastName}</td>
                    <td>${player.teamName}</td>
                    <td>${player.statistic || 'N/A'}</td>
                `;
                resultBody.appendChild(row);
            });
        } catch (error) {
            console.error(`Error fetching top players from ${endpoint}:`, error);
            document.getElementById(resultBodyId).innerHTML = 'Wystąpił błąd podczas pobierania danych.';
        }
    }

    fetchTopPlayers('/api/players/top-scorers', 'topScorersBody');
    fetchTopPlayers('/api/players/top-assisters', 'topAssistersBody');
    fetchTopPlayers('/api/players/top-goalkeepers', 'topGoalkeepersBody');
});

document.addEventListener("DOMContentLoaded", () => {
    document.getElementById("showTeamStatsBtn").addEventListener("click", () => {
        window.location.href = "team-stats.html"; // Przekierowanie do nowej podstrony
    });
});
