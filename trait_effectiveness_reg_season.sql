WITH SeasonsWithTrait AS (SELECT *
                          FROM main.PlayerSeasonBattingStats PSBS
                                   JOIN main.PlayerSeasons PS ON PS.Id = PSBS.PlayerSeasonId
                                   JOIN main.PlayerSeasonTrait PST ON PS.Id = PST.PlayerSeasonsId
                                   JOIN main.Traits T ON PST.TraitsId = T.Id
                          WHERE T.Name = 'Ace Exterminator'
                            AND PSBS.AtBats > 50),
     SeasonsWithoutTrait AS (SELECT *
                             FROM main.PlayerSeasonBattingStats PSBS
                                      JOIN main.PlayerSeasons PS ON PS.Id = PSBS.PlayerSeasonId
                             WHERE PS.Id NOT IN (SELECT PlayerSeasonsId
                                                 FROM main.PlayerSeasonTrait PST
                                                          JOIN main.Traits T ON PST.TraitsId = T.Id
                                                 WHERE T.Name = 'Ace Exterminator')
                               AND PSBS.AtBats > 50)
SELECT 'With Trait' AS Type, AVG(SeasonsWithTrait.OpsPlus) AS OpsPlus, COUNT(SeasonsWithTrait.PlayerSeasonId) AS Num
FROM SeasonsWithTrait
UNION ALL
SELECT 'Without Trait'                           AS Type,
       AVG(SeasonsWithoutTrait.OpsPlus)          AS OpsPlus,
       COUNT(SeasonsWithoutTrait.PlayerSeasonId) AS Num
FROM SeasonsWithoutTrait;
