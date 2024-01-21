SELECT P.FirstName || ' ' || P.LastName AS PlayerName,
       S.Number                         AS SeasonNumber,
       PSBS.HomeRuns,
       PSBS.RunsBattedIn,
       PSBS.BattingAverage,
       PSBS.Ops,
       PSBS.OpsPlus,
       PSPS.Wins,
       PSPS.Losses,
       PSPS.InningsPitched,
       PSPS.EarnedRunAverage,
       PSPS.Whip,
       PSPS.StrikeoutsPerNine,
       PSPS.EraMinus
FROM PlayerSeasons PS
         JOIN main.Players P ON PS.PlayerId = P.Id
         JOIN main.PlayerAwardPlayerSeason PAPS ON PS.Id = PAPS.PlayerSeasonsId
         JOIN main.PlayerAwards PA ON PAPS.AwardsId = PA.Id
         JOIN PlayerSeasonBattingStats PSBS ON PS.Id = PSBS.PlayerSeasonId
         LEFT JOIN PlayerSeasonPitchingStats PSPS ON PS.Id = PSPS.PlayerSeasonId
         JOIN main.Seasons S ON PS.SeasonId = S.Id
WHERE PA.OriginalName = 'MVP'
  AND PSBS.IsRegularSeason = 1
  AND (PSPS.IsRegularSeason = 1 OR PSPS.IsRegularSeason IS NULL)
ORDER BY S.Number
