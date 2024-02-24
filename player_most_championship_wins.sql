SELECT P.FirstName || ' ' || P.LastName AS PlayerName,
       COUNT(PS.PlayerId)               AS NumChampionships,
       JSON_GROUP_ARRAY(JSON_OBJECT(
               'Season', S.Number,
               'TeamName', TNH.Name))   AS Seasons
FROM PlayerSeasons PS
         JOIN main.Players P ON P.Id = PS.PlayerId
         JOIN main.Seasons S ON PS.SeasonId = S.Id
         LEFT JOIN main.PlayerTeamHistory PTH ON PS.Id = PTH.PlayerSeasonId
         LEFT JOIN main.SeasonTeamHistory STH ON STH.Id = PTH.SeasonTeamHistoryId
         LEFT JOIN main.TeamNameHistory TNH ON TNH.Id = STH.TeamNameHistoryId
WHERE PS.ChampionshipWinnerId IS NOT NULL
GROUP BY PS.PlayerId
ORDER BY NumChampionships DESC, PlayerName