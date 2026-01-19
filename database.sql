DROP TABLE IF EXISTS homicide_data;
CREATE TABLE homicide_data (
    record_id TEXT,
    agency_code TEXT,      -- We include this so the 'conveyor belt' doesn't skip
    agency_name TEXT,
    agency_type TEXT,
    city TEXT,
    state TEXT,
    year INT,
    month TEXT,
    incident INT,
    crime_type TEXT,
    crime_solved TEXT,
    victim_sex TEXT,
    victim_age INT,
    victim_race TEXT,
    victim_ethnicity TEXT,
    perpetrator_sex TEXT,
    perpetrator_age TEXT,
    perpetrator_race TEXT,
    perpetrator_ethnicity TEXT,
    relationship TEXT,
    weapon TEXT,
    victim_count INT,
    perpetrator_count INT,
    record_source TEXT,
    -- Our map slots (Keep these at the end)
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    geom GEOMETRY(Point, 4326)
);

COPY homicide_data(record_id, agency_code, agency_name, agency_type, city, state, year, month, incident, crime_type, crime_solved, victim_sex, victim_age, victim_race, victim_ethnicity, perpetrator_sex, perpetrator_age, perpetrator_race, perpetrator_ethnicity, relationship, weapon, victim_count, perpetrator_count, record_source)
FROM 'C:\Users\Public\Documents\US_Crime_DataSet.csv' 
DELIMITER ',' 
CSV HEADER;

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'homicide_data';

SELECT COUNT(*) FROM homicide_data;

UPDATE homicide_data 
SET perpetrator_age = NULL 
WHERE perpetrator_age = ' ' OR perpetrator_age = '0';