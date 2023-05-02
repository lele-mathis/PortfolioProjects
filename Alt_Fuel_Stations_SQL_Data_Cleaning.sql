--Cleaning data on alternative fuel stations using queries in SQL Server 
--Data from https://afdc.energy.gov/data_download

--Initial query to take a look at the data
SELECT * FROM dbo.alt_fuel_stations

--Since this data set has many extra columns not relevant to the analysis I want to do,
--I am making a new table containing only the desired columns about station's type, location, and access
SELECT ID, Fuel_type_code, Station_Name, City, State, ZIP, Country, Status_Code, Access_Code, Facility_Type 
    INTO dbo.alt_fuel_stations_clean 
    FROM dbo.alt_fuel_stations

--Replacing null Facility_Type values with "Unknown"
UPDATE dbo.alt_fuel_stations_clean
SET Facility_Type = COALESCE(Facility_Type,'Unknown')

--Making a new column for the full name of the status based on the code
ALTER TABLE dbo.alt_fuel_stations_clean
ADD Status NVARCHAR(255);

--Filling the new column written out descriptions of the station status for increased readability
UPDATE dbo.alt_fuel_stations_clean
SET Status = 
    CASE  WHEN Status_Code = 'E' THEN 'Available'
          WHEN Status_Code = 'P' THEN 'Planned'
          ELSE 'Temporarily Unavailable'
          END

--Making a new column for the full name of the fuel type
ALTER TABLE dbo.alt_fuel_stations_clean
ADD Fuel_Type NVARCHAR(255);

--Filling the new column with the fuel type description from the dataset documentation
UPDATE dbo.alt_fuel_stations_clean
SET Fuel_type = CASE WHEN Fuel_type_code = 'BD' THEN 'Biodiesel (B20 and above)'
    WHEN Fuel_type_code = 'CNG' THEN 'Compressed Natural Gas'
    WHEN Fuel_type_code = 'ELEC' THEN 'Electric'
    WHEN Fuel_type_code = 'E85' THEN 'Ethanol (E85)'
    WHEN Fuel_type_code = 'HY' THEN 'Hydrogen'
    WHEN Fuel_type_code = 'LNG' THEN 'Liquefied Natural Gas'
    WHEN Fuel_type_code = 'LPG' THEN 'Propane (LPG)'
    WHEN Fuel_type_code = 'RD' THEN 'Renewable Diesel (R20 and above)'
    END

--Removing underscores from facility type and making lowercase to increase readability
UPDATE dbo.alt_fuel_stations_clean
SET Facility_Type = REPLACE(LOWER(Facility_Type), '_', ' ')

--Checking to make sure the data look good
SELECT * FROM dbo.alt_fuel_stations_clean