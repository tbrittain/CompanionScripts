WITH OpsRankings AS (SELECT S.Number                                  AS SeasonNumber,
                            AVG(PSBS.Ops)                             AS AverageOPS,
                            RANK() OVER (ORDER BY AVG(PSBS.Ops) DESC) AS Rank
                     FROM PlayerSeasonBattingStats PSBS
                              JOIN PlayerSeasons PS ON PSBS.PlayerSeasonId = PS.Id
                              JOIN Seasons S ON PS.SeasonId = S.Id
                              JOIN Players P ON PS.PlayerId = P.Id
                     WHERE PSBS.IsRegularSeason = 1
                       AND ABS(PSBS.OpsPlus - 100) <= 0.5
                       AND P.PitcherRoleId IS NULL
                     GROUP BY S.Number, PS.SeasonId),
     EraRankings AS (SELECT S.Number                                          AS SeasonNumber,
                            AVG(PSPS.EarnedRunAverage)                        AS AverageEra,
                            RANK() OVER (ORDER BY AVG(PSPS.EarnedRunAverage)) AS Rank
                     FROM PlayerSeasonPitchingStats PSPS
                              JOIN PlayerSeasons PS ON PSPS.PlayerSeasonId = PS.Id
                              JOIN Seasons S ON PS.SeasonId = S.Id
                              JOIN Players P ON PS.PlayerId = P.Id
                     WHERE PSPS.IsRegularSeason = 1
                       AND ABS(PSPS.EraMinus - 100) <= 0.5
                       AND P.PitcherRoleId IS NOT NULL
                     GROUP BY S.Number, PS.SeasonId)
SELECT ORS.SeasonNumber,
       ORS.AverageOPS,
       ORS.Rank      AS OpsRank,
       ER.AverageEra AS AverageERA,
       ER.Rank       AS EraRank
FROM OpsRankings ORS
         JOIN EraRankings ER ON ORS.SeasonNumber = ER.SeasonNumber
ORDER BY ORS.SeasonNumber;