WITH AllTraits AS (
    SELECT T.Id, T.Name
    FROM main.Traits T
    WHERE T.IsSmb3 = 0
),
SeasonsWithTrait AS (
    SELECT *
    FROM main.PlayerSeasonBattingStats PSBS
    JOIN main.PlayerSeasons PS ON PS.Id = PSBS.PlayerSeasonId
    JOIN main.PlayerSeasonTrait PST ON PS.Id = PST.PlayerSeasonsId
    JOIN AllTraits T ON PST.TraitsId = T.Id
    JOIN main.Players P ON P.Id = PS.PlayerId
    WHERE P.PitcherRoleId IS NULL
),
SeasonsWithoutTrait AS (
    SELECT *
    FROM main.PlayerSeasonBattingStats PSBS
    JOIN main.PlayerSeasons PS ON PS.Id = PSBS.PlayerSeasonId
    LEFT JOIN main.PlayerSeasonTrait PST ON PS.Id = PST.PlayerSeasonsId
    LEFT JOIN AllTraits T ON PST.TraitsId = T.Id
    JOIN main.Players P ON P.Id = PS.PlayerId
    WHERE T.Id IS NULL -- Filtering out the rows where the trait is not present
    AND P.PitcherRoleId IS NULL
)
SELECT AllTraits.Name AS TraitName,
       CASE WHEN SeasonsWithTrait.PlayerSeasonId IS NOT NULL THEN 1 ELSE 0 END AS WithTrait,
       AVG(COALESCE(SeasonsWithTrait.OpsPlus, SeasonsWithoutTrait.OpsPlus)) AS AvgOpsPlus,
       COUNT(COALESCE(SeasonsWithTrait.PlayerSeasonId, SeasonsWithoutTrait.PlayerSeasonId)) AS NumSeasons,
       AVG(COALESCE(SeasonsWithTrait.AtBats, SeasonsWithoutTrait.AtBats)) AS AvgAtBats
FROM AllTraits
LEFT JOIN SeasonsWithTrait ON AllTraits.Name = SeasonsWithTrait.Name
LEFT JOIN SeasonsWithoutTrait ON AllTraits.Name = SeasonsWithoutTrait.Name
GROUP BY TraitName, WithTrait
ORDER BY AvgOpsPlus DESC

