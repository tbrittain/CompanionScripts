SELECT P.FirstName || ' ' || P.LastName                                     AS PlayerName,
       SUM(PSPS.Strikeouts)                                                 AS Strikeouts,
       SUM(PSPS.InningsPitched)                                             AS InningsPitched,
       SUM(PSPS.Strikeouts) / (CAST(SUM(PSPS.InningsPitched) AS FLOAT) / 9) AS KPer9,
       SUM(PSPS.Strikeouts) / CAST(SUM(PSPS.BattersFaced) AS FLOAT)         AS StrikeoutPercent,
       AVG(PSPS.EraMinus)                                                   AS EraMinus
FROM PlayerSeasonPitchingStats PSPS
         JOIN main.PlayerSeasons PS ON PS.Id = PSPS.PlayerSeasonId
         JOIN main.Players P ON P.Id = PS.PlayerId
WHERE PSPS.IsRegularSeason = 1
  AND PSPS.InningsPitched >= 50
GROUP BY P.Id
ORDER BY KPer9 DESC
