SELECT p.Id,
       P.FirstName || ' ' || P.LastName AS PlayerName,
       SUM(PSPS.InningsPitched)         AS InningsPitched,
       SUM(PSPS.Wins)                   AS Wins,
       SUM(PSPS.Losses)                 AS Losses,
       AVG(PSPS.EarnedRunAverage)       AS EarnedRunAverage
FROM PlayerSeasonPitchingStats PSPS
         JOIN main.PlayerSeasons PS on PS.Id = PSPS.PlayerSeasonId
         JOIN main.Players P on P.Id = PS.PlayerId
         JOIN main.Seasons S ON PS.SeasonId = S.Id
WHERE P.PitcherRoleId IS NULL
GROUP BY p.Id, PlayerName
ORDER BY InningsPitched DESC;
