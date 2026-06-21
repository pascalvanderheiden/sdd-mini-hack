CREATE SCHEMA IF NOT EXISTS climate;

-- 1. CO2 emissions (source A)
CREATE TABLE climate.co2_emissions (
    id SERIAL PRIMARY KEY,
    iso_code VARCHAR(3),
    year INTEGER,
    country VARCHAR(255),
    co2 NUMERIC,
    co2_per_capita NUMERIC,
    gdp NUMERIC,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Population (source B)
CREATE TABLE climate.population (
    id SERIAL PRIMARY KEY,
    iso_code VARCHAR(3),
    country_name VARCHAR(255),
    year INTEGER,
    value BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Materialized join (computed metrics)
CREATE TABLE climate.country_metrics (
    id SERIAL PRIMARY KEY,
    iso_code VARCHAR(3),
    country_name VARCHAR(255),
    year INTEGER,
    co2_mt NUMERIC,
    population BIGINT,
    co2_per_capita_check NUMERIC,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for join queries
CREATE INDEX idx_co2_iso_year ON climate.co2_emissions(iso_code, year);
CREATE INDEX idx_pop_iso_year ON climate.population(iso_code, year);
CREATE INDEX idx_metrics_iso_year ON climate.country_metrics(iso_code, year);
