WITH MostRecentSeason AS
         (SELECT S.Id
          FROM Seasons S
          ORDER BY S.Id DESC
          LIMIT 3)
SELECT P.FirstName || ' ' || P.LastName AS PlayerName,
       SUM(PSBS.Hits)                   AS TotalHits,
       SUM(PSBS.HomeRuns)               AS TotalHomeRuns,
       AVG(PSBS.BattingAverage)         AS BattingAverage,
       AVG(PSBS.OpsPlus)                AS OpsPlus
FROM Players P
         JOIN main.PlayerSeasons PS ON PS.PlayerId = P.Id
         JOIN main.PlayerSeasonBattingStats PSBS ON PSBS.PlayerSeasonId = PS.Id
WHERE PS.SeasonId IN (SELECT Id FROM MostRecentSeason)
-- AND PSBS.IsRegularSeason = 1
GROUP BY P.Id
ORDER BY TotalHomeRuns DESC;
