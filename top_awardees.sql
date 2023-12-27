SELECT p.Id,
       P.FirstName || ' ' || P.LastName AS PlayerName,
       COUNT(PTH.Id)                    AS NumberOfTeams
FROM PlayerSeasons PS
         JOIN main.Players P on P.Id = PS.PlayerId
         JOIN PlayerTeamHistory PTH on PTH.PlayerSeasonId = PS.Id
WHERE PTH.SeasonTeamHistoryId IS NOT NULL
GROUP BY p.Id, PlayerName
ORDER BY NumberOfTeams DESC;
