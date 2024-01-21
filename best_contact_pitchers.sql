-- ideal contact pitcher: minimize the following 3 variables: K/9, BB/9, ERA
SELECT P.FirstName || ' ' || P.LastName                                     AS PlayerName,
       SUM(PSPS.InningsPitched)                                             AS InningsPitched,
       SUM(PSPS.Strikeouts) / (CAST(SUM(PSPS.InningsPitched) AS FLOAT) / 9) AS KPer9,
       SUM(PSPS.Walks) / (CAST(SUM(PSPS.InningsPitched) AS FLOAT) / 9)      AS BBPer9,
       AVG(PSPS.EraMinus)                                                   AS EraMinus,
       (SUM(PSPS.InningsPitched) * (1 / (SUM(PSPS.Strikeouts) / (CAST(SUM(PSPS.InningsPitched) AS FLOAT) / 9))) +
--         SUM(PSPS.InningsPitched) * (1 / (SUM(PSPS.Walks) / (CAST(SUM(PSPS.InningsPitched) AS FLOAT) / 9))) +
        SUM(PSPS.InningsPitched) * (1 / AVG(PSPS.EraMinus))) / 3            AS WeightedAverage
FROM PlayerSeasonPitchingStats PSPS
         JOIN main.PlayerSeasons PS ON PS.Id = PSPS.PlayerSeasonId
         JOIN main.Players P ON P.Id = PS.PlayerId
WHERE PSPS.IsRegularSeason = 1
  AND PSPS.InningsPitched >= 50
GROUP BY P.Id
ORDER BY WeightedAverage DESC