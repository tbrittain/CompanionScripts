-- This calculates the top dynasties on a per-team level. It currently only produces the top dynasty for each team,
-- but it could be modified in a way to produce multiple dynasties per team. It acts on a 10-season window.
WITH RawDynasties AS (SELECT T.Id,
                             SUM(STH.Wins)
                                 OVER (PARTITION BY T.Id ORDER BY STH.SeasonId ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)   AS TenSeasonWins,
                             SUM(STH.Losses)
                                 OVER (PARTITION BY T.Id ORDER BY STH.SeasonId ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)   AS TenSeasonLosses,
                             MIN(STH.SeasonId)
                                 OVER (PARTITION BY T.Id ORDER BY STH.SeasonId ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)   AS FirstSeasonId,
                             MAX(STH.SeasonId)
                                 OVER (PARTITION BY T.Id ORDER BY STH.SeasonId ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)   AS LastSeasonId,
                             SUM(STH.PlayoffWins)
                                 OVER (PARTITION BY T.Id ORDER BY STH.SeasonId ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)   AS TenSeasonPlayoffWins,
                             SUM(STH.PlayoffLosses)
                                 OVER (PARTITION BY T.Id ORDER BY STH.SeasonId ROWS BETWEEN 9 PRECEDING AND CURRENT ROW)   AS TenSeasonPlayoffLosses,
                             COUNT(CW.Id)
                                   OVER (PARTITION BY T.Id ORDER BY STH.SeasonId ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) AS TenSeasonChampionships
                      FROM SeasonTeamHistory STH
                               JOIN main.Teams T ON STH.TeamId = T.Id
                               LEFT JOIN main.ChampionshipWinners CW ON STH.Id = CW.SeasonTeamHistoryId
                      GROUP BY T.Id, STH.SeasonId),
     Dynasties AS (SELECT TNH.Name,
                          FirstSeason.Number                                            AS FirstSeason,
                          LastSeason.Number                                             AS LastSeason,
                          D.TenSeasonWins,
                          D.TenSeasonLosses,
                          D.TenSeasonWins * 1.0 / (D.TenSeasonWins + D.TenSeasonLosses) AS WinPercentage,
                          D.TenSeasonPlayoffWins,
                          D.TenSeasonPlayoffLosses,
                          D.TenSeasonChampionships,
                          ((D.TenSeasonWins * 1.0 / (D.TenSeasonWins + D.TenSeasonLosses)) * 0.3 +
                           (D.TenSeasonPlayoffWins * 1.0 / (D.TenSeasonPlayoffWins + D.TenSeasonPlayoffLosses)) * 0.2 +
                           D.TenSeasonChampionships * 0.5) / 5                          AS WeightedAverage
                   FROM RawDynasties D
                            JOIN main.Teams T ON D.Id = T.Id
                            JOIN main.SeasonTeamHistory STH ON T.Id = STH.TeamId AND STH.SeasonId = D.LastSeasonId
                            JOIN main.TeamNameHistory TNH ON STH.TeamNameHistoryId = TNH.Id
                            JOIN main.Seasons FirstSeason ON D.FirstSeasonId = FirstSeason.Id
                            JOIN main.Seasons LastSeason ON D.LastSeasonId = LastSeason.Id
                   WHERE D.LastSeasonId - D.FirstSeasonId = 9)
SELECT Name,
       FirstSeason,
       LastSeason,
       TenSeasonWins,
       TenSeasonLosses,
       WinPercentage,
       TenSeasonPlayoffWins,
       TenSeasonPlayoffLosses,
       TenSeasonChampionships,
       WeightedAverage
FROM (SELECT D.*,
             ROW_NUMBER() OVER (PARTITION BY Name ORDER BY WeightedAverage DESC) AS RowNumber
        FROM Dynasties D) AS D
WHERE RowNumber = 1
ORDER BY WeightedAverage DESC;

