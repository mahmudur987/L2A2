-- Active: 1747974892076@@Localhost@5432@assignment@public


CREATE Table rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    region Text
);

INSERT INTO rangers(name,region) VALUES
('Alice Green','Northern Hills'),
('Bob White','River Delta'),
('Carol King','Mountain Range');
CREATE Table species(
    species_id SERIAL PRIMARY key,
    common_name VARCHAR(50),
    scientific_name VARCHAR(50),
    discovery_date DATE,
    conservation_status VARCHAR(50)
);

INSERT INTO species ( common_name, scientific_name, discovery_date, conservation_status) VALUES
( 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
( 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
( 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
( 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');




CREATE Table sightings(
    sighting_id SERIAL PRIMARY KEY,
    species_id INTEGER REFERENCES species(species_id),
    ranger_id INTEGER REFERENCES rangers(ranger_id),
    location VARCHAR(200),
    sighting_time TIMESTAMP,
    notes TEXT
);
INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
( 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
( 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
( 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
( 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

DROP TABLE sightings;


-- problem 1

INSERT INTO rangers(name,region)VALUES('Derek Fox','Costal Plains');


-- problem 2


SELECT count(*) AS unique_species_count FROM(SELECT species_id FROM sightings GROUP BY species_id);

-- problem 3

SELECT *FROM sightings WHERE location LIKE '%Pass%';

-- problem 4


select name, count(sighting_id) as total_sightings from sightings JOIN rangers on sightings.ranger_id=rangers.ranger_id GROUP BY(name);



-- problem 5

select common_name from sightings RIGHT JOIN species on sightings.species_id=species.species_id WHERE location IS NULL;


-- problem 6


select * from sightings  JOIN species on sightings.species_id=species.species_id ;

select * from sightings JOIN rangers on sightings.ranger_id=rangers.ranger_id ;



SELECT common_name ,sighting_time ,name FROM  sightings INNER JOIN species on sightings.species_id=species.species_id INNER JOIN rangers on sightings.ranger_id=rangers.ranger_id ORDER BY sighting_time DESC LIMIT 2;
-- problem 7

SELECT * FROM species WHERE extract(year FROM discovery_date)<1800;


UPDATE species
SET conservation_status='Historic'
WHERE extract(year FROM discovery_date)<1800;

-- problem 8




CREATE or REPLACE FUNCTION update_time_name(sighting_time TIMESTAMP)
RETURNS TEXT
LANGUAGE plpgsql
AS
$$
BEGIN
RETURN CASE
WHEN EXTRACT(HOUR FROM sighting_time)<12 THEN 'morning'
WHEN 12<= EXTRACT(HOUR FROM sighting_time) AND EXTRACT(HOUR FROM sighting_time)<17 THEN 'afternoon'
ELSE 'evening'
END;
END;
$$;

SELECT update_time_name('2024-05-12 16:20:00');

SELECT sighting_id,update_time_name(sighting_time)  AS time_of_day
FROM sightings 
ORDER BY sighting_time ASC;


-- problem 9

DELETE from rangers WHERE name=(select name from sightings RIGHT OUTER JOIN rangers on sightings.ranger_id=rangers.ranger_id WHERE location is NULL );
