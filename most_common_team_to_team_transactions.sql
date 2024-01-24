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
                               GROUP BY T.PlayerSeasonId)

SELECT FT."From" AS FromTeam,
       FT."To"   AS ToTeam,
       COUNT(*)  AS NumTransactions
FROM FlattenedTransactions FT
GROUP BY FT."From",
         FT."To"
ORDER BY NumTransactions DESC