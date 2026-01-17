# Development Plan Checklist

This file tracks milestones, issues, and task-level checklists for Remi.

## M0 - Baseline and Architecture
- [x] M0-1 Navigation and page scaffolding (Index + 5 tabs)
  - [x] `entry/src/main/ets/pages/Index.ets` tab router shell
  - [x] `entry/src/main/ets/pages/Trace.ets` placeholder
  - [x] `entry/src/main/ets/pages/Experience.ets` placeholder
  - [x] `entry/src/main/ets/pages/Add.ets` placeholder
  - [x] `entry/src/main/ets/pages/Remi.ets` placeholder
  - [x] `entry/src/main/ets/pages/Profile.ets` placeholder
  - Tests:
    - [x] UI: default enters Trace
    - [x] UI: tab switching works
    - [x] UI: tab labels show "足迹 / 经历 / 回响 / 我的"
    - [x] UI: add tab uses plus icon (no text)
    - [x] UI: tab bar is bottom-positioned on phones
- [ ] M0-2 Data model and RDB base
  - [ ] `entry/src/main/ets/data/schema.ets`
  - [ ] `entry/src/main/ets/data/db.ets`
  - [ ] `entry/src/main/ets/data/repositories/*.ets`
  - Tests:
    - [ ] Unit: Visit CRUD
    - [ ] Unit: Place-Visit relation query
- [ ] M0-3 Permissions baseline
  - [ ] `entry/src/main/ets/platform/permissions.ets`
  - [ ] `entry/src/main/module.json5` permissions
  - Tests:
    - [ ] Manual: first Add opens permission prompt
    - [ ] Unit: denied state returns error

## M1 - The Trace (Core Map and Footprints)
- [ ] M1-1 Ripple map rendering
  - [ ] `entry/src/main/ets/components/RippleMap.ets`
  - [ ] `entry/src/main/ets/pages/Trace.ets`
  - Tests:
    - [ ] UI: new visit shows ripple point
    - [ ] UI: zoom keeps markers
- [ ] M1-2 Auto location + manual check-in
  - [ ] `entry/src/main/ets/services/location.ets`
  - [ ] `entry/src/main/ets/services/manualCheckin.ets`
  - [ ] `entry/src/main/ets/pages/Add.ets`
  - Tests:
    - [ ] Unit: location returns valid coords
    - [ ] Manual: manual check-in works offline
- [ ] M1-3 Photo import check-in
  - [ ] `entry/src/main/ets/services/mediaImport.ets`
  - Tests:
    - [ ] Unit: EXIF import creates Visit
    - [ ] Manual: no EXIF prompts manual location
- [ ] M1-4 Stats and achievement panel
  - [ ] `entry/src/main/ets/services/stats.ets`
  - [ ] `entry/src/main/ets/pages/Profile.ets`
  - Tests:
    - [ ] Unit: country/city counts correct
    - [ ] UI: progress bar updates

## M2 - The Remi (Memory Features)
- [ ] M2-1 Sensory tags
  - [ ] `entry/src/main/ets/components/SensoryTags.ets`
  - [ ] `entry/src/main/ets/data/repositories/tags.ets`
  - Tests:
    - [ ] Unit: tags saved and queryable
    - [ ] UI: multi-select state correct
- [ ] M2-2 Ambient audio capture
  - [ ] `entry/src/main/ets/services/audio.ets`
  - [ ] `entry/src/main/ets/components/AudioRecorder.ets`
  - Tests:
    - [ ] Manual: 10s record auto-stops
    - [ ] Unit: audio path saved
- [ ] M2-3 On This Day echo
  - [ ] `entry/src/main/ets/services/echo.ets`
  - [ ] `entry/src/main/ets/pages/Remi.ets`
  - Tests:
    - [ ] Unit: date match logic correct
    - [ ] UI: empty state visible
- [ ] M2-4 Activity collections + badges
  - [ ] `entry/src/main/ets/components/Collections.ets`
  - [ ] `entry/src/main/ets/data/repositories/achievements.ets`
  - Tests:
    - [ ] Unit: rule triggers badge
    - [ ] UI: badge card renders
- [ ] M2-5 Memory reel (long image)
  - [ ] `entry/src/main/ets/services/reelGenerator.ets`
  - Tests:
    - [ ] Unit: >=3 visits triggers generation
    - [ ] Manual: output share file opens

## M3 - MVP Experience and Privacy
- [ ] M3-1 30-second capture flow
  - [ ] `entry/src/main/ets/pages/Add.ets`
  - Tests:
    - [ ] Manual: complete record within 30 seconds
    - [ ] UI: <= 5 interactions
- [ ] M3-2 Local encryption and privacy
  - [ ] `entry/src/main/ets/services/crypto.ets`
  - [ ] `entry/src/main/ets/data/db.ets`
  - Tests:
    - [ ] Unit: encrypt/decrypt roundtrip
    - [ ] Manual: denied permissions block location
- [ ] M3-3 Offline queue and sync
  - [ ] `entry/src/main/ets/services/syncQueue.ets`
  - Tests:
    - [ ] Unit: enqueue/dequeue works
    - [ ] Manual: offline record syncs on reconnect

## M4 - Testing and Release
- [ ] M4-1 Unit test coverage
  - [ ] `entry/src/test/data/*.test.ets`
  - [ ] `entry/src/test/services/*.test.ets`
  - Tests:
    - [ ] Unit: data/service coverage >= 70%
- [ ] M4-2 Device tests
  - [ ] `entry/src/ohosTest/ets/test/Location.test.ets`
  - [ ] `entry/src/ohosTest/ets/test/Audio.test.ets`
  - [ ] `entry/src/ohosTest/ets/test/Map.test.ets`
  - Tests:
    - [ ] Device: location error <= 50m
    - [ ] Device: audio record/play OK
    - [ ] Device: map renders smoothly
