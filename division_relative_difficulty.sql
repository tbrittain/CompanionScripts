WITH DivisionRankings AS (SELECT D.Name,
                                 S.Number                                                                             AS SeasonNumber,
                                 SUM(STH.Wins)                                                                        AS Wins,
                                 SUM(STH.Losses)                                                                      AS Losses,
                                 AVG(STH.Wins)                                                                        AS AverageWins,
                                 SUM(STH.ExpectedWins)                                                                AS ExpectedWins,
                                 SUM(STH.ExpectedLosses)                                                              AS ExpectedLosses,
                                 AVG(STH.ExpectedWins)                                                                AS AverageExpectedWins,
                                 RANK() OVER (PARTITION BY STH.SeasonId ORDER BY SUM(STH.Wins) DESC, SUM(STH.Losses)) AS SeasonRank,
                                 RANK() OVER (ORDER BY SUM(STH.Wins) DESC, SUM(STH.Losses))                           AS GlobalRank,
                                 JSON_GROUP_ARRAY(JSON_OBJECT('TeamName', TNH.Name, 'Wins', STH.Wins, 'Losses',
                                                              STH.Losses))                                            AS Teams
                          FROM Divisions D
                                   JOIN main.SeasonTeamHistory STH ON D.Id = STH.DivisionId
                                   JOIN main.TeamNameHistory TNH ON STH.TeamNameHistoryId = TNH.Id
                                   JOIN main.Seasons S ON STH.SeasonId = S.Id
                          GROUP BY D.Name, S.Number)
SELECT *
FROM DivisionRankings
ORDER BY Wins DESC