document.addEventListener('DOMContentLoaded', () => {

    // Pobieranie przycisków dodawania
    const addCoachButton = document.getElementById('addCoachButton');
    const addMatchButton = document.getElementById('addMatchButton');
    const addPlayerButton = document.getElementById('addPlayerButton');
    // const addStatisticsButton = document.getElementById('addStatisticsButton');
    const addRefereeButton = document.getElementById('addRefereeButton');
    const addStadiumButton = document.getElementById('addStadiumButton');
    const addTeamButton = document.getElementById('addTeamButton');
    
    // Dodaj event listenery do przycisków
    addCoachButton.addEventListener('click', addCoach);
    addMatchButton.addEventListener('click', addMatch);
    addPlayerButton.addEventListener('click', addPlayer);
    // addStatisticsButton.addEventListener('click', addStatistics);
    addRefereeButton.addEventListener('click', addReferee);
    addStadiumButton.addEventListener('click', addStadium);
    addTeamButton.addEventListener('click', addTeam);
    
    // Pobieranie danych po załadowaniu strony
    fetchCoaches();
    fetchMatches();
    fetchPlayers();
    fetchPlayerStatistics();
    fetchReferees();
    fetchStadiums();
    fetchTeams();
});
