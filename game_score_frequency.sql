WITH Games AS (SELECT *
               FROM TeamSeasonSchedules
               UNION ALL
               SELECT *
               FROM TeamPlayoffSchedules)
SELECT HomeScore,
       AwayScore,
       COUNT(*) AS NumGames
FROM Games
GROUP BY HomeScore,
         AwayScore
ORDER BY NumGames DESC,
         HomeScore,
         AwayScore