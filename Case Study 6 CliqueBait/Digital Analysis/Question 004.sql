-- What is the number of events for each event type?

SELECT
    event_name,
    events.event_type,
    COUNT(*) AS total_events
FROM events
JOIN event_identifier 
ON events.event_type = event_identifier.event_type
GROUP BY event_name, events.event_type
