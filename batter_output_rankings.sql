SELECT OpsPlusRange,
       AVG(OpsPlus) AS AvgOpsPlus,
       AVG(Obp)     AS AvgObp,
       MIN(Obp)     AS MinObp,
       MAX(Obp)     AS MaxObp,
       AVG(Slg)     AS AvgSlg,
       MIN(Slg)     AS MinSlg,
       MAX(Slg)     AS MaxSlg,
       AVG(Power)   AS Power,
       AVG(Contact) AS Contact,
       AVG(Speed)   AS Speed,
       COUNT(*) AS COUNT
FROM (SELECT CASE
    WHEN PSBS.OpsPlus BETWEEN 0 AND 90 THEN '0-90'
    WHEN PSBS.OpsPlus BETWEEN 90 AND 100 THEN '90-100'
    WHEN PSBS.OpsPlus BETWEEN 100 AND 110 THEN '100-110'
    WHEN PSBS.OpsPlus BETWEEN 110 AND 120 THEN '110-120'
    WHEN PSBS.OpsPlus BETWEEN 120 AND 130 THEN '120-130'
    WHEN PSBS.OpsPlus BETWEEN 130 AND 140 THEN '130-140'
    WHEN PSBS.OpsPlus BETWEEN 140 AND 150 THEN '140-150'
    WHEN PSBS.OpsPlus BETWEEN 150 AND 160 THEN '150-160'
    WHEN PSBS.OpsPlus >= 160 THEN '160+'
    ELSE 'Unknown'
    END AS OpsPlusRange, PSBS.OpsPlus, PSBS.Obp, PSBS.Slg, PSGS.Power, PSGS.Contact, PSGS.Speed
    FROM PlayerSeasonBattingStats PSBS
    JOIN main.PlayerSeasons PS ON PSBS.PlayerSeasonId = PS.Id
    JOIN main.PlayerSeasonGameStats PSGS ON PS.Id = PSGS.PlayerSeasonId
    LEFT JOIN main.PlayerSeasonTrait PST ON PS.Id = PST.PlayerSeasonsId
    LEFT JOIN main.Traits T ON PST.TraitsId = T.Id
    WHERE PSBS.IsRegularSeason = 1
    AND PSBS.PlateAppearances >= 3.1 * 160 -- qualified
    AND psbs.OpsPlus IS NOT NULL)
GROUP BY OpsPlusRange
ORDER BY AvgOpsPlus DESC;
