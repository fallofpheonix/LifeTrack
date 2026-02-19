# Interview Questions

## Architecture
1. Explain the end-to-end data flow from UI action to persistent storage.
2. Why use `LifeTrackStore` with Riverpod instead of only one state framework?
3. How is feature modularity enforced in this repository?

## Reliability and Offline
1. How does offline-first behavior work for logging flows?
2. What conflict strategy is used when sync is enabled?
3. How would you verify write-order consistency after app restarts?

## Security and Privacy
1. Where is encryption performed in the data lifecycle?
2. How are keys managed on iOS vs Android?
3. What data should never be included in logs/analytics?

## Performance
1. Which operations are most likely to block the UI thread?
2. How would you benchmark chart rendering on large datasets?
3. What pruning/retention strategies prevent unbounded local growth?

## Testing and Quality
1. Which provider/store tests are critical gates before release?
2. How do you isolate deterministic tests for time-based records?
3. How do you prevent stale tests when model contracts change?

## Product/Clinical Boundary
1. Why is LifeTrack not a diagnostic system?
2. Which copy/UX patterns reduce medical risk?
3. How would you integrate clinician review safely?
