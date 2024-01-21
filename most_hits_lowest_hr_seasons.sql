SELECT P.Id,
       P.FirstName || ' ' || P.LastName AS PlayerName,
       S.Number                         AS SeasonNumber,
       PSBS.AtBats,
       PSBS.Hits,
       PSBS.HomeRuns,
       PSBS.Hits / PSBS.HomeRuns        AS Ratio
FROM PlayerSeasonBattingStats PSBS
         JOIN main.PlayerSeasons PS ON PS.Id = PSBS.PlayerSeasonId
         JOIN main.Players P ON PS.PlayerId = P.Id
         JOIN Seasons S ON PS.SeasonId = S.Id
         JOIN main.PlayerSeasonGameStats PSGS ON PS.Id = PSGS.PlayerSeasonId
WHERE PSBS.IsRegularSeason = 1
ORDER BY Ratio DESC