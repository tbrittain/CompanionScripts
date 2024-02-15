WITH Games AS (SELECT *
               FROM TeamSeasonSchedules
               UNION ALL
               SELECT *
               FROM TeamPlayoffSchedules),
     HomeWins AS (SELECT COUNT(*)                   AS HomeWins,
                         AVG(HomeScore - AwayScore) AS HomeMargin
                  FROM Games
                  WHERE HomeScore > AwayScore),
     AwayWins AS (SELECT COUNT(*)                   AS AwayWins,
                         AVG(AwayScore - HomeScore) AS AwayMargin
                  FROM Games
                  WHERE HomeScore < AwayScore)
SELECT HomeWins,
       AwayWins,
       HomeMargin AS HomeTeamMarginOfVictory,
       AwayMargin AS AwayTeamMarginOfVictory
FROM HomeWins,
     AwayWins;
