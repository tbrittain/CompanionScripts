SELECT p.Id,
       P.FirstName || ' ' || P.LastName AS PlayerName,
       S.Number                         AS SeasonNumber,
       PSBS.AtBats,
       PSBS.Hits,
       PSBS.HomeRuns,
       PSBS.Hits / PSBS.HomeRuns        AS Ratio
FROM PlayerSeasonBattingStats PSBS
         JOIN main.PlayerSeasons PS on PS.Id = PSBS.PlayerSeasonId
         JOIN main.Players P on PS.PlayerId = P.Id
         JOIN Seasons S on PS.SeasonId = S.Id
         join main.PlayerSeasonGameStats PSGS on PS.Id = PSGS.PlayerSeasonId
WHERE PSBS.IsRegularSeason = 1
ORDER BY Ratio DESC