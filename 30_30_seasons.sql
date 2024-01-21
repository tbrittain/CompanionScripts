SELECT P.Id,
       P.FirstName || ' ' || P.LastName AS PlayerName,
       S.Number                         AS SeasonNumber,
       PSBS.HomeRuns,
       PSBS.StolenBases,
       PSGS.Power,
       PSGS.Contact,
       PSGS.Speed
FROM PlayerSeasonBattingStats PSBS
         JOIN main.PlayerSeasons PS ON PS.Id = PSBS.PlayerSeasonId
         JOIN main.Players P ON PS.PlayerId = P.Id
         JOIN Seasons S ON PS.SeasonId = S.Id
         JOIN main.PlayerSeasonGameStats PSGS ON PS.Id = PSGS.PlayerSeasonId
WHERE PSBS.IsRegularSeason = 1
  AND PSBS.HomeRuns >= 30
  AND PSBS.StolenBases >= 30
ORDER BY PSBS.HomeRuns DESC,
         PSBS.StolenBases DESC;