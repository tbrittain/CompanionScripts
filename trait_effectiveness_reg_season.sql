WITH AllTraits AS (SELECT T.Id, T.Name
                   FROM main.Traits T
                   WHERE T.IsSmb3 = 0),
     SeasonsWithTrait AS (SELECT *, T.Name AS TraitName
                          FROM main.PlayerSeasonBattingStats PSBS
                                   JOIN main.PlayerSeasons PS ON PS.Id = PSBS.PlayerSeasonId
                                   JOIN main.PlayerSeasonTrait PST ON PS.Id = PST.PlayerSeasonsId
                                   JOIN AllTraits T ON PST.TraitsId = T.Id
                                   JOIN main.Players P ON P.Id = PS.PlayerId
                          WHERE PSBS.IsRegularSeason = 1),
     SeasonsWithoutTrait AS (SELECT *
                             FROM main.PlayerSeasonBattingStats PSBS
                                      JOIN main.PlayerSeasons PS ON PS.Id = PSBS.PlayerSeasonId
                                      JOIN main.Players P ON P.Id = PS.PlayerId
                             WHERE PS.Id NOT IN (SELECT PlayerSeasonsId
                                                 FROM main.PlayerSeasonTrait PST
                                                          JOIN AllTraits T ON PST.TraitsId = T.Id)
                               AND PSBS.IsRegularSeason = 1),
     Results AS (SELECT TraitName,
                        Type,
                        AVG(AvgOpsPlus) AS AvgOpsPlus,
                        SUM(NumSeasons) AS NumSeasons,
                        AVG(AvgAtBats)  AS AvgAtBats
                 FROM (SELECT TraitName,
                              'With Trait'                     AS Type,
                              AVG(SeasonsWithTrait.OpsPlus)    AS AvgOpsPlus,
                              COUNT(SeasonsWithTrait.PlayerId) AS NumSeasons,
                              AVG(SeasonsWithTrait.AtBats)     AS AvgAtBats
                       FROM SeasonsWithTrait
                       GROUP BY TraitName
                       UNION ALL
                       SELECT NULL                                AS TraitName,
                              'Without Trait'                     AS Type,
                              AVG(SeasonsWithoutTrait.OpsPlus)    AS AvgOpsPlus,
                              COUNT(SeasonsWithoutTrait.PlayerId) AS NumSeasons,
                              AVG(SeasonsWithoutTrait.AtBats)     AS AvgAtBats
                       FROM SeasonsWithoutTrait
                       GROUP BY TraitName) AS CombinedResults
                 GROUP BY TraitName, Type)
SELECT *,
       AvgOpsPlus - (SELECT AvgOpsPlus
                     FROM Results
                     WHERE Type = 'Without Trait') AS OpsPlusDiffFromNoTrait,
       RANK() OVER (ORDER BY NumSeasons DESC)      AS TraitFrequencyRank
FROM Results
ORDER BY OpsPlusDiffFromNoTrait DESC
