SELECT p.Id,
       P.FirstName || ' ' || P.LastName AS PlayerName,
       S.Number                         AS SeasonNumber,
       PSBS.AtBats,
       PSBS.Hits,
       PSBS.BattingAverage,
       PSBS.HomeRuns,
       PSBS.HomeRuns / CAST(PSBS.Hits AS FLOAT)        AS HomeRunToHitRatio,
         PSBS.HomeRuns / CAST(PSBS.Hits AS FLOAT) / PSBS.BattingAverage AS HighHrLowAvgRatio
FROM PlayerSeasonBattingStats PSBS
         JOIN main.PlayerSeasons PS on PS.Id = PSBS.PlayerSeasonId
         JOIN main.Players P on PS.PlayerId = P.Id
         JOIN Seasons S on PS.SeasonId = S.Id
         JOIN main.PlayerSeasonGameStats PSGS ON PS.Id = PSGS.PlayerSeasonId
WHERE PSBS.IsRegularSeason = 1
AND PSBS.PlateAppearances > 3.1 * 162 -- qualified for 162 game season
ORDER BY HighHrLowAvgRatio DESC