SELECT p.Id,
       P.FirstName || ' ' || P.LastName AS PlayerName,
       S.Number                         AS SeasonNumber,
       PSBS.HomeRuns,
       PSBS.StolenBases,
       psgs.Power,
       psgs.Contact,
       psgs.Speed
FROM PlayerSeasonBattingStats PSBS
         JOIN main.PlayerSeasons PS on PS.Id = PSBS.PlayerSeasonId
         JOIN main.Players P on PS.PlayerId = P.Id
         JOIN Seasons S on PS.SeasonId = S.Id
         join main.PlayerSeasonGameStats PSGS on PS.Id = PSGS.PlayerSeasonId
WHERE PSBS.IsRegularSeason = 1
  AND PSBS.HomeRuns >= 30
  AND PSBS.StolenBases >= 30
ORDER BY PSBS.HomeRuns DESC,
         PSBS.StolenBases DESC;