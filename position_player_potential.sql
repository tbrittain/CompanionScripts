SELECT p.Id,
       P.FirstName || ' ' || P.LastName                                    AS PlayerName,
       S.Number                                                            AS SeasonNumber,
       PSBS.HomeRuns,
       PSBS.RunsBattedIn,
       PSBS.Ops,
       PSBS.OpsPlus,
       PSBS.AtBats,
       PSBS.OpsPlus * PSBS.AtBats                                          AS WeightedOps,
       PSGS.Contact + PSGS.Power + PSGS.Speed + PSGS.Fielding + PSGS.Arm   AS TotalGameStats,
       (PSGS.Contact + PSGS.Power + PSGS.Speed + PSGS.Fielding + PSGS.Arm) /
       (CAST(99 * 5 AS REAL))                                              AS PotentialGameStats,
       (PSBS.OpsPlus * PSBS.AtBats) *
       (PSGS.Contact + PSGS.Power + PSGS.Speed + PSGS.Fielding + PSGS.Arm) AS TotalWeighted,
       PSGS.*
FROM PlayerSeasonBattingStats PSBS
         JOIN PlayerSeasons PS on PS.Id = PSBS.PlayerSeasonId
         JOIN main.Players P on P.Id = PS.PlayerId
         JOIN main.Seasons S ON PS.SeasonId = S.Id
         JOIN PlayerSeasonGameStats PSGS ON PS.Id = PSGS.PlayerSeasonId
WHERE PSBS.IsRegularSeason = 1
ORDER BY TotalWeighted DESC