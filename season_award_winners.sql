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
         JOIN main.Players P on PS.PlayerId = P.Id
         JOIN main.PlayerAwardPlayerSeason PAPS on PS.Id = PAPS.PlayerSeasonsId
         JOIN main.PlayerAwards PA on PAPS.AwardsId = PA.Id
         JOIN PlayerSeasonBattingStats PSBS on PS.Id = PSBS.PlayerSeasonId
         LEFT JOIN PlayerSeasonPitchingStats PSPS on PS.Id = PSPS.PlayerSeasonId
         JOIN main.Seasons S on PS.SeasonId = S.Id
WHERE PA.OriginalName = 'MVP'
  AND PSBS.IsRegularSeason = 1
  AND (PSPS.IsRegularSeason = 1 OR PSPS.IsRegularSeason IS NULL)
ORDER BY S.Number
