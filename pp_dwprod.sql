-- PP Revenue; DWPROD aggregation

SET @start_date = '2017-02-01 00:00:00';
SET @end_date = '2017-03-02 00:00:00';

-- SET property;
-- SET account_manager;
-- SET advertiser;
-- SET campaign;
-- SET segment;
-- SET path;
-- SET source;

SELECT 

DATE(a.created_at_pst) `Date`,
a.placement `Position`,
c.name `Campaign`,
b.name `Segment`,
SUM(CASE WHEN a.event_type = 'i' THEN 1 ELSE 0 END) `Impressions`,
SUM(CASE WHEN a.event_type = 's' THEN 1 ELSE 0 END) `Skips`,
SUM(CASE WHEN a.event_type = 'cl' THEN 1 ELSE 0 END) `Clicks`,
SUM(CASE WHEN a.event_type = 'co' THEN 1 ELSE 0 END) `Conversions`,
SUM(a.revenue) `Revenue`

FROM

dwprod.dw_creative_events a
INNER JOIN dwprod.dw_offers_urls b
ON a.offer_url_id = b.id
INNER JOIN dwprod.dw_offers c
ON b.offer_id = c.id

WHERE

a.created_at_pst > @start_date
AND
a.created_at_pst < @end_date

GROUP BY 1,2,3,4
LIMIT 100000;
