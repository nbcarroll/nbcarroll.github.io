-- Use this Query When Assessing Alaska Airliens SEATAC Departures
SELECT
    aa.*,
    ar.`Name`, ar.`Year mfr`, ar.`CertIssueDate`, ar.`LastActivity Date`, ar.`Expiration Date`,
    pa.*
FROM (
    SELECT *, 
        SUBSTRING(`Tail Number`, 2) AS `Tail_Number_Extract` -- 'Tail Number' starts, with an N, so this gets rid of that
    FROM alaska_air_seatac_departure_2015_to_2023
) AS aa
LEFT JOIN aircraft_registration_2015 ar 
    ON aa.`Tail_Number_Extract` = ar.`N-Number`
    AND DATE(ar.`Expiration Date`) < STR_TO_DATE(aa.`DATE (MM/DD/YYYY)`, '%m/%d/%Y') -- Aircraft Registration Does Not Expire before the flight date
    AND STR_TO_DATE(aa.`DATE (MM/DD/YYYY)`, '%m/%d/%Y') > DATE(ar.`CertIssueDate`) -- Flight Date is after the Aircraft has been Certified
JOIN `processed_aircraft_registration_model_details_2015` pa
    ON ar.AircraftMFRModelCode = pa.`MFR-MDL-CODE`;

-- We can see some that Wells Fargo has the most planes... interesting...
-- "Banks have an interesting relationship with the aviation industry, including owning more aircraft than the seven biggest carriers globally." - International Business Times
SELECT NAME, COUNT(`N-Number`)
FROM aircraft_registration_2015 ar
-- WHERE `N-Number` LIKE '%AK%' 
   -- OR `N-Number` LIKE '%VA%'
   -- OR `N-Number` LIKE '%AS%'
GROUP BY 1
ORDER BY 2 DESC;

-- Seeing More Alaska Flights
SELECT NAME, COUNT(`N-Number`)
FROM aircraft_registration_2015 ar
WHERE `N-Number` LIKE '%AS%' 
GROUP BY 1 ORDER BY 2 DESC;

-- ID Edge Cases AKA Alaska is found under name identifiers not in N-Code.. looks like there are none
SELECT NAME, COUNT(`N-Number`)
FROM aircraft_registration_2015 ar
WHERE (NAME LIKE '%ALASKA AIR%')
  AND (`N-Number` NOT LIKE '%AK%' 
       AND `N-Number` NOT LIKE '%VA%'
       AND `N-Number` NOT LIKE '%AS%')
GROUP BY NAME
ORDER BY COUNT(`N-Number`) DESC;

-- Interestingly, it seems like there are slight variations of 'DELTA AIR LINES INC'
SELECT NAME, COUNT(`N-Number`)
FROM aircraft_registration_2015 ar
WHERE (NAME LIKE '%DELTA AIR%')
GROUP BY 1;

-- Now we can see all of planes found in Delta's Fleet
SELECT
	NAME, `N-Number`,
    -- AircraftMFRModelCode, `MFR-MDL-CODE`, -- verifying join done accurately
    `MFR-NAME`,`MODEL-NAME`, CertIssueDate, `Expiration Date`
FROM aircraft_registration_2015 ar
JOIN `processed_aircraft_registration_model_details_2015` pa
ON ar.AircraftMFRModelCode = pa.`MFR-MDL-CODE`
WHERE NAME LIKE '%DELTA AIR LINES%'
ORDER BY `Expiration Date`;

-- Now we can see all of THE TYPES of planes found in Delta's Fleet
SELECT
	-- NAME, `N-Number`,
    -- AircraftMFRModelCode, `MFR-MDL-CODE`, -- verifying join done accurately
    `MFR-NAME`,COUNT(`MODEL-NAME`) as Total_Planes_In_Fleet
    -- CertIssueDate, `Expiration Date`, `TYPE-AIRCRAFT`
FROM aircraft_registration_2015 ar
JOIN `processed_aircraft_registration_model_details_2015` pa
ON ar.AircraftMFRModelCode = pa.`MFR-MDL-CODE`
WHERE NAME LIKE '%DELTA AIR LINES%'
GROUP BY 1
ORDER BY 2 DESC;

-- Now let's look at the flights table
SELECT a.AIRLINE, COUNT(`TAIL_NUMBER`) AS total_active_planes
FROM flights f
LEFT JOIN airlines a ON f.AIRLINE = a.`IATA_CODE`
GROUP BY 1
ORDER BY 2 DESC


