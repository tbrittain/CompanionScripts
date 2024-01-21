WITH PlayerStats AS (SELECT PSGS.PlayerSeasonId,
                            PSGS.Power + PSGS.Speed + PSGS.Contact +
                            COALESCE(PSGS.Arm, 0) + PSGS.Fielding +
                            COALESCE(PSGS.Velocity, 0) +
                            COALESCE(PSGS.Junk, 0) + COALESCE(PSGS.Accuracy, 0) AS TotalStats
                     FROM PlayerSeasonGameStats PSGS
                              JOIN main.PlayerSeasons PS ON PS.Id = PSGS.PlayerSeasonId),
     SeasonStats AS (SELECT P.FirstName || ' ' || P.LastName AS PlayerName,
                            S.Number                         AS SeasonNumber,
                            PlayerStats.TotalStats,
                            PS.PlayerId
                     FROM PlayerStats
                              JOIN PlayerSeasons PS ON PlayerStats.PlayerSeasonId = PS.Id
                              JOIN Players P ON PS.PlayerId = P.Id
                              JOIN Seasons S ON PS.SeasonId = S.Id)
SELECT SS1.PlayerName,
       SS1.SeasonNumber,
       CASE
           WHEN SS2.TotalStats IS NOT NULL THEN SS1.TotalStats - SS2.TotalStats
           END AS DifferenceFromPrevSeason,
       P2.PitcherRoleId
FROM SeasonStats SS1
         JOIN Players P2 ON SS1.PlayerId = P2.Id
         LEFT JOIN SeasonStats SS2 ON SS1.PlayerId = SS2.PlayerId AND SS1.SeasonNumber = SS2.SeasonNumber + 1
WHERE SS2.TotalStats IS NOT NULL
ORDER BY DifferenceFromPrevSeason DESC
