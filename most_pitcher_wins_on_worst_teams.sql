SELECT P.FirstName || ' ' || P.LastName                   AS PlayerName,
       S.Number                                           AS SeasonNumber,
       PSPS.Wins,
       PSPS.Losses,
       PSPS.WinPercentage,
       PSPS.EarnedRunAverage,
       PSPS.EraMinus,
       TNH.Name                                           AS TeamName,
       STH.Wins                                           AS TeamWins,
       PSPS.Wins * (1 / CAST(STH.WinPercentage AS FLOAT)) AS WeightedWinsPerTeamLoss
FROM PlayerSeasonPitchingStats PSPS
         JOIN main.PlayerSeasons PS ON PS.Id = PSPS.PlayerSeasonId
         JOIN main.Seasons S ON S.Id = PS.SeasonId
         JOIN main.Players P ON P.Id = PS.PlayerId
         JOIN main.PlayerTeamHistory PTH ON PTH.PlayerSeasonId = PS.Id
         JOIN main.SeasonTeamHistory STH ON PTH.SeasonTeamHistoryId = STH.Id
         JOIN main.Teams T ON STH.TeamId = T.Id
         JOIN main.TeamNameHistory TNH ON STH.TeamNameHistoryId = TNH.Id
WHERE PSPS.IsRegularSeason = 1
ORDER BY WeightedWinsPerTeamLoss DESC