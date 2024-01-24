-- note that this doesn't mean literal transactions since SMB4 doesn't have player trading.
-- instead, this is just the count of players who are on team A and move to play for team B directly after.
WITH TeamHistories AS (SELECT *
                       FROM PlayerTeamHistory PTH
                       WHERE PTH.SeasonTeamHistoryId IS NOT NULL),
     NumTeamHistories AS (SELECT PlayerSeasonId,
                                 COUNT(*) AS NumHistories
                          FROM TeamHistories TH
                          GROUP BY TH.PlayerSeasonId),
     MultiTeamSeasons AS (SELECT *
                          FROM NumTeamHistories NTH
                          WHERE NTH.NumHistories > 1),
     Transactions AS (SELECT MTS.PlayerSeasonId,
                             PTH2."Order"                                 AS "Order",
                             CASE WHEN PTH2."Order" = 1 THEN TNH.Name END AS "From",
                             CASE WHEN PTH2."Order" = 2 THEN TNH.Name END AS "To"
                      FROM MultiTeamSeasons MTS
                               JOIN PlayerTeamHistory PTH2 ON MTS.PlayerSeasonId = PTH2.PlayerSeasonId
                               JOIN main.SeasonTeamHistory STH ON PTH2.SeasonTeamHistoryId = STH.Id
                               JOIN main.TeamNameHistory TNH ON STH.TeamNameHistoryId = TNH.Id),
     FlattenedTransactions AS (SELECT T.PlayerSeasonId,
                                      MAX(T."From") AS "From",
                                      MAX(T."To")   AS "To"
                               FROM Transactions T
                               GROUP BY T.PlayerSeasonId),
     FinalInSeasonTransactions AS (SELECT FT."From" AS FromTeam,
                                          FT."To"   AS ToTeam,
                                          COUNT(*)  AS NumTransactions
                                   FROM FlattenedTransactions FT
                                   GROUP BY FT."From",
                                            FT."To"),
     InterSeasonPlayerHistory AS (SELECT P.Id,
                                         P.FirstName || ' ' || P.LastName AS PlayerName,
                                         PS.Id                            AS PlayerSeasonId,
                                         PS.SeasonId,
                                         TH.Id,
                                         TH."Order",
                                         T.Id,
                                         TNH.Name
                                  FROM TeamHistories TH
                                           JOIN SeasonTeamHistory STH ON TH.SeasonTeamHistoryId = STH.Id
                                           JOIN Teams T ON STH.TeamId = T.Id
                                           JOIN TeamNameHistory TNH ON STH.TeamNameHistoryId = TNH.Id
                                           JOIN PlayerSeasons PS ON TH.PlayerSeasonId = PS.Id
                                           JOIN Players P ON PS.PlayerId = P.Id),
     InterSeasonTransactions AS (SELECT IST.*,
                                        LAG(IST.Name) OVER (PARTITION BY IST.PlayerName ORDER BY IST.SeasonId) AS FromTeam,
                                        IST.Name                                                               AS ToTeam
                                 FROM InterSeasonPlayerHistory IST),
     FlattenedInterSeasonTransactions AS (SELECT IST.PlayerSeasonId,
                                                 IST.FromTeam,
                                                 IST.ToTeam
                                          FROM InterSeasonTransactions IST
                                          WHERE IST.FromTeam != IST.ToTeam
                                            AND IST.FromTeam IS NOT NULL
                                            AND IST.ToTeam IS NOT NULL),
     FinalInterSeasonTransactions AS (SELECT FIT.FromTeam,
                                             FIT.ToTeam,
                                             COUNT(*) AS NumTransactions
                                      FROM FlattenedInterSeasonTransactions FIT
                                      GROUP BY FIT.FromTeam,
                                               FIT.ToTeam)
SELECT FIST.FromTeam,
       FIST.ToTeam,
       FIST.NumTransactions + COALESCE(FIST2.NumTransactions, 0) AS NumTransactions
FROM FinalInSeasonTransactions FIST
         LEFT JOIN FinalInterSeasonTransactions FIST2 ON FIST.FromTeam = FIST2.FromTeam
    AND FIST.ToTeam = FIST2.ToTeam
UNION
SELECT FIST2.FromTeam,
       FIST2.ToTeam,
       FIST2.NumTransactions
FROM FinalInterSeasonTransactions FIST2
         LEFT JOIN FinalInSeasonTransactions FIST ON FIST.FromTeam = FIST2.FromTeam
    AND FIST.ToTeam = FIST2.ToTeam
WHERE FIST.FromTeam IS NULL
  AND FIST.ToTeam IS NULL
ORDER BY NumTransactions DESC;