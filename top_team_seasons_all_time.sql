SELECT TNH.Name, STH.*
FROM SeasonTeamHistory STH
         JOIN TeamNameHistory TNH ON STH.TeamNameHistoryId = TNH.Id
-- WHERE STH.PlayoffWins = (SELECT max(STH2.PlayoffWins) FROM SeasonTeamHistory STH2)
ORDER BY STH.Wins DESC, STH.PlayoffWins DESC