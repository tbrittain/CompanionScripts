SELECT P.Id,
       P.FirstName || ' ' || P.LastName AS PlayerName,
       COUNT(PTH.Id)                    AS NumberOfTeams
FROM PlayerSeasons PS
         JOIN main.Players P ON P.Id = PS.PlayerId
         JOIN PlayerTeamHistory PTH ON PTH.PlayerSeasonId = PS.Id
WHERE PTH.SeasonTeamHistoryId IS NOT NULL
GROUP BY P.Id, PlayerName
ORDER BY NumberOfTeams DESC;
