WITH AllTraits AS (SELECT T.Id, T.Name
                   FROM main.Traits T
                   WHERE T.IsSmb3 = 0),
     SeasonsWithTrait AS (SELECT *, T.Name AS TraitName
                          FROM main.PlayerSeasonPitchingStats PSPS
                                   JOIN main.PlayerSeasons PS ON PS.Id = PSPS.PlayerSeasonId
                                   JOIN main.PlayerSeasonTrait PST ON PS.Id = PST.PlayerSeasonsId
                                   JOIN AllTraits T ON PST.TraitsId = T.Id
                                   JOIN main.Players P ON P.Id = PS.PlayerId
                          WHERE PSPS.IsRegularSeason = 1),
     SeasonsWithoutTrait AS (SELECT *
                             FROM main.PlayerSeasonPitchingStats PSPS
                                      JOIN main.PlayerSeasons PS ON PS.Id = PSPS.PlayerSeasonId
                                      JOIN main.Players P ON P.Id = PS.PlayerId
                             WHERE PS.Id NOT IN (SELECT PlayerSeasonsId
                                                 FROM main.PlayerSeasonTrait PST
                                                          JOIN AllTraits T ON PST.TraitsId = T.Id)
                               AND PSPS.IsRegularSeason = 1),
     Results AS (SELECT TraitName,
                        Type,
                        AVG(AvgEraPlus) AS AvgEraPlus,
                        SUM(NumSeasons) AS NumSeasons,
                        AVG(AvgInningsPitched) AS AvgInningsPitched
                 FROM (SELECT TraitName,
                              'With Trait'                     AS Type,
                              AVG(SeasonsWithTrait.EraMinus)    AS AvgEraPlus,
                              COUNT(SeasonsWithTrait.PlayerId) AS NumSeasons,
                              AVG(SeasonsWithTrait.InningsPitched)     AS AvgInningsPitched
                       FROM SeasonsWithTrait
                       GROUP BY TraitName
                       UNION ALL
                       SELECT NULL                                AS TraitName,
                              'Without Trait'                     AS Type,
                              AVG(SeasonsWithoutTrait.EraMinus)    AS AvgEraPlus,
                              COUNT(SeasonsWithoutTrait.PlayerId) AS NumSeasons,
                              AVG(SeasonsWithoutTrait.InningsPitched)     AS AvgInningsPitched
                       FROM SeasonsWithoutTrait
                       GROUP BY TraitName) AS CombinedResults
                 GROUP BY TraitName, Type)
SELECT *,
       AvgEraPlus - (SELECT AvgEraPlus
                     FROM Results
                     WHERE Type = 'Without Trait') AS EraPlusDiffFromNoTrait,
       RANK() OVER (ORDER BY NumSeasons DESC)      AS TraitFrequencyRank
FROM Results
ORDER BY EraPlusDiffFromNoTrait DESC
