SELECT *
FROM Players P
         JOIN PlayerSeasons PS ON P.Id = PS.PlayerId
         JOIN PlayerSeasonGameStats PSGS ON PS.Id = PSGS.PlayerSeasonId
         JOIN PlayerSeasonBattingStats PSBS ON PS.Id = PSBS.PlayerSeasonId
WHERE P.FirstName = 'Matias'
  AND P.LastName = 'Zoner'
  AND PSBS.IsRegularSeason = 1
ORDER BY PS.SeasonId DESC