SELECT P.Id,
       P.FirstName || ' ' || P.LastName AS PlayerName,
       S.Number                         AS SeasonNumber,
       PSPS.InningsPitched,
       PSPS.EarnedRunAverage            AS ERA,
       PSPS.EraMinus                    AS "ERA-"
FROM PlayerSeasonPitchingStats PSPS
         JOIN main.PlayerSeasons PS ON PSPS.PlayerSeasonId = PS.Id
         JOIN main.Players P ON PS.PlayerId = P.Id
         JOIN main.Seasons S ON PS.SeasonId = S.Id
ORDER BY PSPS.InningsPitched DESC