SELECT STH.PlayoffSeed,
       SUM(CASE WHEN CW.Id IS NOT NULL THEN 1 ELSE 0 END)                           AS Championships,
       SUM(CASE WHEN CW.Id IS NOT NULL THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT) AS ChampionshipPercentage,
       SUM(STH.PlayoffWins)                                                         AS PlayoffWins,
       SUM(STH.PlayoffLosses)                                                       AS PlayoffLosses,
       SUM(STH.PlayoffRunsScored)                                                   AS PlayoffRunsScored,
       SUM(STH.PlayoffRunsAllowed)                                                  AS PlayoffRunsAllowed
FROM SeasonTeamHistory STH
         LEFT JOIN main.ChampionshipWinners CW ON STH.Id = CW.SeasonTeamHistoryId
WHERE STH.PlayoffSeed IS NOT NULL
GROUP BY STH.PlayoffSeed