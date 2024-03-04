WITH
    MedianPassengerCount AS (
        SELECT
            PERCENTILE_CONT(passenger_count, 0.5) OVER () AS median_passenger_count
        FROM
            `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2023`
    ),
    TripsWithDates AS (
        SELECT
            vendor_id,
            pickup_datetime,
            dropoff_datetime,
            trip_distance,
            passenger_count
        FROM
            `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2023`
        WHERE
            pickup_datetime >= '2023-01-01'
            AND pickup_datetime < '2023-02-01'
            AND TIMESTAMP_DIFF (dropoff_datetime, pickup_datetime, DAY) >= 7
    )
SELECT DISTINCT
    vendor_id
FROM
    TripsWithDates
WHERE
    trip_distance > 300
    AND passenger_count > (
        SELECT
            median_passenger_count
        FROM
            MedianPassengerCount
    );