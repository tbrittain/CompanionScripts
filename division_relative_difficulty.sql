SELECT D.Name,
       S.Number                                                                                    as SeasonNumber,
       SUM(STH.Wins)                                                                               as Wins,
       SUM(STH.Losses)                                                                             as Losses,
       AVG(STH.Wins)                                                                               as AverageWins,
       SUM(STH.ExpectedWins)                                                                       as ExpectedWins,
       SUM(STH.ExpectedLosses)                                                                     as ExpectedLosses,
       AVG(STH.ExpectedWins)                                                                       as AverageExpectedWins,
       RANK() OVER (PARTITION BY STH.SeasonId ORDER BY SUM(STH.Wins) DESC, SUM(STH.Losses))        as SeasonRank,
       RANK() OVER (ORDER BY SUM(STH.Wins) DESC, SUM(STH.Losses))                                  as GlobalRank,
       JSON_GROUP_ARRAY(JSON_OBJECT('TeamName', TNH.Name, 'Wins', STH.Wins, 'Losses', STH.Losses)) as Teams
FROM Divisions D
         JOIN main.SeasonTeamHistory STH on D.Id = STH.DivisionId
         JOIN main.TeamNameHistory TNH on STH.TeamNameHistoryId = TNH.Id
         JOIN main.Seasons S on STH.SeasonId = S.Id
GROUP BY D.Name, S.Number
ORDER BY Wins DESC
