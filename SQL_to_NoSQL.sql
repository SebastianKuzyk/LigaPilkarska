SELECT jsonb_pretty(
    jsonb_build_object(
        'teams', jsonb_agg(
            jsonb_build_object(
                'team_id', t.team_id,
                'team_name', t.team_name,
                'stadium', jsonb_build_object(
                    'stadium_name', s.stadium_name,
                    'city', trim(t.city)
                ),
                'points', t.points,
                'matches_played', t.matches_played,
                'wins', t.wins,
                'draws', t.draws,
                'losses', t.losses,
                'goals_scored', t.goals_scored,
                'goals_conceded', t.goals_conceded,
                'coach', jsonb_build_object(
                    'first_name', c.first_name,
                    'last_name', c.last_name
                ),
                'players', (
                    SELECT jsonb_agg(
                        jsonb_build_object(
                            'player_id', p.player_id,
                            'first_name', trim(p.first_name),
                            'last_name', trim(p.last_name),
                            'position', trim(pos.name),
                            'statistics', jsonb_build_object(
                                'goals', ps.goals,
                                'assists', ps.assists,
                                'yellow_cards', ps.yellow_cards,
                                'red_cards', ps.red_cards,
                                'clean_sheets', ps.clean_sheet
                            )
                        )
                    ) FROM players p
                    LEFT JOIN positions pos ON p.position_id = pos.position_id
                    LEFT JOIN players_statistics ps ON p.player_id = ps.player_id
                    WHERE p.team_id = t.team_id
                ),
                'matches', (
                    SELECT jsonb_agg(
                        jsonb_build_object(
                            'match_id', m.match_id,
                            'home_team', home_team.team_name,
                            'away_team', away_team.team_name,
                            'home_team_score', m.home_team_score,
                            'away_team_score', m.away_team_score,
                            'match_date', m.match_date,
                            'stadium', st.stadium_name,
                            'referee', jsonb_build_object(
                                'first_name', r.first_name,
                                'last_name', r.last_name
                            )
                        )
                    ) FROM matches m
                    LEFT JOIN teams home_team ON m.home_team_id = home_team.team_id
                    LEFT JOIN teams away_team ON m.away_team_id = away_team.team_id
                    LEFT JOIN stadiums st ON m.stadium_id = st.stadium_id
                    LEFT JOIN referees r ON m.referee_id = r.referee_id
                    WHERE m.home_team_id = t.team_id OR m.away_team_id = t.team_id
                )
            )
        )
    )
) FROM teams t
LEFT JOIN coaches c ON t.team_id = c.team_id
LEFT JOIN stadiums s ON t.stadium_id = s.stadium_id;
