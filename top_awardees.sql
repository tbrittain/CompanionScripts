SELECT p.Id,
       P.FirstName || ' ' || P.LastName AS PlayerName,
       COUNT(PA.Id)                     AS NumAwards,
       COUNT(PA.Id) FILTER (WHERE PA.Importance IN (0, 1)) AS NumMajorAwards,
         COUNT(PA.Id) FILTER (WHERE PA.OriginalName = 'All-Star') AS NumAllStarAwards,
       JSON_GROUP_ARRAY(PA.OriginalName)        AS Awards
FROM PlayerSeasons PS
         JOIN main.Players P on P.Id = PS.PlayerId
         JOIN main.PlayerAwardPlayerSeason PAPS on PS.Id = PAPS.PlayerSeasonsId
         JOIN main.PlayerAwards PA on PAPS.AwardsId = PA.Id
GROUP BY p.Id, PlayerName
ORDER BY NumAwards DESC;
