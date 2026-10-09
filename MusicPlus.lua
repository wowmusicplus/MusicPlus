--[[ MusicPlus 0.5.16 (25 zones: 6 capitals and 19 zones, Alliance and Horde, levels 1-45, plus the Skyborne starting zone) for WoW: Forever 1.60.1 (Interface 16001)
0.5.16: Hillsbrad Foothills' "Southshore Versus Tarren Mill" and "Apothecary Lydon's Experiment" replaced with
calmer takes (same file paths and titles; len 209.71 -> 179.64 and 196.15 -> 180.02). No code changes.
0.5.15: Thunder Bluff's "Magatha Grimtotem's Dusk" and "Mists of the Pools of Vision" replaced with new takes
(same file paths and titles; len 179.71 -> 180.00 and 179.90 -> 179.64). No code changes.
0.5.14: Stonetalon Mountains' "Protect Kaya Flathoof" replaced with a calmer take (same file path and title,
len 191.54 -> 178.82). No code changes.
0.5.13: the Music volume can no longer get stuck at 0 after an inn (reported in Darkshire's Scarlet Raven Tavern).
Cause: FadeStep treated ANY difference between the volume it had just written and the volume the client reported back
as "the player moved the slider" and adopted the fading value as the saved volume. If the client reports the value
back even slightly differently (rounded, or one step late), every step re-adopted its own fading value, so the
"saved" volume shrank with the fade and was restored as ~0 (0% in the inn, so no tavern music either, and still 0%
outside, because the next rotation and every later fade started from it). Fix: the fade never reads its own steps
back; a mid-fade change is adopted only from our slider or a CVAR_UPDATE that isn't one of our own writes (not during
our SetCVar, and not within 0.011 of any value this fade wrote). The restore after the fade runs even if stopping the
song errors (pcall), and a watchdog ends a fade that runs 3 s past its length. Volume safety: MusicPlusDB.volZeroed
is set when a fade writes 0 and cleared when the saved volume is put back; MusicPlusDB.lastVolume keeps the player's
last volume above 0. On login, /reload, loading screens, zone/subzone changes, each position poll and every rotation
start, a Music volume of 0 that MusicPlus left (volZeroed, or an unfinished fade) is put back. One-time on the first
0.5.13 load: a Music volume below 1% (left at 0 by 0.5.12) is set back to lastVolume, else the game default 40%,
with a chat line. Darkshire's tavern keeps its inn status: WMOAreaTable 20505 (WMO 133 name set 2, "Scarlet Raven
Tavern") plays ZoneMusic 156 Zone-TavernAlliance in Forever 1.60.1 and Classic Era 1.15.9, like the Lion's Pride Inn,
so MusicPlus fades out there and the game's tavern music plays at your volume. Inn detection is unchanged.
0.5.12: song titles with proper punctuation. Every customs entry gets display = the approved title with its apostrophes
("Vol'jin's Counsel"); file and name stay the apostrophe-free file name ("Voljins Counsel"), so no MP3 changes.
Track objects take name = display (fallback: name, then the file name), so "Now playing", /mplus test, /mplus status,
the window's "Now:" line and debug lines all show the display title. Nothing else changed.
0.5.11: renamed all 150 custom songs with vanilla lore titles (data only: file and name of every customs entry; the MP3s
were renamed to match). Same slots, same order, same lengths; titles and file names drop apostrophes as
before (commas kept, they are fine in Windows file names). /mplus test now plays "Archbishop Benedictus Blessing"
(Stormwind custom 1, the same MP3). Nothing else changed.
0.5.10: updated two Ashenvale songs (same slots, chill versions): Whispers of the Old Gods -> Moonlit Whispers of
Ashenvale, Starlight Over UnGoro -> Twilight Beyond UnGoro (lengths from ffprobe). Nothing else changed.
0.5.9: "Disable MusicPlus for this zone" + window touch-ups (zones, songs, timing, inns, fades and flights unchanged).
 * New checkbox right under Enable in the /mplus window: "Disable MusicPlus for this zone: <zone>". <zone> = the configured
   zone you're in (FindZone, so a capital at its gates is the capital), refreshed on every zone event, loading screen and
   whenever the window shows. Saved per zone title in MusicPlusDB.disabledZones[title] = true. Outside the configured
   zones (and in instances) the box is greyed out and unchecked: "<zone text> (not a MusicPlus zone)".
 * A disabled zone counts as "outside the configured zones" everywhere (Evaluate, the position poll, the walking-delay
   readings): nothing starts there and the game's own music plays. Ticking it where MusicPlus plays fades the song out
   at once (1.5 s, like /mplus off: no walking delay, no second reading), the game's music comes back; a silence
   (Loop music off) just ends. Unticking starts a fresh rotation there (~0.1 s). Walking into a disabled zone = walking
   out of the zones (the 0.5.3 6 s delay, going back cancels it); a loading screen or landing there = the ~1 s prompt
   rule; walking out of one into a playing zone starts that zone at once (nothing was playing). Inns are unchanged (a
   disabled zone is quiet anyway). Flights: the zone below is still ignored; if the zone the flight plays for (the
   takeoff zone) is disabled mid-flight, or a /reload mid-flight would resume a disabled zone, MusicPlus fades out /
   stays off for the rest of the flight. Leveling Zone Music "all": other leveling zones still mix all 114 custom songs
   (a disabled zone's songs included: only the zone itself is affected); cities are unchanged.
 * /mplus zone [on/off] (no argument: show this zone's state and the disabled zones), /mplus zone clear (re-enable
   every zone); in /mplus help. /mplus status shows "This zone: <zone> - MusicPlus on/OFF here" and the disabled zones.
 * Leveling Zone Music now has both descriptions under the dropdown ("For this zone only: ..." and "All zones: ..."),
   the selected one brighter. The "Got it" button is now "Close". The window is taller (440 x 680) so nothing overlaps.
0.5.8: new zone Zephras Isle, the Skyborne starting zone (levels 1-12; data only: one ZONES entry + its ZONE_ORDER key).
 * ONE plain leveling zone (author's call): no capital, no subzone or area checks (Valanaar, the hub, is just part of it).
   Detected like every zone: Forever uiMap 2521 (Map 2991, AreaTable 16593) or the zone text "Zephras Isle".
 * Originals = every zone-music track the client has for the zone (Forever 1.60.1.70205): the zone default kit
   (ZoneMusic 3230, the 2 Cataclysm Skywall tracks) and the subzone kits of Valanaar, Gustberry Lowlands, Shen'dar,
   Thendal Village, Shrine of Akir and Shadowgale Forest (24 tracks, 32-159 s), played first, shuffled, as everywhere.
   Not included: the Valanaar intro stinger (ZoneIntroMusic 1687) and the cave music (kit 204).
 * 6 custom songs in "Zephras Isle\" (lengths measured with ffprobe). A leveling zone, so its customs join the
   "Play music from all zones" pool: 19 leveling zones x 6 = 114 songs. No tavern music anywhere on the isle
   (Windshaper Lodge and High Order Lodge use the area's music), so no inns. Nothing else changed.
0.5.7: one window and a "Leveling Zone Music" setting (music timing, inns, fades, flights and zone detection unchanged).
 * The welcome window and the options window are now ONE window (MusicPlusOptionsFrame, title "MusicPlus 0.5.7"):
   "Welcome to MusicPlus" + the intro line, Enable, background sound, Loop music and Show song titles (each of the
   last three with its welcome description), the Leveling Zone Music dropdown, the volume slider, Skip + the song
   playing now, the "/mplus at any time" note and the Got it button. /mplus (no argument) opens / closes it;
   /mplus welcome opens it; it still pops up once by itself (WELCOME_DELAY s after the first loading screen,
   after combat) unless MusicPlusDB.welcomeShown is set, and showing it (any way) sets the flag. The separate
   welcome window (MusicPlusWelcomeFrame) is gone. The Settings > AddOns panel is unchanged.
 * "Leveling Zone Music" (MusicPlusDB.pool, default "zone" = exactly 0.5.6): "all" = in the 18 leveling zones
   (every zone that isn't one of the 6 CAPITALS) the customs part of the rotation is the custom songs of ALL 18
   leveling zones together (108), shuffled; the zone's own originals still come first, other zones' originals
   are never added. Capitals always play only their own originals and customs, and capital customs are never in
   the shared pool. Changing it while a leveling zone plays leaves the current song (or silence) alone and redoes
   only the part of the rotation that hasn't played yet (RebuildPool); the next round uses the new pool from the
   start. /mplus pool [zone/all] does the same from chat.
0.5.6: Calmer reworked music for Thunder Bluff, Dun Morogh, Durotar, Stranglethorn Vale, Stormwind (4 new songs) and Orgrimmar (data only: the customs entries of those 6 zones; nothing else changed).
0.5.5: Undercity: 5 new custom songs replace 5 of the 6 old ones; Apothecarium Whispers kept (data only: the 5 Undercity customs entries; nothing else changed).
0.5.4: Redridge Mountains: 6 new calmer custom songs (data only: the 6 Redridge customs entries; nothing else changed).
0.5.3: zone switches on flight paths and at borders (on a flight from Westfall to Redridge the tracks kept switching).
 * Flight lock: while UnitOnTaxi("player") is true, zone readings are ignored. The song and the rotation of the zone
   you took off from go on (Loop music and silences as usual); no inn can start (SpotHere is off on a taxi, so flying
   over an inn circle or an inn subzone does nothing; an inn state from before takeoff still ends by the 0.4.4 exit
   rules); if MusicPlus wasn't playing at takeoff, nothing starts until landing. Engaged by the 0.5 s position poll,
   PLAYER_CONTROL_LOST or any zone evaluation; released when UnitOnTaxi is false again, once in the world (poll,
   PLAYER_CONTROL_GAINED, or the evaluation after a loading screen). Landing = the normal zone check with the prompt
   ~1 s confirmation: another configured zone -> its own rotation (exactly like any zone switch), outside the zones ->
   the 1.5 s fade and the game's music, same zone -> nothing at all. The takeoff zone is kept in MusicPlusDB.taxiZone
   (false = MusicPlus was off), so a /reload or relog mid-flight goes on with it (no saved value: the zone below you,
   like a login). A loading screen mid-flight replays the current song, as every loading screen does.
 * Border delay: walking from one configured zone into another, or out of the zones, now needs the new place read
   for ZONE_SWITCH_DELAY (6) s in a row (zone events and the 0.5 s position poll are all checked); any other reading in
   between (walking back) cancels it and the song just goes on. NOT for: first activation (login, /reload, entering
   from outside the zones with nothing playing), inns (0.4.4 hysteresis unchanged), and the PROMPT_WINDOW s after a
   loading screen (hearth, portal, instance exit) or a landing: there the 0.5.2 second reading CONFIRM_PROMPT s later
   is enough. The capital "within" rule is unchanged (only the timing). Without flights or border crossings the
   music timing is exactly 0.5.2's.
 * /mplus debug notes the flight lock (engaged / released) and pending switches (started / cancelled); /mplus status
   shows "(on flight path, zone locked)" while flying and a pending switch with its countdown.
0.5.2: "Welcome to MusicPlus" window (UI only; music timing and output unchanged). Shown once, about WELCOME_DELAY s after
   the first PLAYER_ENTERING_WORLD of the session, if MusicPlusDB.welcomeShown isn't set (new installs AND upgrades);
   never on later loading screens of the session. In combat it waits for PLAYER_REGEN_ENABLED. The flag is written the
   moment the window is shown (OnShow), so /reload or logout with it open doesn't bring it back. It has Loop music,
   Show song titles and background sound checkboxes with short descriptions, wired to the same setters as the /mplus
   window and the Settings panel (RefreshUI keeps all three in sync), a "/mplus at any time" note and a Got it button.
   /mplus welcome reopens it. If the beta doesn't restore SavedVariables, it shows at every login.
0.5.1: two options (window, Settings panel, /mplus loop, /mplus titles; saved in MusicPlusDB.loop / .titles):
 * "Loop music" (default ON = exactly the 0.5.0 behavior: the next track starts the moment one ends). OFF = like the
   game's own zone music with its Loop Music setting (CVar Sound_ZoneMusicNoDelay, never touched by MusicPlus) off:
   a track, then GAP_MIN-GAP_MAX s of silence, then the next track. The range is the ZoneMusic table's
   SilenceIntervalMin/Max (180000/300000 ms, day and night) of every zone-music set our 25 zones use (Forever
   1.60.1.70094 and Classic Era 1.15.9, wago.tools), so it's one range for all zones. PlayMusic LOOPS, so a track
   never "just ends" (it would start over), and StopMusic() hands the Music channel back to the game (its zone music
   returns). So during the gap MusicPlus stays the PlayMusic owner with a silent placeholder, PlayMusic(SILENCE_FILE)
   (a file that doesn't need to exist: PlayMusic of a missing file = silence, as with a missing custom MP3), and
   RestoreGameMusic is not called; the gap timer then calls PlayMusic(next). "sound" mode: nothing plays and the
   zone's music files stay muted during the gap. Skip, Loop back on, inns, leaving, /mplus off and zone switches
   end the gap exactly as they end a song; a loading screen re-asserts the silence and the gap keeps counting.
 * "Show song titles" (default OFF): the "Now playing: <song> (Original 3/8)" chat line on track changes only when
   on. The window label and /mplus status / now always show the song (or "Silence before Custom 3/6 (1:12)").
0.5.0: 21 more zones (ZONES / ZONE_ORDER below): Ironforge, Darnassus, Orgrimmar, Thunder Bluff, Undercity, Dun Morogh,
Teldrassil, Durotar, Mulgore, Tirisfal Glades, Loch Modan, Darkshore, Silverpine Forest, The Barrens, Redridge Mountains,
Stonetalon Mountains, Duskwood, Ashenvale, Wetlands, Hillsbrad Foothills, Stranglethorn Vale. Originals = the zone's own
Classic zone-music kit (day and night), no intro/moment one-offs. Every capital is "within" the zone around it. Inns: only
buildings whose 1.60.1 WMOAreaTable/AreaTable data plays tavern music, by position + indoors (0.4.4 hysteresis), plus the
subzone name where the building has one. 6 custom (Suno) songs per new zone; lengths measured with ffprobe.
ROTATION (since 0.3.0, unchanged): per configured zone, ALL original zone tracks (shuffled), then ALL custom songs (shuffled),
then again with a fresh shuffle of both groups. Entering the zone (login, zone change, coming out of an inn)
starts a freshly shuffled rotation. The song that just played is never first in the next rotation.
Zones are pure data (ZONES below): adding a zone = adding an entry. 0.4.0 adds Elwynn Forest and Westfall.
Moving straight from one configured zone into another (Stormwind <-> Elwynn <-> Westfall) starts the new
zone's own freshly shuffled rotation (confirmed by a second reading ~1 s later, like a stop; 0.5.3: walking needs
6 s in the new zone, see above).

PLAYBACK (since 0.2.0): Music channel, ambient sounds untouched, game music setting left ON.
 * Mode "music" (default): PlayMusic(file) for every track (originals by FileDataID, custom MP3s by path).
   PlayMusic plays on the Music channel and fades out the built-in zone music while it's active. It loops,
   so the duration timer switches straight to PlayMusic(next) (no StopMusic in between, so zone music
   can't slip in). StopMusic() when leaving the configured zones, entering an inn or /mplus off lets the game's
   music come back. PlayMusic returns true even for bad files, so a missing file is just silence until its
   timer ends. Music stops on loading screens/reload, so PLAYER_ENTERING_WORLD restarts the current track.
 * Mode "sound" (fallback for testing, /mplus mode): PlaySoundFile(file, "Music"). The zone's built-in
   music files (zoneMusic) are muted with MuteSoundFile during the custom songs and unmuted for the original
   slot (they're the same IDs, so they can't stay muted then). Here the 0.1.2 alt-tab resume applies
   (poll C_Sound.IsPlaying; restart the same track from the start if it was killed with time left).
Alt-tab: PlayMusic has no handle / IsPlaying, so a killed song can't be detected. That's why MusicPlus turns
"Sound in Background" (Sound_EnableSoundWhenGameIsInBG) on by default. If you turn it off, a big frame gap
or SOUND_DEVICE_UPDATE (the only "probably back" hints; there's no focus API in the Forever docs) replays
the current track; /mplus replay does the same by hand.
API notes (Forever 1.60.1 UI source): documented: C_Sound.IsPlaying, C_Map.GetBestMapForUnit/GetMapInfo,
GetZoneText, GetRealZoneText, GetSubZoneText, IsResting, IsIndoors, IsInInstance, C_CVar.GetCVar/SetCVar,
C_Timer.NewTimer/NewTicker, GetTime, Settings.RegisterCanvasLayoutCategory/RegisterAddOnCategory
(Blizzard_Settings.lua). StopSound(handle, fadeMs) is used by Blizzard code. PlayMusic, StopMusic,
PlaySoundFile, MuteSoundFile, UnmuteSoundFile are C globals NOT in the Forever source (EMP / BMP / AI VoiceOver
use them); all are pcall-guarded. CVars Sound_MusicVolume and Sound_EnableSoundWhenGameIsInBG are the ones
used by Forever's Settings > Audio.
Detection: the player's map parent chain is walked child-first and every zone is checked at each level,
so the most specific map wins (Stormwind City before Elwynn Forest, Northshire -> Elwynn). If the zone
text names a zone that lies inside the map's zone (Stormwind "within" Elwynn), the zone text wins.
Inns (0.4.1): two signals. (1) GetSubZoneText() against the zone's inns list (a fallback: in Forever even the
Lion's Pride Inn reports just "Goldshire"). (2) Inn spots: player position (C_Map.GetPlayerMapPosition) within
r yards of a spot on the given uiMap AND IsIndoors(). Used for the Slaughtered Lamb bar floor (part of the
Stormwind city WMO, subzone = district) and, since 0.4.3, the Lion's Pride Inn (WMOAreaTable sets no AreaTable
for it, so the subzone stays "Goldshire"). IsResting() is not used: it's true
anywhere in a capital city, and around (not just inside) other inns. A 0.5 s ticker re-checks the position
(walking through a door fires no zone event); a new state must be seen twice in a row before it's acted on,
so doorway jitter can't flap the music. Inn spots have hysteresis (0.4.4): entering needs two polls in a row
inside r AND indoors; once in, the inn state holds until the player is clearly out: 5 polls in a row (2.5 s)
outdoors or 2 polls beyond r + 10 yd. Brief IsIndoors() = false (stairs, doorways) is ignored. /mplus inn saves the current position as a spot (MusicPlusDB).
Game music after a stop: StopMusic() alone leaves the game silent until its next zone-music trigger, so
MusicPlus toggles Sound_EnableMusic 0 -> 1 (0.1 s apart) after stopping for an inn, leaving the zones or
/mplus off; turning music back on makes the client start the current area's music at once. Only done if
Music was on; the Ambience channel is never touched.
Fade-out (0.4.5): instead of cutting the song, Sound_MusicVolume is ramped from the player's setting to 0 in
0.05 s steps (2 s entering an inn, 1.5 s leaving the zones or /mplus off), then StopMusic(), then the Music
off/on toggle with the saved volume put back while Music is off (so nothing plays at the wrong volume).
The saved volume is always restored: fade done, back out of the inn / into the zone mid-fade (fade
cancelled, the song keeps playing), /mplus off/mode/test, loading screens (PLAYER_LEAVING_WORLD), logout and
/reload (PLAYER_LOGOUT). It's also kept in MusicPlusDB.fadeVolume while fading and restored at the next load
if the client crashed mid-fade. A volume change during a fade (our slider or Blizzard's) becomes the new
saved volume; the options slider always shows the saved volume, never the fading one.
SavedVariables MusicPlusDB (bgSound, enabled, mode, window position, innSpots, fadeVolume, loop, titles, welcomeShown, pool,
0.5.13: lastVolume, volZeroed, volCheck0513). The beta may not restore
SavedVariables; then the defaults apply every login (enabled, mode "music", background sound turned ON, Loop music ON,
song titles OFF, Leveling Zone Music "For this zone only"). ]]

local ADDON = "MusicPlus"
local ADDON_DIR = "Interface\\AddOns\\MusicPlus\\"
local PREFIX = "|cff33ccffMusicPlus|r: "
local FADE_MS = 2000
local FADE_INN = 2.0     -- s, volume fade-out when entering an inn
local FADE_LEAVE = 1.5   -- s, volume fade-out when leaving the configured zones or on /mplus off
local FADE_STEP = 0.05   -- s between volume steps
local DEBOUNCE = 0.75
local POLL, RETRY, MIN_LEFT, CONFIRM, MAX_UNSEEN = 1.0, 2.0, 3.0, 2.0, 5 -- sound-mode resume tuning
local BG_CVAR = "Sound_EnableSoundWhenGameIsInBG" -- Settings > Audio > "Sound in Background"
local VOL_CVAR = "Sound_MusicVolume"              -- Settings > Audio > "Music" volume
-- 0.5.1 "Loop music" off: silence between tracks, in whole seconds. ZoneMusic SilenceIntervalMin/Max = 180000/300000 ms
-- (day and night) for Zone-Stormwind, -Forest, -Plains, -Mountain, -EnchantedForest, -EvilForest, -DarkForest, -BarrenDry,
-- -Jungle, -Soggy, -Ironforge, -Darnassus, -Orgrimmar, -Thunderbluff, -Undercity (wago.tools ZoneMusic, build 1.60.1.70094);
-- 0.5.8: the same for Zephras Isle's sets 3230, 3535, 3536, 3537, 3553, 3554, 3555 (build 1.60.1.70205).
local GAP_MIN, GAP_MAX = 180, 300
local SILENCE_FILE = ADDON_DIR .. "Silence.mp3" -- silent placeholder for PlayMusic during a gap (need not exist)
local WELCOME_DELAY = 2 -- 0.5.2: s after the first PLAYER_ENTERING_WORLD before the one-time welcome window
-- 0.5.3: zone-change timing. Walking over a border (zone -> zone, or out of the zones) must read the new place for
-- ZONE_SWITCH_DELAY s in a row; inns, and the PROMPT_WINDOW s after a loading screen or a landing, keep the 0.5.2 rule
-- (a second reading CONFIRM_PROMPT s later). Tune the border delay here.
local ZONE_SWITCH_DELAY = 6 -- s
local CONFIRM_PROMPT = 1.0  -- s, the 0.5.2 two-reading confirmation
local PROMPT_WINDOW = 5     -- s after PLAYER_ENTERING_WORLD / landing in which a new zone is confirmed promptly

---------------------------------------------------------------- zone data
-- One entry per zone. Fields:
--   title      display name
--   mapIDs     uiMapIDs of the zone; any map whose parent chain reaches one of these (or whose map name is
--              in names) counts, so every district/sub-map is included
--   names      zone names (map name / GetZoneText / GetRealZoneText fallback)
--   within     key of a zone this one lies inside (optional). If the map resolves to that outer zone but
--              the zone text names this one, this one wins (Stormwind City is never taken for Elwynn).
--   originals  { id = FileDataID, len = seconds, name = ... }   played first, shuffled
--   customs    { file = path under Interface\AddOns\MusicPlus\, len = seconds, name = ..., display = ... }   then these, shuffled
--              name = the file name without .mp3 (no apostrophes: Windows-safe); display = the title shown in game,
--              with its punctuation (0.5.12). Shown: display, else name, else the file name.
--              (an entry without a positive numeric len is ignored, so a typo can't break the timer)
--   inns       subzone names (enUS) where the addon stays quiet so the game's inn music plays
--   innSpots   { name, maps = { uiMapIDs }, x, y (0-1 map coords), r = radius in yards } - quiet there
--              while IsIndoors() is true (for inns that have no subzone of their own)
--   zoneMusic  FileDataIDs of the game's own music for this zone (only used by "sound" mode, to mute it)
local ZONES = {
    stormwind = {
        title = "Stormwind",
        -- 84 = Stormwind City (retail/mainline), 1453 = Stormwind City (classic-era clients)
        mapIDs = { 84, 1453 },
        names = { "Stormwind City", "Stormwind" },
        within = "elwynn", -- the city borders Elwynn; some clients parent its map to Elwynn
        -- SoundKit 2532 "Zone-Stormwind" (Classic Era, wago.tools); IDs from Better Music Player 0.1.5
        -- gamemusic\Classic.lua; exact lengths measured.
        originals = {
            { id = 53202, len = 54.80, name = "Stormwind 1 Moment" },
            { id = 53203, len = 35.55, name = "Stormwind 2 Moment" },
            { id = 53204, len = 69.91, name = "Stormwind 3 Moment" },
            { id = 53205, len = 62.30, name = "Stormwind 4 Zone" },
            { id = 53206, len = 61.00, name = "Stormwind 5 Zone" },
            { id = 53207, len = 53.66, name = "Stormwind 6 Zone" },
            { id = 53208, len = 86.99, name = "Stormwind 7 Zone" },
            { id = 53209, len = 77.30, name = "Stormwind 8 Zone" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Stormwind\\Archbishop Benedictus Blessing.mp3", len = 134.88, name = "Archbishop Benedictus Blessing", display = "Archbishop Benedictus' Blessing" },
            { file = "Stormwind\\The Boy Kings Lullaby.mp3",          len = 144.84, name = "The Boy Kings Lullaby", display = "The Boy King's Lullaby" },
            { file = "Stormwind\\Lothar, Lion of Stormwind.mp3",      len = 179.47, name = "Lothar, Lion of Stormwind", display = "Lothar, Lion of Stormwind" },
            { file = "Stormwind\\Lady Prestors Masquerade.mp3",       len = 179.47, name = "Lady Prestors Masquerade", display = "Lady Prestor's Masquerade" },
            { file = "Stormwind\\Walls the Stonemasons Raised.mp3",   len = 178.82, name = "Walls the Stonemasons Raised", display = "Walls the Stonemasons Raised" },
            { file = "Stormwind\\Bazil Thredds Stockade.mp3",         len = 180.00, name = "Bazil Thredds Stockade", display = "Bazil Thredd's Stockade" },
        },
        -- No inn subzones in Forever's Stormwind (inside the Gilded Rose it's just "Trade District").
        -- The Gilded Rose, Pig and Whistle Tavern and The Blue Recluse have no inn music in Forever (their WMO
        -- groups use the city music), so the rotation keeps playing there (author's call, 0.4.2).
        inns = {},
        -- Only the Slaughtered Lamb bar floor has tavern music (WMOAreaTable ZoneMusic 156). It has no subzone
        -- of its own either (the basement shares the name and plays haunted music), so: position + IsIndoors().
        -- Forever's uiMap 1453 covers the same world area as retail 84 (UiMapAssignment), so the coordinates are valid on both. Centers = innkeeper/bartender spawns
        -- (Wowhead Classic, converted from the Classic Era 1453 layout via world coordinates; they agree with
        -- Wowhead's retail 84 spawns). Map scale: 1% x = 17.4 yd, 1% y = 11.6 yd.
        innSpots = {
            { name = "The Slaughtered Lamb",   maps = { 1453, 84 }, x = 0.417, y = 0.825, r = 18 }, -- Jarel Moor (bartender) 41.7,82.5; basement (haunted music, 39.8,84.6) is outside
        },
        -- Classic files, plus the re-encoded copies Forever 1.60.1 actually plays for SoundKit 2532
        -- "Zone-Stormwind" (8180866-8180880, even IDs). Moments/intro 8180882/8180884 are separate kits.
        zoneMusic = { 53202, 53203, 53204, 53205, 53206, 53207, 53208, 53209, 53210, 53211,
                      8180866, 8180868, 8180870, 8180872, 8180874, 8180876, 8180878, 8180880 },
    },

    elwynn = {
        title = "Elwynn Forest",
        -- 1429 = Elwynn Forest (Forever 1.60.1 and classic-era UiMap), 37 = Elwynn Forest (retail),
        -- 425 = Northshire (retail child map of 37). Forever has no separate Northshire map: Northshire
        -- Valley is a subzone of Elwynn (AreaTable 9, parent 12), so the player's map there is 1429.
        mapIDs = { 1429, 37, 425 },
        names = { "Elwynn Forest", "Northshire", "Northshire Valley" },
        -- ZoneMusic 1 "Zone-Forest" (Elwynn and all its subzones): SoundKit 2523 for day AND night.
        -- Classic Era 1.15.9 kit 2523 = these 3 files (the Night Forest tracks 53495-53498 belong to kit
        -- 2533 / 5376 "Zone-DarkForest", not Elwynn). Lengths measured from the real files (ffprobe).
        originals = {
            { id = 53492, len = 55.69, name = "Day Forest 1" },
            { id = 53493, len = 72.52, name = "Day Forest 2" },
            { id = 53494, len = 64.71, name = "Day Forest 3" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Elwynn Forest\\You No Take Candle.mp3",        len = 194.42, name = "You No Take Candle", display = "You No Take Candle" },
            { file = "Elwynn Forest\\Hoggers Hunting Grounds.mp3",   len = 207.24, name = "Hoggers Hunting Grounds", display = "Hogger's Hunting Grounds" },
            { file = "Elwynn Forest\\Innkeeper Farleys Morning.mp3", len = 208.80, name = "Innkeeper Farleys Morning", display = "Innkeeper Farley's Morning" },
            { file = "Elwynn Forest\\Maybell and Tommy Joe.mp3",     len = 187.58, name = "Maybell and Tommy Joe", display = "Maybell and Tommy Joe" },
            { file = "Elwynn Forest\\Princess Must Die.mp3",         len = 183.07, name = "Princess Must Die", display = "Princess Must Die" },
            { file = "Elwynn Forest\\Theocritus Starlit Study.mp3",  len = 202.44, name = "Theocritus Starlit Study", display = "Theocritus' Starlit Study" },
        },
        inns = {
            "Lion's Pride Inn",         -- fallback only: Forever reports subzone "Goldshire" inside the inn
        },
        -- Lion's Pride Inn (whole WMO: tavern music, ZoneMusic 156). The building is ~50 yd long west-east
        -- (hall + upstairs west, bar/kitchen + cellar east), so two overlapping circles (west 18 yd, east 20 yd;
        -- 0.4.3 had 16/16) instead of one big one. Once inside, the inn state holds up to r + 10 yd (hysteresis). Centers from exact spawn positions (AzerothCore creature table, world -> uiMap 1429) of the NPCs
        -- inside: Farley 43.77,65.80; Zaldimar/Josetta (upstairs) 43.25-43.39; Dobbins/Tomas 44.00-44.37;
        -- warlock trainers (cellar) 44.39-44.49; plus an in-game /mplus where reading in the hall (43.53,66.02, 4 yd from
        -- the west center). 1429 (Forever/Classic) and retail 37 have identical bounds (UiMapAssignment).
        -- Map scale: 1% x = 34.7 yd, 1% y = 23.1 yd. Nearest other building: blacksmith (Smith Argus 41.71,65.54,
        -- retail 41.7,65.7) 60 yd from the west center, 42 yd outside the circle. The stables (Erma, 20.1 yd from the
        -- west center) stay outside the 18 yd west circle; the east side (kitchen/cellar end) has no other building.
        innSpots = {
            { name = "Lion's Pride Inn", maps = { 1429, 37 }, x = 0.4343, y = 0.6590, r = 18 }, -- hall, stairs, upstairs
            { name = "Lion's Pride Inn", maps = { 1429, 37 }, x = 0.4424, y = 0.6595, r = 20 }, -- bar, kitchen, cellar
        },
        -- In Forever 1.60.1 kit 2523 plays re-encoded copies (8180778/80/82); the Classic files are still
        -- in the game (kit 361805). Both sets are muted.
        zoneMusic = { 8180778, 8180780, 8180782, 53492, 53493, 53494 },
    },

    westfall = {
        title = "Westfall",
        -- 1436 = Westfall (Forever 1.60.1 and classic-era UiMap), 52 = Westfall (retail)
        mapIDs = { 1436, 52 },
        names = { "Westfall" },
        -- ZoneMusic 9 "Zone-Plains": SoundKit 2528 (day) and 2538 (night); in Classic Era 1.15.9 both kits
        -- hold the same 4 files, day and night plains. Lengths measured from the real files (ffprobe).
        originals = {
            { id = 53680, len = 53.76, name = "Day Plains 1" },
            { id = 53681, len = 76.54, name = "Day Plains 2" },
            { id = 53682, len = 58.38, name = "Night Plains 1" },
            { id = 53683, len = 68.62, name = "Night Plains 2" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Westfall\\Gryan Stoutmantles Militia.mp3",      len = 199.58, name = "Gryan Stoutmantles Militia", display = "Gryan Stoutmantle's Militia" },
            { file = "Westfall\\Poor Old Blanchy.mp3",                len = 194.78, name = "Poor Old Blanchy", display = "Poor Old Blanchy" },
            { file = "Westfall\\Salma Saldeans Westfall Stew.mp3",    len = 198.72, name = "Salma Saldeans Westfall Stew", display = "Salma Saldean's Westfall Stew" },
            { file = "Westfall\\Rusting Harvest Watchers.mp3",        len = 183.14, name = "Rusting Harvest Watchers", display = "Rusting Harvest Watchers" },
            { file = "Westfall\\VanCleef Beneath Moonbrook.mp3",      len = 193.63, name = "VanCleef Beneath Moonbrook", display = "VanCleef Beneath Moonbrook" },
            { file = "Westfall\\Captain Sanders Hidden Treasure.mp3", len = 198.43, name = "Captain Sanders Hidden Treasure", display = "Captain Sanders' Hidden Treasure" },
        },
        -- No inn or tavern in Classic Westfall (no WMO with inn/tavern music there in the 1.60.1 data;
        -- Sentinel Hill's inn came with Cataclysm). /mplus inn can still save a spot.
        inns = {},
        -- Forever 1.60.1 kits 2528/2538 play re-encoded copies (8181305-8181311); Classic files kept too.
        zoneMusic = { 8181305, 8181307, 8181309, 8181311, 53680, 53681, 53682, 53683 },
    },

    ironforge = {
        title = "Ironforge",
        -- 1455 = Ironforge (Forever/classic-era UiMap, area 1537), 87 = retail (same bounds). Parent map is the continent, not Dun Morogh.
        mapIDs = { 1455, 87 },
        names = { "Ironforge" },
        within = "dun-morogh", -- lies inside/borders Dun Morogh: the zone text wins when the map resolves to the outer zone
        -- ZoneMusic 232 "Zone-Ironforge" (WMO 20884 city groups and AreaTable 1537): SoundKit 7319, day = night.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53192, len = 123.41, name = "Ironforge Walking 1" },
            { id = 53194, len = 81.20, name = "Ironforge Walking 3" },
            { id = 53195, len = 70.28, name = "Ironforge Walking 4" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Ironforge\\Sons of the Earthen.mp3",        len = 143.23, name = "Sons of the Earthen", display = "Sons of the Earthen" },
            { file = "Ironforge\\Bengus Deepforges Anvil.mp3",    len = 122.42, name = "Bengus Deepforges Anvil", display = "Bengus Deepforge's Anvil" },
            { file = "Ironforge\\War of the Three Hammers.mp3",   len = 139.92, name = "War of the Three Hammers", display = "War of the Three Hammers" },
            { file = "Ironforge\\A Toast to Muradin.mp3",         len = 138.67, name = "A Toast to Muradin", display = "A Toast to Muradin" },
            { file = "Ironforge\\Rumble of the Deeprun Tram.mp3", len = 178.15, name = "Rumble of the Deeprun Tram", display = "Rumble of the Deeprun Tram" },
            { file = "Ironforge\\Mekkatorque in Exile.mp3",       len = 178.03, name = "Mekkatorque in Exile", display = "Mekkatorque in Exile" },
        },
        -- No inn subzone: the tavern WMO groups carry the district names ("Ironforge", "The Military Ward", "The Great Forge").
        inns = {},
        -- Three rooms of the Forever city WMO (20884) have tavern music (WMOAreaTable): The Stonefire Tavern (group 83263,
        -- Zone-DwavesTavern; Innkeeper Firebrew 18.2,51.5), Bruuk Barleybeard's bar in the Military Ward (83298, TavernAlliance; Bruuk
        -- 72.5,76.9) and the Cask 'n' Anvil in The Great Forge (83317, TavernAlliance; names from the old WMO 208). The city is indoors
        -- everywhere, so the circles were fitted to the rooms' floor geometry: no hall floor at the same level within r + 1 yd.
        -- 1455 = retail 87 (same bounds). 1% x = 7.9 yd, 1% y = 5.3 yd.
        innSpots = {
            { name = "The Stonefire Tavern", maps = { 1455, 87 }, x = 0.1845, y = 0.5179, r = 12 },
            { name = "The Stonefire Tavern", maps = { 1455, 87 }, x = 0.1909, y = 0.5274, r = 7 },
            { name = "Bruuk's tavern, Military Ward", maps = { 1455, 87 }, x = 0.7310, y = 0.7643, r = 16 },
            { name = "Bruuk's tavern, Military Ward", maps = { 1455, 87 }, x = 0.7246, y = 0.7397, r = 7 },
            { name = "Cask 'n' Anvil, The Great Forge", maps = { 1455, 87 }, x = 0.6070, y = 0.5066, r = 14 },
            { name = "Cask 'n' Anvil, The Great Forge", maps = { 1455, 87 }, x = 0.6019, y = 0.5160, r = 12 },
        },
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 53194, 8180965, 8180971, 53192, 53195 },
    },

    darnassus = {
        title = "Darnassus",
        -- 1457 = Darnassus (Forever/classic-era, area 1657), 89 = retail. Parent is the continent, not Teldrassil.
        mapIDs = { 1457, 89 },
        names = { "Darnassus" },
        within = "teldrassil", -- lies inside/borders Teldrassil: the zone text wins when the map resolves to the outer zone
        -- ZoneMusic 76 "Zone-Darnassus" (AreaTable 1657, WMO 1079): SoundKit 3920, day = night.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53184, len = 85.01, name = "Darnassus Walking 1" },
            { id = 53185, len = 69.49, name = "Darnassus Walking 2" },
            { id = 53186, len = 67.64, name = "Darnassus Walking 3" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Darnassus\\Hymn of the Sisterhood.mp3",              len = 193.20, name = "Hymn of the Sisterhood", display = "Hymn of the Sisterhood" },
            { file = "Darnassus\\Tyrande Awaits Malfurion.mp3",            len = 193.99, name = "Tyrande Awaits Malfurion", display = "Tyrande Awaits Malfurion" },
            { file = "Darnassus\\Illidans Gift.mp3",                       len = 182.30, name = "Illidans Gift", display = "Illidan's Gift" },
            { file = "Darnassus\\Heeding the Call.mp3",                    len = 209.11, name = "Heeding the Call", display = "Heeding the Call" },
            { file = "Darnassus\\The Sentinels Long Vigil.mp3",            len = 183.62, name = "The Sentinels Long Vigil", display = "The Sentinels' Long Vigil" },
            { file = "Darnassus\\Darnassian Bleu and Moonberry Juice.mp3", len = 169.63, name = "Darnassian Bleu and Moonberry Juice", display = "Darnassian Bleu and Moonberry Juice" },
        },
        -- No tavern music anywhere in Darnassus (WMO 1079 groups: city music 76; the inn on Craftsmen's Terrace too).
        inns = {},
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8180752, 8180754, 8180756, 53184, 53185, 53186 },
    },

    orgrimmar = {
        title = "Orgrimmar",
        -- 1454 = Orgrimmar (Forever/classic-era, area 1637), 85/86 = retail (city, Cleft of Shadow). Parent is the continent.
        mapIDs = { 1454, 85, 86 },
        names = { "Orgrimmar" },
        within = "durotar", -- lies inside/borders Durotar: the zone text wins when the map resolves to the outer zone
        -- ZoneMusic 14 "Zone-Orgrimmar" (Forever WMO 21142 group -1 row; AreaTable 1637 itself says 7 BarrenDry): SoundKit 2901, day = night.
        -- Kit 2901 has only the two "-zone" files; orgrimmar01/02-moment and the intro are separate one-off kits.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53198, len = 68.89, name = "Orgrimmar 1" },
            { id = 53200, len = 62.33, name = "Orgrimmar 2" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Orgrimmar\\Loktar Ogar.mp3",                len = 178.80, name = "Loktar Ogar", display = "Lok'tar Ogar" },
            { file = "Orgrimmar\\War Drums of Grommash Hold.mp3", len = 180.00, name = "War Drums of Grommash Hold", display = "War Drums of Grommash Hold" },
            { file = "Orgrimmar\\The Exodus of the Horde.mp3",    len = 179.74, name = "The Exodus of the Horde", display = "The Exodus of the Horde" },
            { file = "Orgrimmar\\Orgrims Doomhammer.mp3",         len = 180.00, name = "Orgrims Doomhammer", display = "Orgrim's Doomhammer" },
            { file = "Orgrimmar\\Fires of Ragefire Chasm.mp3",    len = 179.88, name = "Fires of Ragefire Chasm", display = "Fires of Ragefire Chasm" },
            { file = "Orgrimmar\\Voljins Counsel.mp3",            len = 180.02, name = "Voljins Counsel", display = "Vol'jin's Counsel" },
        },
        -- No tavern music in Forever's Orgrimmar (new WMO 21142: no inn/tavern rows; Innkeeper Gryshka's inn uses the city music).
        inns = {},
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8181033, 8181037, 53198, 53200 },
    },

    ["thunder-bluff"] = {
        title = "Thunder Bluff",
        -- 1456 = Thunder Bluff (Forever/classic-era, area 1638), 88 = retail (same bounds). Parent is the continent.
        mapIDs = { 1456, 88 },
        names = { "Thunder Bluff" },
        within = "mulgore", -- lies inside/borders Mulgore: the zone text wins when the map resolves to the outer zone
        -- ZoneMusic 226 "Zone-Thunderbluff" (AreaTable 1638, WMO 783): SoundKit 7077, day = night.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53213, len = 117.48, name = "Thunder Bluff Walking 1" },
            { id = 53214, len = 116.33, name = "Thunder Bluff Walking 2" },
            { id = 53215, len = 121.56, name = "Thunder Bluff Walking 3" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Thunder Bluff\\Cairne Bloodhoofs Peace.mp3",      len = 179.95, name = "Cairne Bloodhoofs Peace", display = "Cairne Bloodhoof's Peace" },
            { file = "Thunder Bluff\\The Long Trek to Mulgore.mp3",     len = 179.95, name = "The Long Trek to Mulgore", display = "The Long Trek to Mulgore" },
            { file = "Thunder Bluff\\Magatha Grimtotems Dusk.mp3",      len = 180.00, name = "Magatha Grimtotems Dusk", display = "Magatha Grimtotem's Dusk" },
            { file = "Thunder Bluff\\Mists of the Pools of Vision.mp3", len = 179.64, name = "Mists of the Pools of Vision", display = "Mists of the Pools of Vision" },
            { file = "Thunder Bluff\\Archdruid Hamuuls Teachings.mp3",  len = 184.82, name = "Archdruid Hamuuls Teachings", display = "Archdruid Hamuul's Teachings" },
            { file = "Thunder Bluff\\The Centaur War Remembered.mp3",   len = 180.02, name = "The Centaur War Remembered", display = "The Centaur War Remembered" },
        },
        -- No tavern music in Thunder Bluff (WMOs 783/789; Innkeeper Pala's tent uses the city music).
        inns = {},
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8180997, 8180999, 8181001, 53213, 53214, 53215 },
    },

    undercity = {
        title = "Undercity",
        -- 1458 = Undercity (Forever/classic-era, area 1497), 90 = retail (same bounds). Its map rectangle lies inside Tirisfal's,
        -- but the client picks the map by area: the city (WMO 20736 set 1, every group area 1497) gives 1458, the Ruins of
        -- Lordaeron above (terrain area 153, a Tirisfal subzone) give 1420.
        mapIDs = { 1458, 90 },
        names = { "Undercity" },
        within = "tirisfal", -- lies inside/borders Tirisfal Glades: the zone text wins when the map resolves to the outer zone
        -- ZoneMusic 182 "Zone-Undercity" (WMO 20736 set 1 / old WMO 1150): SoundKit 5074, day = night.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53216, len = 67.04, name = "Undercity 1" },
            { id = 53217, len = 85.64, name = "Undercity 2" },
            { id = 53218, len = 75.42, name = "Undercity 3" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Undercity\\Requiem for King Terenas.mp3",       len = 188.59, name = "Requiem for King Terenas", display = "Requiem for King Terenas" },
            { file = "Undercity\\The Dark Ladys Candles.mp3",         len = 198.38, name = "The Dark Ladys Candles", display = "The Dark Lady's Candles" },
            { file = "Undercity\\Minuet for Varimathras.mp3",         len = 169.22, name = "Minuet for Varimathras", display = "Minuet for Varimathras" },
            { file = "Undercity\\Faranells New Plague.mp3",           len = 172.92, name = "Faranells New Plague", display = "Faranell's New Plague" },
            { file = "Undercity\\Free Will of the Forsaken.mp3",      len = 190.03, name = "Free Will of the Forsaken", display = "Free Will of the Forsaken" },
            { file = "Undercity\\Beneath the Ruins of Lordaeron.mp3", len = 169.92, name = "Beneath the Ruins of Lordaeron", display = "Beneath the Ruins of Lordaeron" },
        },
        -- No tavern music in the Undercity (WMO 20736: city music; Innkeeper Norman's inn too).
        inns = {},
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8181003, 8181005, 8181007, 53216, 53217, 53218 },
    },

    ["dun-morogh"] = {
        title = "Dun Morogh",
        -- 1426 = Dun Morogh (Forever/classic-era, area 1), 27 = retail (different bounds), 427/469 retail sub-maps.
        mapIDs = { 1426, 27, 427, 469 },
        names = { "Dun Morogh", "Coldridge Valley", "New Tinkertown" },
        -- ZoneMusic 8 "Zone-Mountain": SoundKits 2527 (day) + 2537 (night); in Classic Era both hold all 7 files.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53577, len = 120.12, name = "Day Mountain 1" },
            { id = 53578, len = 66.99, name = "Day Mountain 2" },
            { id = 53579, len = 80.31, name = "Day Mountain 3" },
            { id = 53580, len = 64.34, name = "Night Mountain 1" },
            { id = 53581, len = 63.03, name = "Night Mountain 2" },
            { id = 53582, len = 69.17, name = "Night Mountain 3" },
            { id = 53583, len = 63.97, name = "Night Mountain 4" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Dun Morogh\\Thermapluggs Betrayal.mp3",         len = 181.22, name = "Thermapluggs Betrayal", display = "Thermaplugg's Betrayal" },
            { file = "Dun Morogh\\Tundra MacGranns Stolen Stash.mp3", len = 180.00, name = "Tundra MacGranns Stolen Stash", display = "Tundra MacGrann's Stolen Stash" },
            { file = "Dun Morogh\\The Perfect Stout.mp3",             len = 179.52, name = "The Perfect Stout", display = "The Perfect Stout" },
            { file = "Dun Morogh\\Ammo for Rumbleshot.mp3",           len = 180.00, name = "Ammo for Rumbleshot", display = "Ammo for Rumbleshot" },
            { file = "Dun Morogh\\Beer Basted Boar Ribs.mp3",         len = 179.71, name = "Beer Basted Boar Ribs", display = "Beer Basted Boar Ribs" },
            { file = "Dun Morogh\\Grelin Whitebeards Camp.mp3",       len = 180.02, name = "Grelin Whitebeards Camp", display = "Grelin Whitebeard's Camp" },
        },
        -- Subzone fallback: the Thunderbrew Distillery row (WMO 1970 set 1) is named, so the subzone may read "Thunderbrew Distillery".
        inns = { "Thunderbrew Distillery" },
        -- Thunderbrew Distillery, Kharanos (WMO 1970 set 1, whole building tavern music, ~58 x 45 yd): three circles cover all indoor
        -- groups (placed-WMO group boxes, world -> 1426). Innkeeper Belm 47.4,52.5 inside. No other indoor building within r + 25 yd.
        -- Retail 27 has other bounds, so 1426 only. 1% x = 49.3 yd, 1% y = 32.8 yd.
        innSpots = {
            { name = "Thunderbrew Distillery", maps = { 1426 }, x = 0.4761, y = 0.5297, r = 18 },
            { name = "Thunderbrew Distillery", maps = { 1426 }, x = 0.4761, y = 0.5209, r = 18 },
            { name = "Thunderbrew Distillery", maps = { 1426 }, x = 0.4717, y = 0.5224, r = 19 },
        },
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8181287, 8181289, 8181291, 8181293, 8181295, 8181297, 8181299, 53577, 53578, 53579, 53580, 53581, 53582, 53583 },
    },

    teldrassil = {
        title = "Teldrassil",
        -- 1438 = Teldrassil (Forever/classic-era, area 141), 57 = retail (different bounds), 460 = Shadowglen (retail).
        mapIDs = { 1438, 57, 460 },
        names = { "Teldrassil", "Shadowglen" },
        -- ZoneMusic 11 "Zone-EnchantedForest": SoundKits 2530 (day) + 2540 (night), same 5 files. Same kit as Ashenvale.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53453, len = 49.95, name = "Enchanted Forest 1" },
            { id = 53454, len = 67.00, name = "Enchanted Forest 2" },
            { id = 53455, len = 234.77, name = "Enchanted Forest 3" },
            { id = 53456, len = 60.71, name = "Enchanted Forest 4" },
            { id = 53457, len = 70.67, name = "Enchanted Forest 5" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Teldrassil\\The Balance of Nature.mp3",      len = 219.24, name = "The Balance of Nature", display = "The Balance of Nature" },
            { file = "Teldrassil\\Crown of the Earth.mp3",         len = 204.84, name = "Crown of the Earth", display = "Crown of the Earth" },
            { file = "Teldrassil\\The Sleeping Druid.mp3",         len = 199.39, name = "The Sleeping Druid", display = "The Sleeping Druid" },
            { file = "Teldrassil\\Denalans Timberling Garden.mp3", len = 219.67, name = "Denalans Timberling Garden", display = "Denalan's Timberling Garden" },
            { file = "Teldrassil\\Zenn Foulhoofs Bargain.mp3",     len = 199.99, name = "Zenn Foulhoofs Bargain", display = "Zenn Foulhoof's Bargain" },
            { file = "Teldrassil\\Vesprystus Takes Flight.mp3",    len = 193.94, name = "Vesprystus Takes Flight", display = "Vesprystus Takes Flight" },
        },
        -- No tavern music in Teldrassil (Dolanaar inn, nightelfinn WMO 727: no tavern rows).
        inns = {},
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8180784, 8180786, 8180788, 8180790, 8180792, 53453, 53454, 53455, 53456, 53457 },
    },

    durotar = {
        title = "Durotar",
        -- 1411 = Durotar (Forever/classic-era, area 14), 1 = retail (same bounds), 461/463 retail sub-maps. Forever's 2524
        -- "Darkspear Islands" is a separate instance map (2997), not part of Durotar.
        mapIDs = { 1411, 1, 461, 463 },
        names = { "Durotar", "Valley of Trials", "Echo Isles" },
        -- ZoneMusic 9 "Zone-Plains": SoundKits 2528 (day) + 2538 (night), same 4 files. Same kit as Westfall and Mulgore.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53680, len = 53.76, name = "Day Plains 1" },
            { id = 53681, len = 76.54, name = "Day Plains 2" },
            { id = 53682, len = 58.38, name = "Night Plains 1" },
            { id = 53683, len = 68.62, name = "Night Plains 2" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Durotar\\The Land Named for Durotan.mp3",  len = 179.83, name = "The Land Named for Durotan", display = "The Land Named for Durotan" },
            { file = "Durotar\\Your Place in the World.mp3",     len = 178.80, name = "Your Place in the World", display = "Your Place in the World" },
            { file = "Durotar\\Burning Blade at Skull Rock.mp3", len = 180.02, name = "Burning Blade at Skull Rock", display = "Burning Blade at Skull Rock" },
            { file = "Durotar\\GarThok Stands Watch.mp3",        len = 179.45, name = "GarThok Stands Watch", display = "Gar'Thok Stands Watch" },
            { file = "Durotar\\Zalazanes Echo Isles.mp3",        len = 179.95, name = "Zalazanes Echo Isles", display = "Zalazane's Echo Isles" },
            { file = "Durotar\\Proudmoores Fallen Fleet.mp3",    len = 179.42, name = "Proudmoores Fallen Fleet", display = "Proudmoore's Fallen Fleet" },
        },
        -- Razor Hill inn (orcinn WMO 1849) has no tavern music. Sen'jin Village itself (area 367) plays Zone-TavernHorde outdoors
        -- too; that is a village, not a building, so only the hut is a spot (add "Sen'jin Village" to inns to go quiet in the whole village).
        inns = {},
        -- Sen'jin Village hut (troll_hotel01, WMO 1198: tavern music 185 for the whole building, ~50 x 52 yd): two circles over its one
        -- indoor group. K'waii, Kali Remik, Ula'elek inside. The other huts (trollhut01) have no indoor groups.
        -- 1411 = retail 1 (same bounds). 1% x = 52.9 yd, 1% y = 35.3 yd.
        innSpots = {
            { name = "Sen'jin Village hut", maps = { 1411, 1 }, x = 0.5650, y = 0.7386, r = 23 },
            { name = "Sen'jin Village hut", maps = { 1411, 1 }, x = 0.5614, y = 0.7366, r = 23 },
        },
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8181305, 8181307, 8181309, 8181311, 53680, 53681, 53682, 53683 },
    },

    mulgore = {
        title = "Mulgore",
        -- 1412 = Mulgore (Forever, area 215; Forever's rectangle is larger than classic-era 1412), 7 = retail, 462 = Camp Narache.
        mapIDs = { 1412, 7, 462 },
        names = { "Mulgore", "Camp Narache" },
        -- ZoneMusic 9 "Zone-Plains": SoundKits 2528 (day) + 2538 (night), same 4 files. Same kit as Westfall and Durotar.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53680, len = 53.76, name = "Day Plains 1" },
            { id = 53681, len = 76.54, name = "Day Plains 2" },
            { id = 53682, len = 58.38, name = "Night Plains 1" },
            { id = 53683, len = 68.62, name = "Night Plains 2" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Mulgore\\The Hunt Begins.mp3",               len = 202.82, name = "The Hunt Begins", display = "The Hunt Begins" },
            { file = "Mulgore\\Baine Bloodhoofs Hearth.mp3",       len = 214.75, name = "Baine Bloodhoofs Hearth", display = "Baine Bloodhoof's Hearth" },
            { file = "Mulgore\\Water of the Seers.mp3",            len = 206.42, name = "Water of the Seers", display = "Water of the Seers" },
            { file = "Mulgore\\Arracheas Horn.mp3",                len = 199.99, name = "Arracheas Horn", display = "Arra'chea's Horn" },
            { file = "Mulgore\\Winterhoof Cleansing.mp3",          len = 213.62, name = "Winterhoof Cleansing", display = "Winterhoof Cleansing" },
            { file = "Mulgore\\Ancestral Spirit of Red Rocks.mp3", len = 202.99, name = "Ancestral Spirit of Red Rocks", display = "Ancestral Spirit of Red Rocks" },
        },
        -- No tavern music in Mulgore (Bloodhoof Village longhouse, WMO 704: no tavern rows).
        inns = {},
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8181305, 8181307, 8181309, 8181311, 53680, 53681, 53682, 53683 },
    },

    tirisfal = {
        title = "Tirisfal Glades",
        -- 1420 = Tirisfal Glades (Forever/classic-era, area 85), 18 = retail (same bounds), 465 = Deathknell (retail).
        mapIDs = { 1420, 18, 465 },
        names = { "Tirisfal Glades", "Deathknell" },
        -- ZoneMusic 2 "Zone-EvilForest": SoundKit 2524 (day and night), 6 files. Same kit as Silverpine and Duskwood.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53486, len = 70.74, name = "Day Evil Forest 1" },
            { id = 53487, len = 72.15, name = "Day Evil Forest 2" },
            { id = 53488, len = 70.66, name = "Day Evil Forest 3" },
            { id = 53489, len = 57.29, name = "Night Evil Forest 1" },
            { id = 53490, len = 75.49, name = "Night Evil Forest 2" },
            { id = 53491, len = 70.56, name = "Night Evil Forest 3" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Tirisfal Glades\\Undertaker Mordos Welcome.mp3",  len = 202.99, name = "Undertaker Mordos Welcome", display = "Undertaker Mordo's Welcome" },
            { file = "Tirisfal Glades\\Toll for Gallows End.mp3",       len = 178.20, name = "Toll for Gallows End", display = "Toll for Gallows' End" },
            { file = "Tirisfal Glades\\Whitemanes Midnight Prayer.mp3", len = 189.96, name = "Whitemanes Midnight Prayer", display = "Whitemane's Midnight Prayer" },
            { file = "Tirisfal Glades\\The Agamand Family Crypt.mp3",   len = 194.83, name = "The Agamand Family Crypt", display = "The Agamand Family Crypt" },
            { file = "Tirisfal Glades\\Marlas Last Wish.mp3",           len = 183.98, name = "Marlas Last Wish", display = "Marla's Last Wish" },
            { file = "Tirisfal Glades\\KelThuzads Plagued Grain.mp3",   len = 189.12, name = "KelThuzads Plagued Grain", display = "Kel'Thuzad's Plagued Grain" },
        },
        -- Gallows' End Tavern is a real subzone (AreaTable 2119) and a named WMO row: kept as the subzone fallback.
        inns = { "Gallows' End Tavern" },
        -- Gallows' End Tavern, Brill (duskwood_inn WMO 133 set 1: Zone-TavernHorde01, whole building, ~58 x 33 yd): two circles.
        -- Innkeeper Renee 61.7,52.0 inside. Nearest other indoor building: Brill town hall, 29 yd from the east center.
        -- 1420 = retail 18 (same bounds). 1% x = 45.2 yd, 1% y = 30.1 yd.
        innSpots = {
            { name = "Gallows' End Tavern", maps = { 1420, 18 }, x = 0.6174, y = 0.5251, r = 20 },
            { name = "Gallows' End Tavern", maps = { 1420, 18 }, x = 0.6182, y = 0.5168, r = 19 },
        },
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8180758, 8180760, 8180762, 8180772, 8180774, 8180776, 53486, 53487, 53488, 53489, 53490, 53491 },
    },

    ["loch-modan"] = {
        title = "Loch Modan",
        -- 1432 = Loch Modan (Forever/classic-era, area 38), 48 = retail (same bounds).
        mapIDs = { 1432, 48 },
        names = { "Loch Modan" },
        -- ZoneMusic 1 "Zone-Forest": SoundKit 2523 (day and night), 3 files. Same kit as Elwynn, Redridge and Hillsbrad.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53492, len = 55.69, name = "Day Forest 1" },
            { id = 53493, len = 72.52, name = "Day Forest 2" },
            { id = 53494, len = 64.71, name = "Day Forest 3" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Loch Modan\\Thelsamar Blood Sausages.mp3",    len = 184.39, name = "Thelsamar Blood Sausages", display = "Thelsamar Blood Sausages" },
            { file = "Loch Modan\\A Dark Threat Looms.mp3",         len = 203.42, name = "A Dark Threat Looms", display = "A Dark Threat Looms" },
            { file = "Loch Modan\\Bingles Missing Supplies.mp3",    len = 197.18, name = "Bingles Missing Supplies", display = "Bingles' Missing Supplies" },
            { file = "Loch Modan\\Through the Valley of Kings.mp3", len = 202.82, name = "Through the Valley of Kings", display = "Through the Valley of Kings" },
            { file = "Loch Modan\\Tales of Farstrider Lodge.mp3",   len = 202.82, name = "Tales of Farstrider Lodge", display = "Tales of Farstrider Lodge" },
            { file = "Loch Modan\\Excavation Progress Report.mp3",  len = 204.72, name = "Excavation Progress Report", display = "Excavation Progress Report" },
        },
        -- Subzone fallback: "Stoutlager Inn" (named row of WMO 1971 set 1).
        inns = { "Stoutlager Inn" },
        -- Stoutlager Inn, Thelsamar (wet_inn WMO 1971 set 1, whole building, ~54 x 60 yd): three circles. Innkeeper Hearthstove
        -- 35.5,48.4 inside. Nearest other indoor building: a Thelsamar house, 29 yd from the west center.
        -- 1432 = retail 48 (same bounds). 1% x = 27.6 yd, 1% y = 18.4 yd.
        innSpots = {
            { name = "Stoutlager Inn", maps = { 1432, 48 }, x = 0.3552, y = 0.4946, r = 18 },
            { name = "Stoutlager Inn", maps = { 1432, 48 }, x = 0.3510, y = 0.4837, r = 19 },
            { name = "Stoutlager Inn", maps = { 1432, 48 }, x = 0.3453, y = 0.4987, r = 18 },
        },
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8180778, 8180780, 8180782, 53492, 53493, 53494 },
    },

    darkshore = {
        title = "Darkshore",
        -- 1439 = Darkshore (Forever/classic-era, area 148), 62 = retail (different bounds).
        mapIDs = { 1439, 62 },
        names = { "Darkshore" },
        -- ZoneMusic 191 "Zone-DarkForest": SoundKit 5376 (day and night), the 4 Night Forest files.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53495, len = 53.19, name = "Night Forest 1" },
            { id = 53496, len = 42.97, name = "Night Forest 2" },
            { id = 53497, len = 59.32, name = "Night Forest 3" },
            { id = 53498, len = 54.31, name = "Night Forest 4" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Darkshore\\The Absent Minded Prospector.mp3",  len = 217.99, name = "The Absent Minded Prospector", display = "The Absent Minded Prospector" },
            { file = "Darkshore\\The Masters Glaive.mp3",            len = 204.48, name = "The Masters Glaive", display = "The Master's Glaive" },
            { file = "Darkshore\\The Ghost of Anaya Dawnrunner.mp3", len = 197.64, name = "The Ghost of Anaya Dawnrunner", display = "The Ghost of Anaya Dawnrunner" },
            { file = "Darkshore\\The Tower of Althalaxx.mp3",        len = 223.22, name = "The Tower of Althalaxx", display = "The Tower of Althalaxx" },
            { file = "Darkshore\\Onu, Ancient of Lore.mp3",          len = 189.62, name = "Onu, Ancient of Lore", display = "Onu, Ancient of Lore" },
            { file = "Darkshore\\Washed Ashore.mp3",                 len = 183.96, name = "Washed Ashore", display = "Washed Ashore" },
        },
        -- Auberdine inn (dsnightelfinn WMO 894) has no tavern music.
        inns = {},
        -- The only Darkshore building with tavern music is the hut (troll_hotel01, WMO 1198) of the hidden troll village in the
        -- far north-east (Shatterspear camp, 68,18; not reachable in normal play in Classic). Kept for completeness. 1439 only.
        innSpots = {
            { name = "Shatterspear troll village hut", maps = { 1439 }, x = 0.6809, y = 0.1828, r = 23 },
            { name = "Shatterspear troll village hut", maps = { 1439 }, x = 0.6838, y = 0.1811, r = 23 },
        },
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8180764, 8180766, 8180768, 8180770, 53495, 53496, 53497, 53498 },
    },

    ["silverpine-forest"] = {
        title = "Silverpine Forest",
        -- 1421 = Silverpine Forest (Forever/classic-era, area 130), 21 = retail (same bounds).
        mapIDs = { 1421, 21 },
        names = { "Silverpine Forest" },
        -- ZoneMusic 2 "Zone-EvilForest": SoundKit 2524 (day and night), 6 files. Same kit as Tirisfal and Duskwood.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53486, len = 70.74, name = "Day Evil Forest 1" },
            { id = 53487, len = 72.15, name = "Day Evil Forest 2" },
            { id = 53488, len = 70.66, name = "Day Evil Forest 3" },
            { id = 53489, len = 57.29, name = "Night Evil Forest 1" },
            { id = 53490, len = 75.49, name = "Night Evil Forest 2" },
            { id = 53491, len = 70.56, name = "Night Evil Forest 3" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Silverpine Forest\\Arugals Folly.mp3",            len = 168.19, name = "Arugals Folly", display = "Arugal's Folly" },
            { file = "Silverpine Forest\\Baron Silverlaines Halls.mp3", len = 179.64, name = "Baron Silverlaines Halls", display = "Baron Silverlaine's Halls" },
            { file = "Silverpine Forest\\Pyrewood After Moonrise.mp3",  len = 173.59, name = "Pyrewood After Moonrise", display = "Pyrewood After Moonrise" },
            { file = "Silverpine Forest\\The Shadowfang Blade.mp3",     len = 164.83, name = "The Shadowfang Blade", display = "The Shadowfang Blade" },
            { file = "Silverpine Forest\\Beyond the Greymane Wall.mp3", len = 174.00, name = "Beyond the Greymane Wall", display = "Beyond the Greymane Wall" },
            { file = "Silverpine Forest\\Wizards of Ambermill.mp3",     len = 174.43, name = "Wizards of Ambermill", display = "Wizards of Ambermill" },
        },
        -- The Sepulcher inn (crypt WMO 712) has no tavern music. No subzone of its own for the Pyrewood inn.
        inns = {},
        -- Pyrewood Village inn (duskwood_inn WMO 133 set 0: TavernAlliance, whole building, ~27 x 57 yd): two circles. Nearest other
        -- indoor building: a farmhouse 24 yd from the south center (outside r 20, inside the r + 10 hold only once in the inn).
        -- 1421 = retail 21 (same bounds). 1% x = 42.0 yd, 1% y = 28.0 yd.
        innSpots = {
            { name = "Pyrewood Village inn", maps = { 1421, 21 }, x = 0.4353, y = 0.7309, r = 20 },
            { name = "Pyrewood Village inn", maps = { 1421, 21 }, x = 0.4292, y = 0.7312, r = 19 },
        },
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8180758, 8180760, 8180762, 8180772, 8180774, 8180776, 53486, 53487, 53488, 53489, 53490, 53491 },
    },

    barrens = {
        title = "The Barrens",
        -- 1413 = The Barrens (Forever/classic-era, area 17, the whole classic zone), 10/199 = retail Northern/Southern Barrens.
        mapIDs = { 1413, 10, 199 },
        names = { "The Barrens", "Northern Barrens", "Southern Barrens" },
        -- ZoneMusic 7 "Zone-BarrenDry": SoundKit 2536 (day and night), 6 files. Same kit as Stonetalon.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53299, len = 64.14, name = "Day Barrens 1" },
            { id = 53300, len = 64.19, name = "Day Barrens 2" },
            { id = 53301, len = 55.36, name = "Day Barrens 3" },
            { id = 53302, len = 67.40, name = "Night Barrens 1" },
            { id = 53303, len = 40.92, name = "Night Barrens 2" },
            { id = 53304, len = 47.47, name = "Night Barrens 3" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "The Barrens\\Searching for Mankriks Wife.mp3", len = 223.20, name = "Searching for Mankriks Wife", display = "Searching for Mankrik's Wife" },
            { file = "The Barrens\\Baron Longshores Bounty.mp3",     len = 194.83, name = "Baron Longshores Bounty", display = "Baron Longshore's Bounty" },
            { file = "The Barrens\\Naralexs Nightmare.mp3",          len = 202.82, name = "Naralexs Nightmare", display = "Naralex's Nightmare" },
            { file = "The Barrens\\The Forgotten Pools.mp3",         len = 194.90, name = "The Forgotten Pools", display = "The Forgotten Pools" },
            { file = "The Barrens\\Echeyakees Night Prowl.mp3",      len = 208.03, name = "Echeyakees Night Prowl", display = "Echeyakee's Night Prowl" },
            { file = "The Barrens\\Mangletooths Blood Shards.mp3",   len = 203.23, name = "Mangletooths Blood Shards", display = "Mangletooth's Blood Shards" },
        },
        -- No tavern music at the Crossroads (orcinn WMO 1849) or Camp Taurajo (longhouse WMO 704). Ratchet stays in the Barrens.
        inns = {},
        -- Ratchet inn (ratchet_inn WMO 1916 set 0: TavernAlliance, whole building, ~35 x 41 yd): two circles. Innkeeper Wiley
        -- 62.0,39.4 inside. Nearest other indoor building: a Ratchet house 35 yd away. 1413 only (retail 10 differs).
        -- 1% x = 101.3 yd, 1% y = 67.6 yd.
        innSpots = {
            { name = "Ratchet inn", maps = { 1413 }, x = 0.6185, y = 0.3940, r = 18 },
            { name = "Ratchet inn", maps = { 1413 }, x = 0.6203, y = 0.3945, r = 18 },
        },
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8181049, 8181051, 8181053, 8181055, 8181057, 8181059, 53299, 53300, 53301, 53302, 53303, 53304 },
    },

    ["redridge-mountains"] = {
        title = "Redridge Mountains",
        -- 1433 = Redridge Mountains (Forever, area 44; its rectangle differs from classic-era 1433), 49 = retail.
        mapIDs = { 1433, 49 },
        names = { "Redridge Mountains" },
        -- ZoneMusic 1 "Zone-Forest": SoundKit 2523 (day and night), 3 files. Same kit as Elwynn, Loch Modan and Hillsbrad.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53492, len = 55.69, name = "Day Forest 1" },
            { id = 53493, len = 72.52, name = "Day Forest 2" },
            { id = 53494, len = 64.71, name = "Day Forest 3" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Redridge Mountains\\Magistrate Solomons Plea.mp3",   len = 194.52, name = "Magistrate Solomons Plea", display = "Magistrate Solomon's Plea" },
            { file = "Redridge Mountains\\Keeshan, Missing in Action.mp3", len = 194.90, name = "Keeshan, Missing in Action", display = "Keeshan, Missing in Action" },
            { file = "Redridge Mountains\\Redridge Goulash.mp3",           len = 202.03, name = "Redridge Goulash", display = "Redridge Goulash" },
            { file = "Redridge Mountains\\Foreman Oslows Lost Tools.mp3",  len = 212.04, name = "Foreman Oslows Lost Tools", display = "Foreman Oslow's Lost Tools" },
            { file = "Redridge Mountains\\GathIlzogg Over Stonewatch.mp3", len = 212.47, name = "GathIlzogg Over Stonewatch", display = "Gath'Ilzogg Over Stonewatch" },
            { file = "Redridge Mountains\\Hilarys Necklace.mp3",           len = 199.58, name = "Hilarys Necklace", display = "Hilary's Necklace" },
        },
        -- Subzone fallback: "Lakeshire Inn" (named row of WMO 144 set 1).
        inns = { "Lakeshire Inn" },
        -- Lakeshire Inn (redridge_inn WMO 144 set 1, whole building, ~57 x 27 yd): two circles. Innkeeper Brianna 21.9,44.8 inside.
        -- Nearest other indoor building: the town hall, 30 yd from both centers. 1433 only. 1% x = 21.7 yd, 1% y = 14.5 yd.
        innSpots = {
            { name = "Lakeshire Inn", maps = { 1433 }, x = 0.2177, y = 0.4516, r = 19 },
            { name = "Lakeshire Inn", maps = { 1433 }, x = 0.2177, y = 0.4340, r = 19 },
        },
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8180778, 8180780, 8180782, 53492, 53493, 53494 },
    },

    ["stonetalon-mountains"] = {
        title = "Stonetalon Mountains",
        -- 1442 = Stonetalon Mountains (Forever/classic-era, area 406), 65 = retail (different bounds).
        mapIDs = { 1442, 65 },
        names = { "Stonetalon Mountains" },
        -- ZoneMusic 7 "Zone-BarrenDry": SoundKit 2536 (day and night), 6 files. Same kit as the Barrens.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53299, len = 64.14, name = "Day Barrens 1" },
            { id = 53300, len = 64.19, name = "Day Barrens 2" },
            { id = 53301, len = 55.36, name = "Day Barrens 3" },
            { id = 53302, len = 67.40, name = "Night Barrens 1" },
            { id = 53303, len = 40.92, name = "Night Barrens 2" },
            { id = 53304, len = 47.47, name = "Night Barrens 3" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Stonetalon Mountains\\Darkness of the Talondeep Path.mp3", len = 204.84, name = "Darkness of the Talondeep Path", display = "Darkness of the Talondeep Path" },
            { file = "Stonetalon Mountains\\The Super Reaper 6000.mp3",          len = 232.03, name = "The Super Reaper 6000", display = "The Super Reaper 6000" },
            { file = "Stonetalon Mountains\\Protect Kaya Flathoof.mp3",          len = 178.82, name = "Protect Kaya Flathoof", display = "Protect Kaya Flathoof" },
            { file = "Stonetalon Mountains\\JinZils Forest Magic.mp3",           len = 213.62, name = "JinZils Forest Magic", display = "Jin'Zil's Forest Magic" },
            { file = "Stonetalon Mountains\\Where the Bloodfury Roost.mp3",      len = 212.52, name = "Where the Bloodfury Roost", display = "Where the Bloodfury Roost" },
            { file = "Stonetalon Mountains\\Besseleths Web.mp3",                 len = 209.88, name = "Besseleths Web", display = "Besseleth's Web" },
        },
        -- Stonetalon Peak and Sun Rock Retreat inns have no tavern music. Malaka'jin (area 2539) plays Zone-TavernHorde outdoors too.
        inns = {},
        -- Malaka'jin den (md_trollden_warm WMO 1183 set 1: TavernHorde, whole building, ~41 x 39 yd): one circle. Witch Doctor
        -- Jin'Zil inside. No other indoor building nearby. 1442 only. 1% x = 48.8 yd, 1% y = 32.6 yd.
        innSpots = {
            { name = "Malaka'jin den", maps = { 1442 }, x = 0.7459, y = 0.9787, r = 21 },
        },
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8181049, 8181051, 8181053, 8181055, 8181057, 8181059, 53299, 53300, 53301, 53302, 53303, 53304 },
    },

    duskwood = {
        title = "Duskwood",
        -- 1431 = Duskwood (Forever/classic-era, area 10), 47 = retail (same bounds).
        mapIDs = { 1431, 47 },
        names = { "Duskwood" },
        -- ZoneMusic 2 "Zone-EvilForest": SoundKit 2524 (day and night), 6 files. Same kit as Tirisfal and Silverpine.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53486, len = 70.74, name = "Day Evil Forest 1" },
            { id = 53487, len = 72.15, name = "Day Evil Forest 2" },
            { id = 53488, len = 70.66, name = "Day Evil Forest 3" },
            { id = 53489, len = 57.29, name = "Night Evil Forest 1" },
            { id = 53490, len = 75.49, name = "Night Evil Forest 2" },
            { id = 53491, len = 70.56, name = "Night Evil Forest 3" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Duskwood\\Worgen in the Woods.mp3",           len = 172.82, name = "Worgen in the Woods", display = "Worgen in the Woods" },
            { file = "Duskwood\\Elizas Shallow Grave.mp3",          len = 173.42, name = "Elizas Shallow Grave", display = "Eliza's Shallow Grave" },
            { file = "Duskwood\\Stitches Marches on Darkshire.mp3", len = 218.83, name = "Stitches Marches on Darkshire", display = "Stitches Marches on Darkshire" },
            { file = "Duskwood\\Ballad of Stalvan Mistmantle.mp3",  len = 202.92, name = "Ballad of Stalvan Mistmantle", display = "Ballad of Stalvan Mistmantle" },
            { file = "Duskwood\\Ebonlockes Night Watch.mp3",        len = 174.43, name = "Ebonlockes Night Watch", display = "Ebonlocke's Night Watch" },
            { file = "Duskwood\\Morbents Bane.mp3",                 len = 162.84, name = "Morbents Bane", display = "Morbent's Bane" },
        },
        -- Subzone fallback: "Scarlet Raven Tavern" (named row of WMO 133 set 2).
        inns = { "Scarlet Raven Tavern" },
        -- Scarlet Raven Tavern, Darkshire (duskwood_inn WMO 133 set 2, whole building, ~59 x 30 yd): two circles. Innkeeper Trelayne
        -- 73.9,44.4 and Barkeep Hann inside. Nearest other indoor building: a Darkshire house, 39 yd away.
        -- 1431 = retail 47 (same bounds). 1% x = 27.0 yd, 1% y = 18.0 yd.
        innSpots = {
            { name = "Scarlet Raven Tavern", maps = { 1431, 47 }, x = 0.7397, y = 0.4501, r = 19 },
            { name = "Scarlet Raven Tavern", maps = { 1431, 47 }, x = 0.7386, y = 0.4360, r = 19 },
        },
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8180758, 8180760, 8180762, 8180772, 8180774, 8180776, 53486, 53487, 53488, 53489, 53490, 53491 },
    },

    ashenvale = {
        title = "Ashenvale",
        -- 1440 = Ashenvale (Forever/classic-era, area 331), 63 = retail (same bounds).
        mapIDs = { 1440, 63 },
        names = { "Ashenvale" },
        -- ZoneMusic 11 "Zone-EnchantedForest": SoundKits 2530 (day) + 2540 (night), same 5 files. Same kit as Teldrassil.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53453, len = 49.95, name = "Enchanted Forest 1" },
            { id = 53454, len = 67.00, name = "Enchanted Forest 2" },
            { id = 53455, len = 234.77, name = "Enchanted Forest 3" },
            { id = 53456, len = 60.71, name = "Enchanted Forest 4" },
            { id = 53457, len = 70.67, name = "Enchanted Forest 5" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Ashenvale\\Where Mannoroth Fell.mp3",        len = 172.92, name = "Where Mannoroth Fell", display = "Where Mannoroth Fell" },
            { file = "Ashenvale\\Lament for Cenarius.mp3",         len = 159.12, name = "Lament for Cenarius", display = "Lament for Cenarius" },
            { file = "Ashenvale\\Whispers at Aessinas Shrine.mp3", len = 180.00, name = "Whispers at Aessinas Shrine", display = "Whispers at Aessina's Shrine" },
            { file = "Ashenvale\\Twilight at Bough Shadow.mp3",    len = 179.83, name = "Twilight at Bough Shadow", display = "Twilight at Bough Shadow" },
            { file = "Ashenvale\\Raenes Cleansing.mp3",            len = 174.79, name = "Raenes Cleansing", display = "Raene's Cleansing" },
            { file = "Ashenvale\\Akumai of Blackfathom Deeps.mp3", len = 169.63, name = "Akumai of Blackfathom Deeps", display = "Aku'mai of Blackfathom Deeps" },
        },
        -- No building with tavern music (Astranaar nightelfinn 727, Splintertree orcinn 1849). Zoram'gar Outpost (area 2897) plays
        -- Zone-TavernHorde outdoors; a camp, not a building, so the rotation keeps playing (add it to inns to go quiet there).
        inns = {},
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8180784, 8180786, 8180788, 8180790, 8180792, 53453, 53454, 53455, 53456, 53457 },
    },

    wetlands = {
        title = "Wetlands",
        -- 1437 = Wetlands (Forever/classic-era, area 11), 56 = retail (same bounds).
        mapIDs = { 1437, 56 },
        names = { "Wetlands" },
        -- ZoneMusic 227 "Zone-Soggy": SoundKits 7082 (day) + 6836 (night), same 5 files.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53695, len = 97.18, name = "Soggy Place 1" },
            { id = 53696, len = 97.42, name = "Soggy Place 2" },
            { id = 53697, len = 90.52, name = "Soggy Place 3" },
            { id = 53698, len = 89.37, name = "Soggy Place 4" },
            { id = 53699, len = 70.36, name = "Soggy Place 5" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Wetlands\\Captive Queen of Grim Batol.mp3",   len = 183.00, name = "Captive Queen of Grim Batol", display = "Captive Queen of Grim Batol" },
            { file = "Wetlands\\Stoutfist Holds Menethil Keep.mp3", len = 193.15, name = "Stoutfist Holds Menethil Keep", display = "Stoutfist Holds Menethil Keep" },
            { file = "Wetlands\\Fall of Dun Modr.mp3",              len = 199.99, name = "Fall of Dun Modr", display = "Fall of Dun Modr" },
            { file = "Wetlands\\Ironbeards Silent Tomb.mp3",        len = 187.87, name = "Ironbeards Silent Tomb", display = "Ironbeard's Silent Tomb" },
            { file = "Wetlands\\Rain on the Thandol Span.mp3",      len = 142.75, name = "Rain on the Thandol Span", display = "Rain on the Thandol Span" },
            { file = "Wetlands\\Wings of the Dragonmaw.mp3",        len = 182.42, name = "Wings of the Dragonmaw", display = "Wings of the Dragonmaw" },
        },
        -- Subzone fallbacks: "Deepwater Tavern" (named row of WMO 53 set 1) and "The Drunken Dwarf" (Forever-only subzone,
        -- AreaTable 17738, Zone-DwavesTavern, 4 terrain chunks near 52,80 by the dwarven tunnels; not in Classic Era).
        inns = { "Deepwater Tavern", "The Drunken Dwarf" },
        -- Deepwater Tavern, Menethil (goldshireinn WMO 53 set 1, ~57 x 27 yd): two circles; Innkeeper Helbrek 10.7,61.0 inside;
        -- blacksmith 32 yd away. Dun Modr tavern (wet_tavern WMO 619 set 2, ~45 x 32 yd, Dark Iron dwarves inside): two circles.
        -- Menethil Harbor ship (transportship_a WMO 909 set 0, the ship moored at the docks: its hold has TavernAlliance): two
        -- circles. 1437 = retail 56 (same bounds). 1% x = 41.4 yd, 1% y = 27.6 yd.
        innSpots = {
            { name = "Deepwater Tavern", maps = { 1437, 56 }, x = 0.1065, y = 0.6130, r = 19 },
            { name = "Deepwater Tavern", maps = { 1437, 56 }, x = 0.1065, y = 0.6039, r = 19 },
            { name = "Dun Modr tavern", maps = { 1437, 56 }, x = 0.4689, y = 0.1793, r = 21 },
            { name = "Dun Modr tavern", maps = { 1437, 56 }, x = 0.4675, y = 0.1854, r = 20 },
            { name = "Menethil Harbor ship", maps = { 1437, 56 }, x = 0.0658, y = 0.5949, r = 17 },
            { name = "Menethil Harbor ship", maps = { 1437, 56 }, x = 0.0696, y = 0.5917, r = 15 },
        },
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8181011, 8181013, 8181015, 8181017, 8181019, 53695, 53696, 53697, 53698, 53699 },
    },

    ["hillsbrad-foothills"] = {
        title = "Hillsbrad Foothills",
        -- 1424 = Hillsbrad Foothills (Forever/classic-era, area 267), 25 = retail (different bounds).
        mapIDs = { 1424, 25 },
        names = { "Hillsbrad Foothills" },
        -- ZoneMusic 1 "Zone-Forest": SoundKit 2523 (day and night), 3 files. Same kit as Elwynn, Loch Modan and Redridge.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53492, len = 55.69, name = "Day Forest 1" },
            { id = 53493, len = 72.52, name = "Day Forest 2" },
            { id = 53494, len = 64.71, name = "Day Forest 3" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Hillsbrad Foothills\\Southshore Versus Tarren Mill.mp3", len = 179.64, name = "Southshore Versus Tarren Mill", display = "Southshore Versus Tarren Mill" },
            { file = "Hillsbrad Foothills\\Apothecary Lydons Experiment.mp3",  len = 180.02, name = "Apothecary Lydons Experiment", display = "Apothecary Lydon's Experiment" },
            { file = "Hillsbrad Foothills\\Farmer Rays Last Harvest.mp3",      len = 204.02, name = "Farmer Rays Last Harvest", display = "Farmer Ray's Last Harvest" },
            { file = "Hillsbrad Foothills\\Last Stand at Dun Garok.mp3",       len = 193.34, name = "Last Stand at Dun Garok", display = "Last Stand at Dun Garok" },
            { file = "Hillsbrad Foothills\\Thralls Escape from Durnholde.mp3", len = 198.24, name = "Thralls Escape from Durnholde", display = "Thrall's Escape from Durnholde" },
            { file = "Hillsbrad Foothills\\The Traitor King of Alterac.mp3",   len = 193.46, name = "The Traitor King of Alterac", display = "The Traitor King of Alterac" },
        },
        -- Tarren Mill inn (duskwoodabandoned house WMO 121) has no tavern music. No subzone of its own for the Southshore inn.
        inns = {},
        -- Southshore inn (westfall_inn WMO 153 set 0: TavernAlliance, whole building, ~26 x 57 yd): two circles. Innkeeper Anderson
        -- 51.2,58.9 and Barkeep Kelly inside. Nearest other indoor building: a farmhouse 31 yd away. 1424 only.
        -- 1% x = 32.0 yd, 1% y = 21.3 yd.
        innSpots = {
            { name = "Southshore Inn", maps = { 1424 }, x = 0.5099, y = 0.5880, r = 19 },
            { name = "Southshore Inn", maps = { 1424 }, x = 0.5182, y = 0.5875, r = 19 },
        },
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8180778, 8180780, 8180782, 53492, 53493, 53494 },
    },

    ["stranglethorn-vale"] = {
        title = "Stranglethorn Vale",
        -- 1434 = Stranglethorn Vale (Forever/classic-era, area 33, whole classic zone), 224 = retail parent map
        -- (different bounds), 50/210 = retail Northern Stranglethorn / Cape. Booty Bay and Grom'gol are subzones (stay in STV).
        mapIDs = { 1434, 224, 50, 210 },
        names = { "Stranglethorn Vale", "Northern Stranglethorn", "The Cape of Stranglethorn" },
        -- ZoneMusic 3 "Zone-Jungle": SoundKits 2535 (day) + 5494 (night), same 6 files.
        -- Classic Era 1.15.9 files (all present in Forever 1.60.1); lengths measured with ffprobe.
        originals = {
            { id = 53541, len = 46.13, name = "Day Jungle 1" },
            { id = 53542, len = 98.72, name = "Day Jungle 2" },
            { id = 53543, len = 48.27, name = "Day Jungle 3" },
            { id = 53544, len = 54.67, name = "Night Jungle 1" },
            { id = 53545, len = 53.37, name = "Night Jungle 2" },
            { id = 53546, len = 89.13, name = "Night Jungle 3" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Stranglethorn Vale\\Echoes of the Gurubashi.mp3",          len = 179.76, name = "Echoes of the Gurubashi", display = "Echoes of the Gurubashi" },
            { file = "Stranglethorn Vale\\The Green Hills of Stranglethorn.mp3", len = 198.67, name = "The Green Hills of Stranglethorn", display = "The Green Hills of Stranglethorn" },
            { file = "Stranglethorn Vale\\Riggle Bassbaits Tournament.mp3",      len = 180.02, name = "Riggle Bassbaits Tournament", display = "Riggle Bassbait's Tournament" },
            { file = "Stranglethorn Vale\\Saving Yenniku.mp3",                   len = 180.00, name = "Saving Yenniku", display = "Saving Yenniku" },
            { file = "Stranglethorn Vale\\Hakkar Sleeps in ZulGurub.mp3",        len = 179.90, name = "Hakkar Sleeps in ZulGurub", display = "Hakkar Sleeps in Zul'Gurub" },
            { file = "Stranglethorn Vale\\Stranglethorn Fever.mp3",              len = 179.90, name = "Stranglethorn Fever", display = "Stranglethorn Fever" },
        },
        -- Subzone fallbacks: "The Salty Sailor Tavern" / "The Salty Sailor" (named rows of the Booty Bay WMO 21064).
        -- Grom'gol inn (orczeppelinhouse WMO 3113) has no tavern music.
        inns = { "The Salty Sailor Tavern", "The Salty Sailor" },
        -- The Salty Sailor Tavern (Booty Bay WMO 21064, groups 83908-83912/83924: Zone-PirateTavern): circles fitted to the
        -- tavern floors; the dock-level room to the east (group 83899) stays outside. Innkeeper Skindle 27.0,77.3 inside.
        -- Zul'Gurub ruins hut (troll_hotel01, WMO 1198: TavernHorde, ~45 x 47 yd) in the ruins outside Zul'Gurub, 63.5,10.5.
        -- 1434 only. 1% x = 63.8 yd, 1% y = 42.5 yd.
        innSpots = {
            { name = "Zul'Gurub ruins hut", maps = { 1434 }, x = 0.6340, y = 0.1062, r = 23 },
            { name = "Zul'Gurub ruins hut", maps = { 1434 }, x = 0.6372, y = 0.1052, r = 23 },
            { name = "The Salty Sailor Tavern", maps = { 1434 }, x = 0.2710, y = 0.7733, r = 15 },
            { name = "The Salty Sailor Tavern", maps = { 1434 }, x = 0.2693, y = 0.7691, r = 17 },
        },
        -- Forever 1.60.1 plays re-encoded copies for the same kit(s); Classic files kept too. Both muted in "sound" mode.
        zoneMusic = { 8181259, 8181261, 8181263, 8181265, 8181267, 8181269, 53541, 53542, 53543, 53544, 53545, 53546 },
    },
    ["zephras-isle"] = {
        title = "Zephras Isle",
        -- 0.5.8: the Skyborne starting zone (levels 1-12), its own continent map (Map 2991, AreaTable 16593).
        -- 2521 = Zephras Isle (Forever 1.60.1 UiMap, parent 947 Azeroth); 2665 = a second UiMap of the same map
        -- (same bounds, UiMapAssignment). One plain zone: no capital, no subzone checks (Valanaar is part of it).
        mapIDs = { 2521, 2665 },
        names = { "Zephras Isle" },
        -- Every zone-music track of the zone (Forever 1.60.1.70205 AreaTable/ZoneMusic/SoundKitEntry), day = night:
        -- ZoneMusic 3230 "Zone-Zephras" (the zone default, kit 317169 = the Cataclysm Skywall tracks) and the subzone
        -- sets 3535 Valanaar (kit 352866), 3553 Gustberry Lowlands (359863), 3554 Shen'dar (359864), 3555 Thendal
        -- Village (359865), 3537 Shrine of Akir (352868), 3536 Shadowgale Forest (352867). Not included: the Valanaar
        -- intro stinger (ZoneIntroMusic 1687, kit 361267 = 8175602) and Thendal Cave's cave music (ZoneMusic 204).
        -- Lengths measured with ffprobe.
        originals = {
            { id = 441744, len = 159.29, name = "Skywall 1" },
            { id = 441753, len = 109.90, name = "Skywall 2" },
            { id = 8175596, len = 54.26, name = "Valanaar 1" },
            { id = 8175598, len = 52.64, name = "Valanaar 2" },
            { id = 8175600, len = 32.26, name = "Valanaar 3" },
            { id = 8158738, len = 73.90, name = "Gustberry Lowlands 1" },
            { id = 8158740, len = 76.64, name = "Gustberry Lowlands 2" },
            { id = 8246678, len = 57.78, name = "Gustberry Lowlands 3" },
            { id = 8246680, len = 71.92, name = "Gustberry Lowlands 4" },
            { id = 8158746, len = 72.78, name = "Shendar 1" },
            { id = 8158748, len = 68.49, name = "Shendar 2" },
            { id = 8246684, len = 68.55, name = "Shendar 3" },
            { id = 8246686, len = 53.79, name = "Shendar 4" },
            { id = 8158754, len = 72.05, name = "Thendal Village 1" },
            { id = 8158756, len = 76.96, name = "Thendal Village 2" },
            { id = 8246692, len = 47.44, name = "Thendal Village 3" },
            { id = 8246694, len = 76.96, name = "Thendal Village 4" },
            { id = 8158750, len = 64.03, name = "Shrine of Akir 1" },
            { id = 8158752, len = 64.03, name = "Shrine of Akir 2" },
            { id = 8246688, len = 53.16, name = "Shrine of Akir 3" },
            { id = 8246690, len = 64.16, name = "Shrine of Akir 4" },
            { id = 8158742, len = 67.94, name = "Shadowgale Forest 1" },
            { id = 8158744, len = 67.03, name = "Shadowgale Forest 2" },
            { id = 8246682, len = 73.93, name = "Shadowgale Forest 3" },
        },
        -- Suno songs; lengths from ffprobe
        customs = {
            { file = "Zephras Isle\\Skydocks of Valanaar.mp3",      len = 180.00, name = "Skydocks of Valanaar", display = "Skydocks of Valanaar" },
            { file = "Zephras Isle\\Gift of Skysight.mp3",          len = 180.00, name = "Gift of Skysight", display = "Gift of Skysight" },
            { file = "Zephras Isle\\Windsong Standing Stones.mp3",  len = 179.64, name = "Windsong Standing Stones", display = "Windsong Standing Stones" },
            { file = "Zephras Isle\\Exiles of EldreThalas.mp3",     len = 179.59, name = "Exiles of EldreThalas", display = "Exiles of Eldre'Thalas" },
            { file = "Zephras Isle\\The Vanished Wind Spirits.mp3", len = 179.59, name = "The Vanished Wind Spirits", display = "The Vanished Wind Spirits" },
            { file = "Zephras Isle\\Shadows of Banaethal.mp3",      len = 180.02, name = "Shadows of Banaethal", display = "Shadows of Ban'aethal" },
        },
        -- No tavern music anywhere on the isle: the Windshaper Lodge (Valanaar) and High Order Lodge rows of WMO 893 set
        -- no music of their own (they inherit the area's), so the rotation keeps playing inside. No inns, no inn spots.
        inns = {},
        -- The same 24 files (each plays only in its own subzone in the game); muted in "sound" mode.
        zoneMusic = { 441744, 441753, 8175596, 8175598, 8175600, 8158738, 8158740, 8246678, 8246680,
                      8158746, 8158748, 8246684, 8246686, 8158754, 8158756, 8246692, 8246694,
                      8158750, 8158752, 8246688, 8246690, 8158742, 8158744, 8246682 },
    },
}
-- Tie-break order when two zones match at the same map level (they don't share IDs/names today).
-- Detection itself is child-first (see ZoneForMap), so a city always beats the zone around it.
local ZONE_ORDER = {
    "stormwind", "ironforge", "darnassus", "orgrimmar", "thunder-bluff", "undercity",           -- capitals
    "elwynn", "dun-morogh", "teldrassil", "durotar", "mulgore", "tirisfal",                    -- 1-10
    "westfall", "loch-modan", "darkshore", "silverpine-forest", "barrens",                      -- 10-25
    "redridge-mountains", "stonetalon-mountains", "duskwood", "ashenvale",                     -- 15-30
    "wetlands", "hillsbrad-foothills", "stranglethorn-vale",                                     -- 20-45
    "zephras-isle",                                                                              -- 1-12, Skyborne (0.5.8)
}

-- Normalize the data once: track objects { name, file, duration, original }, sets for lookups.
for key, z in pairs(ZONES) do
    z.key = key
    z.mapSet, z.nameSet, z.innSet = {}, {}, {}
    for _, id in ipairs(z.mapIDs or {}) do z.mapSet[id] = true end
    for _, n in ipairs(z.names or {}) do z.nameSet[n] = true end
    for _, n in ipairs(z.inns or {}) do z.innSet[n] = true end
    z.origTracks, z.customTracks = {}, {}
    for _, t in ipairs(z.originals or {}) do
        z.origTracks[#z.origTracks + 1] = { name = t.name, file = t.id, duration = t.len, original = true }
    end
    for _, t in ipairs(z.customs or {}) do
        if type(t.len) == "number" and t.len > 0 then -- guard against a bad entry (no timer on a missing length)
            -- 0.5.12: the title shown to the player is display (with apostrophes), else name, else the file name
            local title = t.display or t.name or tostring(t.file):match("([^\\/]+)%.[Mm][Pp]3$") or tostring(t.file)
            z.customTracks[#z.customTracks + 1] = { name = title, fileName = t.name, file = ADDON_DIR .. t.file, duration = t.len }
        end
    end
end

-- 0.5.7: "Leveling Zone Music". The capitals keep their own music whatever the setting; every other zone is a
-- leveling zone (starting zones included). ALL_LEVELING_CUSTOMS = the custom songs of every leveling zone, in
-- ZONE_ORDER (shuffled when a rotation is built), the pool used with MusicPlusDB.pool = "all".
local CAPITALS = { stormwind = true, ironforge = true, darnassus = true, orgrimmar = true, ["thunder-bluff"] = true, undercity = true }
local POOL_VALUES = { "zone", "all" }
local POOL_LABELS = { zone = "For this zone only", all = "Play music from all zones" }
local ALL_LEVELING_CUSTOMS = {}
for _, key in ipairs(ZONE_ORDER) do
    local z = ZONES[key]
    z.city = CAPITALS[key] == true
    if not z.city then
        for _, t in ipairs(z.customTracks) do ALL_LEVELING_CUSTOMS[#ALL_LEVELING_CUSTOMS + 1] = t end
    end
end

-- Map sizes in yards (fallback if C_Map.GetMapWorldSize is missing), from the Forever 1.60.1 UiMapAssignment
-- rectangles; a retail ID is listed only where its rectangle is identical (so the same x, y work on it).
local MAP_YARDS = {
    [1453] = { 1737.50, 1158.33 }, [84] = { 1737.50, 1158.33 },   -- Stormwind City
    [1429] = { 3470.83, 2314.58 }, [37] = { 3470.83, 2314.58 },   -- Elwynn Forest
    [1455] = { 790.63, 527.60 },   [87] = { 790.63, 527.60 },     -- Ironforge
    [1426] = { 4925.00, 3283.33 },                                -- Dun Morogh
    [1411] = { 5287.50, 3525.00 }, [1] = { 5287.50, 3525.00 },    -- Durotar
    [1420] = { 4518.75, 3012.50 }, [18] = { 4518.75, 3012.50 },   -- Tirisfal Glades
    [1432] = { 2758.33, 1839.58 }, [48] = { 2758.33, 1839.58 },   -- Loch Modan
    [1439] = { 6550.00, 4366.67 },                                -- Darkshore
    [1421] = { 4200.00, 2800.00 }, [21] = { 4200.00, 2800.00 },   -- Silverpine Forest
    [1413] = { 10133.33, 6756.25 },                               -- The Barrens
    [1433] = { 2170.83, 1447.92 },                                -- Redridge Mountains
    [1442] = { 4883.33, 3256.25 },                                -- Stonetalon Mountains
    [1431] = { 2700.00, 1800.00 }, [47] = { 2700.00, 1800.00 },   -- Duskwood
    [1437] = { 4135.42, 2756.25 }, [56] = { 4135.42, 2756.25 },   -- Wetlands
    [1424] = { 3200.00, 2133.33 },                                -- Hillsbrad Foothills
    [1434] = { 6381.25, 4254.17 },                                -- Stranglethorn Vale
}
local SAVED_SPOT_RADIUS = 12 -- yards, for spots saved with /mplus inn
local POLL_INN = 0.5         -- seconds between position checks
local INN_ENTER_POLLS = 2    -- polls in a row inside a spot (radius + indoors) before the inn state starts
local INN_EXIT_EXTRA = 10    -- yards added to a spot's radius: the inn state holds anywhere inside that
local INN_EXIT_OUTDOORS = 5  -- polls in a row outdoors (2.5 s) before the inn state ends
local INN_EXIT_FAR = 2       -- polls in a row beyond radius + INN_EXIT_EXTRA before the inn state ends

local DB = { enabled = true, mode = "music", bgSound = true, loop = true, titles = false, pool = "zone" } -- replaced by MusicPlusDB on ADDON_LOADED

local S = {
    active = false, testing = false, rotation = nil, pos = 0, track = nil, handle = nil,
    startTime = 0, gen = 0, timer = nil, ticker = nil, evalTimer = nil, pendingStop = false,
    needRestart = false, debug = false, muted = false, warnedMusicOff = false,
    sawPlaying = false, everHeard = false, interrupted = false, resuming = false,
    lastAttempt = 0, attempts = 0, isPlayingWorks = false,
    zone = nil, nOrig = 0, nCustom = 0, lastFile = nil, mutedIDs = nil, pendingSwitch = nil,
    posTicker = nil, seenState = nil, seenCount = 0, restoreTimer = nil,
    innSpot = nil, innZone = nil, innEnter = 0, innOut = 0, innFar = 0, -- inn-spot hysteresis (latch)
    fade = nil, -- volume fade-out in progress: { orig (number), origStr, last, start, dur, ticker, finishing, wrote (0.5.13) }
    volWriting = false, -- 0.5.13: true during our own Sound_MusicVolume SetCVar (CVAR_UPDATE ignores it)
    gap = nil,  -- 0.5.1 silence between tracks (Loop music off): { start, dur, ticker }; the timer is S.timer
    -- 0.5.3: flight lock and border delay
    taxi = false, taxiZone = nil, -- flight lock on / the zone it keeps playing (nil = MusicPlus off for this flight)
    inWorld = false,              -- between PLAYER_ENTERING_WORLD and PLAYER_LEAVING_WORLD (taxi state is trusted then)
    sawGround = false,            -- not on a taxi at some point this session (else a lock = /reload or login mid-flight)
    promptUntil = 0,              -- GetTime() until which zone changes use the prompt confirmation (loading screen, landing)
    pendingAt = 0, pendingLong = false, -- pending switch (S.pendingSwitch): first reading, walking delay (vs. prompt)
    stopAt = 0, stopLong = false,       -- pending stop (S.pendingStop): the same
}
local RefreshUI -- defined in the options section
local RefreshNowLabel -- defined in the options section (0.5.1)
local ScheduleEvaluate -- defined in the zone evaluation section

local function Print(msg) DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. tostring(msg)) end

-- 0.5.7: the custom songs of zone z's rotation: its own, or (Leveling Zone Music = all, leveling zone) every
-- leveling zone's. A capital always gets its own.
local function CustomPool(z)
    if DB.pool == "all" and not z.city then return ALL_LEVELING_CUSTOMS end
    return z.customTracks
end
local function Debug(msg) if S.debug then Print("|cff999999[debug]|r " .. tostring(msg)) end end

-- 0.5.9: "Disable MusicPlus for this zone" (MusicPlusDB.disabledZones[zone title] = true). A disabled zone is treated
-- as outside the configured zones (see Evaluate / ReadZone / WantedZone).
local function ZoneDisabled(z)
    return z ~= nil and type(DB.disabledZones) == "table" and DB.disabledZones[z.title] == true
end

local function CVarGet(name)
    local ok, v
    if C_CVar and C_CVar.GetCVar then ok, v = pcall(C_CVar.GetCVar, name)
    elseif GetCVar then ok, v = pcall(GetCVar, name) end
    return ok and v or nil
end

local function CVarSet(name, value)
    value = tostring(value)
    if C_CVar and C_CVar.SetCVar then pcall(C_CVar.SetCVar, name, value)
    elseif SetCVar then pcall(SetCVar, name, value) end
end

---------------------------------------------------------------- zone detection
-- Walk the map's parent chain child-first; return the configured zone it belongs to (or nil).
-- Every zone is checked at each level before moving up, so the most specific map wins: Stormwind City
-- (84/1453) matches Stormwind even in a client where its parent is Elwynn Forest, and a child map such as
-- Northshire (425) or an Elwynn mine reaches Elwynn Forest through its parent.
local function ZoneForMap(mapID)
    local depth = 0
    while mapID and mapID > 0 and depth < 12 do
        for _, key in ipairs(ZONE_ORDER) do
            if ZONES[key].mapSet[mapID] then return ZONES[key] end
        end
        local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
        if not info then return nil end
        if info.name then
            for _, key in ipairs(ZONE_ORDER) do
                if ZONES[key].nameSet[info.name] then return ZONES[key] end
            end
        end
        mapID = info.parentMapID
        depth = depth + 1
    end
    return nil
end

-- The configured zone named by the zone text (GetZoneText / GetRealZoneText), or nil.
local function ZoneForText()
    local zone = GetZoneText and GetZoneText() or ""
    local real = GetRealZoneText and GetRealZoneText() or ""
    for _, key in ipairs(ZONE_ORDER) do
        local ns = ZONES[key].nameSet
        if ns[zone] or ns[real] then return ZONES[key] end
    end
    return nil
end

local function GetPlayerMapID()
    if not (C_Map and C_Map.GetBestMapForUnit) then return nil end
    local ok, id = pcall(C_Map.GetBestMapForUnit, "player")
    return ok and id or nil
end

-- 0.5.3: on a flight path? (UnitOnTaxi; false if the API is missing or errors)
local function OnTaxi()
    if not UnitOnTaxi then return false end
    local ok, on = pcall(UnitOnTaxi, "player")
    return (ok and on) and true or false
end

-- Which configured zone is the player in? (nil = none)
local function FindZone()
    -- Instances (Stockade, Deeprun Tram) may have a city as their parent map; exclude them.
    if IsInInstance and IsInInstance() then return nil end
    local ok, z = pcall(ZoneForMap, GetPlayerMapID())
    if not ok then z = nil end
    local t = ZoneForText()
    -- A zone inside another one wins when the zone text names it, even if the map resolved to the outer
    -- zone (map borders at the city gates don't always match the game's zone borders).
    if z and t and t ~= z and t.within == z.key then return t end
    return z or t -- map first, zone text as the fallback
end

---------------------------------------------------------------- inn detection
local function MapYards(mapID)
    if C_Map and C_Map.GetMapWorldSize then
        local ok, w, h = pcall(C_Map.GetMapWorldSize, mapID)
        if ok and type(w) == "number" and type(h) == "number" and w > 0 and h > 0 then return w, h end
    end
    local t = MAP_YARDS[mapID]
    if t then return t[1], t[2] end
    return nil
end

-- Player position on uiMap mapID as x, y in 0-1 (nil if the player isn't on that map).
local function PlayerPos(mapID)
    if not (mapID and C_Map and C_Map.GetPlayerMapPosition) then return nil end
    local ok, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
    if not (ok and pos) then return nil end
    local x, y = pos.x, pos.y
    if (x == nil or y == nil) and pos.GetXY then x, y = pos:GetXY() end
    if not (x and y) or (x == 0 and y == 0) then return nil end
    return x, y
end

-- Distance in yards from the player to a spot on mapID (nil if unknown).
local function SpotDistance(mapID, sx, sy)
    local x, y = PlayerPos(mapID)
    if not x then return nil end
    local w, h = MapYards(mapID)
    if not w then return nil end
    local dx, dy = (x - sx) * w, (y - sy) * h
    return math.sqrt(dx * dx + dy * dy)
end

local function SavedSpots()
    return type(DB.innSpots) == "table" and DB.innSpots or {}
end

-- The nearest spot (zone z's or saved ones) within its radius + extra yards, or nil. Returns spot, distance.
local function SpotNear(z, extra)
    local best = GetPlayerMapID()
    local found, foundD
    local function test(spot, maps)
        for _, m in ipairs(maps) do
            if m == best or (z and z.mapSet[m]) then
                local d = SpotDistance(m, spot.x, spot.y)
                if d and d <= (spot.r or SAVED_SPOT_RADIUS) + extra and (not foundD or d < foundD) then
                    found, foundD = spot, d
                end
            end
        end
    end
    if z then
        for _, spot in ipairs(z.innSpots or {}) do test(spot, spot.maps or {}) end
    end
    for _, spot in ipairs(SavedSpots()) do
        if type(spot) == "table" and spot.map then test(spot, { spot.map }) end
    end
    return found, foundD
end

-- Entry rule: the inn spot the player is in right now (indoors, within radius), or nil. Returns spot, distance.
local function SpotHere(z)
    if OnTaxi() then return nil end -- 0.5.3: an inn never starts from a flight path (flying over or near an inn)
    if not (IsIndoors and IsIndoors()) then return nil end
    return SpotNear(z, 0)
end

local function SetInnLatch(spot, z)
    S.innSpot, S.innZone, S.innEnter, S.innOut, S.innFar = spot, spot and z or nil, 0, 0, 0
end

-- Inn-spot hysteresis, called once per position poll. Returns true when the inn state changed.
local function UpdateInnLatch(z)
    if S.innSpot then
        local near = z == S.innZone and SpotNear(z, INN_EXIT_EXTRA) ~= nil -- another zone counts as far
        if near and IsIndoors and IsIndoors() then S.innOut, S.innFar = 0, 0; return false end
        S.innOut = S.innOut + 1                 -- outdoors (or far): counts toward leaving
        S.innFar = near and 0 or S.innFar + 1   -- beyond the exit radius: leaves sooner
        if S.innOut >= INN_EXIT_OUTDOORS or S.innFar >= INN_EXIT_FAR then
            Debug("inn state ended (" .. (near and "outdoors" or "beyond exit radius") .. ")")
            SetInnLatch(nil)
            return true
        end
        return false
    end
    local spot = z and SpotHere(z)
    S.innEnter = spot and S.innEnter + 1 or 0
    if spot and S.innEnter >= INN_ENTER_POLLS then
        Debug("inn state started (" .. (spot.name or "?") .. ")")
        SetInnLatch(spot, z)
        return true
    end
    return false
end

-- Is the player in an inn of zone z? (subzone name, or the inn-spot state for this zone)
local function InInn(z)
    if not z then return false end
    local sub = GetSubZoneText and GetSubZoneText() or ""
    if z.innSet[sub] then return true end
    return S.innSpot ~= nil and S.innZone == z
end

---------------------------------------------------------------- game music restore
-- After StopMusic() the client stays silent until its next zone-music trigger. Turning the Music setting
-- off and on again (next tick) makes it start the current area's music (zone, city or inn) right away.
-- Only when Music is on; if one of our own songs starts first, FinishMusicRestore() turns it back on at once.
local function FinishMusicRestore()
    if not S.restoreTimer then return end
    S.restoreTimer:Cancel(); S.restoreTimer = nil
    CVarSet("Sound_EnableMusic", "1")
end

local function RestoreGameMusic()
    if S.restoreTimer then return end -- already restoring
    if CVarGet("Sound_EnableMusic") ~= "1" or CVarGet("Sound_EnableAllSound") == "0" then return end
    CVarSet("Sound_EnableMusic", "0")
    S.restoreTimer = C_Timer.NewTimer(0.1, function()
        S.restoreTimer = nil
        CVarSet("Sound_EnableMusic", "1")
    end)
end

---------------------------------------------------------------- playback backends
local function MuteZoneMusic(on) -- "sound" mode only
    if S.muted == on then return end
    local fn = on and MuteSoundFile or UnmuteSoundFile
    if not fn then return end
    local ids = on and (S.zone and S.zone.zoneMusic) or S.mutedIDs
    for _, id in ipairs(ids or {}) do pcall(fn, id) end
    S.muted, S.mutedIDs = on, on and ids or nil
end

-- Returns willPlay, handle. "music": PlayMusic (no handle). "sound": PlaySoundFile on the Music channel.
local function PlayTrackFile(track)
    FinishMusicRestore() -- never play while Music is switched off for a restore
    if DB.mode == "sound" then
        MuteZoneMusic(not track.original)
        if not PlaySoundFile then return false end
        local ok, willPlay, handle = pcall(PlaySoundFile, track.file, "Music")
        if not ok then return false end
        if type(willPlay) == "number" and handle == nil then return true, willPlay end
        return willPlay and true or false, handle
    end
    if not PlayMusic then return false end
    local ok, willPlay = pcall(PlayMusic, track.file)
    return ok and willPlay ~= false, nil
end

---------------------------------------------------------------- playback core
-- 0.5.1: end the silence state (its timer is S.timer, which CancelTimers cancels)
local function ClearGap()
    if S.gap and S.gap.ticker then S.gap.ticker:Cancel() end
    S.gap = nil
end

local function CancelTimers()
    if S.timer then S.timer:Cancel(); S.timer = nil end
    if S.ticker then S.ticker:Cancel(); S.ticker = nil end
end

-- switching = another track follows immediately (music mode: don't StopMusic, the next PlayMusic replaces it)
local function StopCurrent(fadeMs, switching)
    CancelTimers()
    S.gen = S.gen + 1 -- invalidates any pending callbacks from the old track
    if S.handle then
        if fadeMs and fadeMs > 0 then pcall(StopSound, S.handle, fadeMs) else pcall(StopSound, S.handle) end
    end
    if not switching then
        if StopMusic then pcall(StopMusic) end
        MuteZoneMusic(false)
    end
    S.handle, S.track = nil, nil
    S.interrupted, S.resuming = false, false
    ClearGap()
end

---------------------------------------------------------------- volume fade-out
-- The player's Music volume (the saved one while a fade runs), as a number 0-1.
local function SavedVolume()
    if S.fade then return S.fade.orig end
    return tonumber(CVarGet(VOL_CVAR) or "") or 0
end

-- 0.5.13: every volume write of ours goes through here, so CVAR_UPDATE can tell our writes from the player's.
local function SetVolume(str)
    S.volWriting = true
    CVarSet(VOL_CVAR, str)
    S.volWriting = false
    local v = tonumber(str)
    if type(DB) == "table" and v and v > 0 and not S.fade then DB.lastVolume = tostring(str) end
end

-- 0.5.13: put the player's volume back (end of a fade, fade cancelled, safety) and clear the "left at 0" flags.
local function PutVolumeBack(str)
    SetVolume(str)
    if type(DB) == "table" then
        DB.fadeVolume, DB.volZeroed = nil, nil
        if tonumber(str) and tonumber(str) > 0 then DB.lastVolume = tostring(str) end
    end
end

-- Stop fading and put the saved volume back exactly. The song (if any) keeps playing.
local function CancelFade(why)
    local fd = S.fade
    if not fd then return end
    if fd.ticker then fd.ticker:Cancel() end
    S.fade = nil
    PutVolumeBack(fd.origStr)
    if why then Debug("fade cancelled (" .. why .. "), volume back to " .. fd.origStr) end
end

-- A new volume the player chose during a fade (slider, Blizzard settings): it becomes the saved volume.
local function AdoptFadeVolume(num, str)
    local fd = S.fade
    if not fd then return end
    fd.orig, fd.origStr = num, str or ("%.2f"):format(num)
    DB.fadeVolume = fd.origStr
    if num > 0 then DB.lastVolume = fd.origStr end
    Debug("volume changed during the fade: saved volume is now " .. fd.origStr)
end

-- 0.5.13: was value v written by this fade (within 0.011: a client that rounds to 2 decimals or reports a step late)?
local FADE_ECHO = 0.011
local function FadeWrote(v)
    local fd = S.fade
    if not fd then return false end
    if math.abs(v - fd.orig) <= FADE_ECHO then return true end
    for _, w in ipairs(fd.wrote) do if math.abs(v - w) <= FADE_ECHO then return true end end
    return false
end

-- 0.5.13: CVAR_UPDATE for the Music volume. Mid-fade, a value that isn't one of our own steps is the player's new
-- setting. Outside a fade, a volume above 0 is remembered (MusicPlusDB.lastVolume) for the volume safety.
local function OnVolumeUpdate(value)
    if S.volWriting then return end
    local v = tonumber(value or CVarGet(VOL_CVAR) or "")
    if not v then return end
    local fd = S.fade
    if fd then
        if fd.finishing or FadeWrote(v) then return end
        AdoptFadeVolume(v, tostring(value or CVarGet(VOL_CVAR)))
    elseif v > 0 then
        local cur = tonumber(CVarGet(VOL_CVAR) or "")
        if cur and math.abs(cur - v) > FADE_ECHO then return end -- a late event (e.g. a step of a finished fade)
        DB.lastVolume = tostring(value or CVarGet(VOL_CVAR))
        DB.volZeroed = nil -- the player set a volume: nothing of ours to put back
    end
end

local FADE_WATCHDOG = 3 -- s past a fade's length: it's stuck, put the volume back

local function FadeStep()
    local fd = S.fade
    if not fd or fd.finishing then return end
    -- 0.5.13: never read our own steps back (the client may report them rounded or late): a mid-fade change by the
    -- player comes in through the slider (AdoptFadeVolume) or CVAR_UPDATE (OnVolumeUpdate).
    local frac = (GetTime() - fd.start) / fd.dur
    if frac >= 1 then
        fd.last = 0
        DB.volZeroed = true -- cleared when the saved volume is put back (PutVolumeBack)
        SetVolume("0")
        fd.finishing = true
        if fd.ticker then fd.ticker:Cancel(); fd.ticker = nil end
        local ok, err = pcall(fd.onDone)
        if not ok then
            Debug("fade end failed (" .. tostring(err) .. "), volume back to " .. fd.origStr)
            if S.fade == fd then S.fade = nil end
            PutVolumeBack(fd.origStr)
        end
        return
    end
    local str = ("%.3f"):format(fd.orig * (1 - frac))
    fd.last = tonumber(str)
    fd.wrote[#fd.wrote + 1] = fd.last
    SetVolume(str)
end

-- Ramp the Music volume down to 0 over dur seconds, then call onDone (which must stop the music and call
-- FinishFade). No fade (onDone right away) if nothing is playing or the volume/Music is already off.
local function FadeOut(dur, onDone)
    if S.fade then return end -- already fading out
    local str = CVarGet(VOL_CVAR)
    local orig = tonumber(str or "")
    if not (S.track and orig and orig > 0 and CVarGet("Sound_EnableMusic") == "1"
            and CVarGet("Sound_EnableAllSound") ~= "0") then
        onDone(); return
    end
    S.fade = { orig = orig, origStr = str, last = orig, start = GetTime(), dur = dur, onDone = onDone, wrote = {} }
    DB.fadeVolume = str
    DB.lastVolume = str
    Debug(("fading out over %.1f s from volume %s"):format(dur, str))
    S.fade.ticker = C_Timer.NewTicker(FADE_STEP, FadeStep)
end

-- 0.5.13: volume safety (login, /reload, loading screens, zone changes, position polls, rotation starts). A fade
-- stuck past its length is ended; a Music volume of 0 that MusicPlus left behind (volZeroed, or an unfinished fade's
-- fadeVolume) is put back. A 0 the player chose is never touched (setting it clears volZeroed).
local function VolumeSafety(why)
    if type(DB) ~= "table" then return end
    local fd = S.fade
    if fd then
        if not fd.finishing and GetTime() - fd.start > fd.dur + FADE_WATCHDOG then
            if fd.ticker then fd.ticker:Cancel() end
            S.fade = nil
            PutVolumeBack(fd.origStr)
            Debug("fade stuck (" .. why .. "), volume back to " .. fd.origStr)
        end
        return
    end
    if not (DB.volZeroed or DB.fadeVolume) then return end
    local cur = tonumber(CVarGet(VOL_CVAR) or "")
    local saved = (type(DB.fadeVolume) == "string" and tonumber(DB.fadeVolume) and DB.fadeVolume)
        or (type(DB.lastVolume) == "string" and tonumber(DB.lastVolume) and DB.lastVolume) or nil
    if cur and cur < 0.005 and saved and tonumber(saved) > 0 then
        PutVolumeBack(saved)
        Print("Music volume restored to " .. math.floor(tonumber(saved) * 100 + 0.5) .. "% (MusicPlus had left it at 0).")
    else
        DB.fadeVolume, DB.volZeroed = nil, nil
    end
end

local function Shuffled(list)
    local t = {}
    for i = 1, #list do t[i] = list[i] end
    for i = #t, 2, -1 do local j = math.random(i); t[i], t[j] = t[j], t[i] end
    return t
end

-- All originals (shuffled), then all customs (shuffled). The song that played last (loop boundary or
-- re-entry) is never first: if the shuffle puts it there, it's swapped with another song of its group.
local function BuildRotation(z)
    local orig, cust = Shuffled(z.origTracks), Shuffled(CustomPool(z)) -- 0.5.7: the customs pool (setting)
    local first = (#orig > 0) and orig or cust
    if #first > 1 and first[1].file == S.lastFile then
        local j = math.random(2, #first)
        first[1], first[j] = first[j], first[1]
    end
    local r = {}
    for _, t in ipairs(orig) do r[#r + 1] = t end
    for _, t in ipairs(cust) do r[#r + 1] = t end
    S.rotation, S.pos, S.nOrig, S.nCustom = r, 0, #orig, #cust
end

-- "Original 3/8" / "Custom 2/6" for rotation position i
local function PosLabel(i)
    if S.testing then return "test" end
    if not (S.rotation and i and i > 0) then return "-" end
    if i <= S.nOrig then return ("Original %d/%d"):format(i, S.nOrig) end
    return ("Custom %d/%d"):format(i - S.nOrig, S.nCustom)
end

local PlayIndex -- forward declaration
local StartGap  -- forward declaration (0.5.1)

-- natural = the track's time is up (duration timer). Skip, Loop turned back on and the end of a gap pass nothing,
-- so they always start the next track at once.
local function Advance(gen, natural)
    if gen ~= S.gen then return end -- stale callback: prevents double-advance
    if S.testing then
        StopCurrent(0); S.testing, S.zone = false, nil; Print("Test finished."); RestoreGameMusic(); RefreshUI()
        return
    end
    if natural and not DB.loop and not S.gap then StartGap(); return end -- Loop music off: silence first
    StopCurrent(300, true)
    PlayIndex(S.pos + 1)
end

local function StartDurationTimer(track)
    if S.timer then S.timer:Cancel() end
    local gen = S.gen
    S.startTime = GetTime()
    S.timer = C_Timer.NewTimer(track.duration + 0.5, function() Advance(gen, true) end)
end

---------------------------------------------------------------- 0.5.1: silence between tracks (Loop music off)
-- Keep the Music channel ours without a sound: PlayMusic(SILENCE_FILE) replaces the finished (looping) track, so the
-- game's zone music stays faded out, exactly as while a song plays. No StopMusic, no RestoreGameMusic here.
-- "sound" mode (PlaySoundFile doesn't loop): nothing to replace, just keep the zone's music files muted.
local function PlaySilence()
    FinishMusicRestore() -- never leave Music switched off
    if DB.mode == "sound" then MuteZoneMusic(true) return end
    if PlayMusic then pcall(PlayMusic, SILENCE_FILE) end
end

-- "Original 3/8" / "Custom 1/6" of the track that follows the silence (a new round starts with its first song)
local function NextPosLabel()
    if not S.rotation then return "-" end
    if S.pos + 1 <= #S.rotation then return PosLabel(S.pos + 1) end
    local nO = S.zone and #S.zone.origTracks or 0
    if nO > 0 then return ("Original 1/%d"):format(nO) end
    return ("Custom 1/%d"):format(S.zone and #CustomPool(S.zone) or 0)
end

local function GapLeft()
    return math.max(0, math.ceil(S.gap.dur - (GetTime() - S.gap.start)))
end

local function GapText() -- "Silence before Custom 3/6 (1:12)"
    local left = GapLeft()
    return ("Silence before %s (%d:%02d)"):format(NextPosLabel(), math.floor(left / 60), left % 60)
end

function StartGap()
    StopCurrent(300, true) -- the song is over; switching = no StopMusic (zone music must not come back)
    local dur = math.random(GAP_MIN, GAP_MAX)
    S.gap = { start = GetTime(), dur = dur }
    PlaySilence()
    local gen = S.gen
    S.timer = C_Timer.NewTimer(dur, function() Advance(gen) end) -- then the next track
    S.gap.ticker = C_Timer.NewTicker(1, function() RefreshNowLabel() end) -- window countdown (label only)
    Debug(("silence for %d:%02d before %s (Loop music off)"):format(math.floor(dur / 60), dur % 60, NextPosLabel()))
    RefreshUI()
end

-- Loading screen / "probably back" hint during a gap: the game may have dropped our silent PlayMusic, so play it again
-- (the gap keeps counting down).
local function RenewSilence(why)
    if not S.gap then return end
    Debug("silence re-asserted (" .. why .. ")")
    PlaySilence()
end

---------------------------------------------------------------- "sound" mode: alt-tab interruption / resume
local function IsHandlePlaying()
    if not (S.handle and C_Sound and C_Sound.IsPlaying) then return nil end
    local ok, playing = pcall(C_Sound.IsPlaying, S.handle)
    if not ok then return nil end
    return playing and true or false
end

local function FlagInterrupted()
    if S.timer then S.timer:Cancel(); S.timer = nil end -- pause: never advance while interrupted
    if not S.interrupted and not S.resuming then Debug("interrupted: " .. S.track.name) end
    S.interrupted = true
end

local function TryResume()
    local track = S.track
    if not track then return end
    if not S.everHeard and S.attempts >= MAX_UNSEEN then -- never audible at all: broken/missing file
        Debug("giving up on " .. track.name)
        if S.testing then Advance(S.gen) return end
        StopCurrent(0, true); PlayIndex(S.pos + 1)
        return
    end
    S.lastAttempt, S.attempts = GetTime(), S.attempts + 1
    if S.handle then pcall(StopSound, S.handle) end
    local willPlay, handle = PlayTrackFile(track)
    if not willPlay then return end -- stay interrupted; retried after RETRY seconds
    S.handle, S.sawPlaying, S.interrupted, S.resuming = handle, false, false, true
    StartDurationTimer(track)
end

local function Poll()
    if not S.track then return end
    local now = GetTime()
    if S.interrupted then
        if now - S.lastAttempt >= RETRY then TryResume() end
        return
    end
    local playing = IsHandlePlaying()
    if playing == nil then return end
    if playing then
        S.isPlayingWorks, S.everHeard = true, true
        if not S.sawPlaying then
            S.sawPlaying = true
            if S.resuming then Debug("resumed: " .. S.track.name .. " (restarted from the beginning)") end
            S.resuming, S.attempts = false, 0
        end
        return
    end
    if not S.isPlayingWorks and not S.sawPlaying then return end -- IsPlaying not trusted yet
    local elapsed = now - S.startTime
    if not S.sawPlaying and elapsed < CONFIRM then return end
    if S.track.duration - elapsed > MIN_LEFT then FlagInterrupted() end
end

local function StartTracking(track)
    S.sawPlaying, S.interrupted, S.resuming, S.attempts, S.everHeard = false, false, false, 0, false
    StartDurationTimer(track)
    if S.ticker then S.ticker:Cancel(); S.ticker = nil end
    if S.handle then S.ticker = C_Timer.NewTicker(POLL, Poll) end -- only "sound" mode has a handle
end

-- Play the current track again from the beginning (loading screen, /mplus replay, "probably back" hint).
local function RestartCurrent(why)
    local track = S.track
    if not track then
        if S.gap and why ~= "/mplus replay" then RenewSilence(why) end -- 0.5.1: during a gap, stay silent
        return
    end
    if why ~= "/mplus replay" and GetTime() - S.startTime < 3 then return end -- just (re)started: don't double up
    Debug("replaying " .. track.name .. " (" .. why .. ")")
    if S.handle then pcall(StopSound, S.handle) end
    local willPlay, handle = PlayTrackFile(track)
    if not willPlay then return end
    S.handle = handle
    StartTracking(track)
end

local function ResumeHint(why)
    if not S.track then
        if S.gap and DB.mode ~= "sound" and CVarGet(BG_CVAR) == "0" then RenewSilence(why) end -- 0.5.1
        return
    end
    if S.handle then
        if S.interrupted then Debug("resume hint: " .. why); S.lastAttempt = 0; Poll() end
    elseif CVarGet(BG_CVAR) == "0" then
        RestartCurrent(why) -- music mode with background sound off: the song was probably cut
    end
end

function PlayIndex(i, failures)
    failures = failures or 0
    if not S.zone then return end
    if not S.rotation or i > #S.rotation then BuildRotation(S.zone); i = 1 end
    if failures >= #S.rotation then
        Print("Nothing could be played; disabled. Try /mplus test, then /mplus on.")
        CancelFade("nothing playable"); S.active, DB.enabled = false, false; StopCurrent(0); RestoreGameMusic(); RefreshUI()
        return
    end
    local track = S.rotation[i]
    S.pos = i
    ClearGap()
    local willPlay, handle = PlayTrackFile(track)
    if not willPlay then
        Print("Debug: could not play " .. track.name .. " (" .. tostring(track.file) .. "), skipping.")
        return PlayIndex(i + 1, failures + 1)
    end
    S.track, S.handle, S.lastFile = track, handle, track.file
    if DB.titles then Print(("Now playing: %s (%s)"):format(track.name, PosLabel(i))) end -- 0.5.1: "Show song titles"
    StartTracking(track)
    RefreshUI()
end

local function WarnIfMusicOff()
    if S.warnedMusicOff or S.restoreTimer then return end
    if CVarGet("Sound_EnableMusic") == "0" or CVarGet("Sound_EnableAllSound") == "0" then
        S.warnedMusicOff = true
        Print("|cffffff00Warning:|r game Music (or all sound) is turned off, so you won't hear MusicPlus. Turn on Music in Settings > Audio.")
    end
end

local function StartRotation(z)
    VolumeSafety("rotation start") -- 0.5.13
    S.active, S.zone = true, z
    WarnIfMusicOff()
    Debug("starting rotation for " .. z.title)
    BuildRotation(z)
    PlayIndex(1)
end

-- restore = bring the game's own music back right away (inn, leaving the zones, /mplus off)
local function StopRotation(fadeMs, restore)
    if S.fade and not S.fade.finishing then CancelFade("stopped") end
    local wasPlaying = S.active or S.track ~= nil
    S.active = false
    StopCurrent(fadeMs)
    if restore and wasPlaying then RestoreGameMusic() end
    S.rotation, S.pos, S.zone, S.pendingSwitch = nil, 0, nil, nil
    RefreshUI()
end

-- Fade the rotation out (volume ramp), then stop it: StopMusic at volume 0, Music off, saved volume back,
-- Music on 0.1 s later (RestoreGameMusic) so the game's own music (inn, zone) starts at the right volume.
local function FadeStopRotation(dur)
    FadeOut(dur, function()
        local fd = S.fade
        local ok, err = pcall(StopRotation, 0, false) -- StopMusic() while the volume is 0
        if fd then
            RestoreGameMusic()                        -- Music off now (on again in 0.1 s), if it was on
            S.fade = nil
            PutVolumeBack(fd.origStr)                 -- the exact saved volume (0.5.13: even if the stop failed)
            Debug("fade done, volume back to " .. fd.origStr)
        else
            RestoreGameMusic()
        end
        if not ok then Debug("stop after the fade failed: " .. tostring(err)) end
        pcall(RefreshUI)
    end)
end

---------------------------------------------------------------- 0.5.3: flight lock (UnitOnTaxi)
-- While the player is on a flight path no zone is read: the song and the rotation of the takeoff zone go on, and no
-- inn starts (SpotHere returns nil on a taxi). The takeoff zone is saved in MusicPlusDB.taxiZone (key, or false =
-- MusicPlus was off) so a /reload or relog mid-flight continues it.
local function EngageTaxi()
    local resumed = not S.sawGround and not S.active -- on a taxi since this session began: /reload or login mid-flight
    S.taxi = true
    S.pendingSwitch, S.pendingStop = nil, false -- readings from before takeoff don't count any more
    S.seenState, S.seenCount = nil, 0
    local why
    if resumed then
        local saved = DB.taxiZone
        if saved == false then
            S.taxiZone, why = nil, "reload/login mid-flight, MusicPlus was off at takeoff"
        elseif type(saved) == "string" and ZONES[saved] then
            S.taxiZone, why = ZONES[saved], "reload/login mid-flight, saved takeoff zone"
        else
            local ok, z = pcall(FindZone)
            S.taxiZone, why = (DB.enabled and ok and z) or nil, "reload/login mid-flight, no saved takeoff zone: the zone below"
        end
    else
        S.taxiZone = (S.active and not S.fade) and S.zone or nil
        why = S.taxiZone and "took off" or "took off while MusicPlus wasn't playing"
    end
    DB.taxiZone = S.taxiZone and S.taxiZone.key or false
    Debug("flight lock engaged (" .. why .. "): " .. (S.taxiZone and ("zone locked to " .. S.taxiZone.title)
        or "MusicPlus stays off for this flight") .. "; zone changes are ignored until you land")
end

local function ReleaseTaxi(why)
    S.taxi, S.taxiZone, DB.taxiZone = false, nil, nil
    S.promptUntil = GetTime() + PROMPT_WINDOW -- the landing check uses the prompt ~1 s confirmation
    S.seenState, S.seenCount = nil, 0
    Debug("flight lock released (" .. why .. "): checking the zone")
end

-- Engage / release the lock from the current UnitOnTaxi(). Returns "locked" while it holds, "landed" right when it
-- was released (the caller makes sure the zone is checked), nil on the ground.
local function UpdateTaxi(why)
    if OnTaxi() then
        if not S.taxi then EngageTaxi() end
        return "locked"
    end
    if not S.inWorld then return S.taxi and "locked" or nil end -- loading screen: decided after PLAYER_ENTERING_WORLD
    S.sawGround = true
    if S.taxi then ReleaseTaxi(why or "landed"); return "landed" end
    if DB.taxiZone ~= nil then DB.taxiZone = nil end -- on the ground: no flight to resume
    return nil
end

---------------------------------------------------------------- zone evaluation (debounced)
-- No-op while in the current zone and already playing (never restarts the rotation). A stop needs two
-- "not in a configured zone / in inn" readings ~1 s apart, and so does a switch to another configured
-- zone (e.g. Stormwind -> Elwynn at the gates), so a single glitchy zone read can't restart anything.
-- 0.5.3: on a flight path nothing is read (flight lock). Walking over a border (a switch, or a stop because the
-- player left the zones) needs the new place read for ZONE_SWITCH_DELAY s in a row instead; inns, /mplus off and the
-- PROMPT_WINDOW after a loading screen or a landing keep the ~1 s rule.

-- nil = prompt confirmation (second reading CONFIRM_PROMPT s later), else the walking delay in seconds
local function SwitchDelay()
    if GetTime() <= S.promptUntil then return nil end
    return ZONE_SWITCH_DELAY
end

local function LongPending()
    return (S.pendingSwitch ~= nil and S.pendingLong) or (S.pendingStop and S.stopLong)
end

-- During a walking delay every reading must agree with the pending switch (zone) or stop (nil).
local function PendingBroken(want)
    if S.pendingSwitch and S.pendingLong then return want ~= S.pendingSwitch end
    if S.pendingStop and S.stopLong then return want ~= nil end
    return false
end

-- The wanted zone right now without touching the inn state (nil = none or in an inn)
local function ReadZone()
    local z = FindZone()
    if z and InInn(z) then return nil end
    if ZoneDisabled(z) then return nil end -- 0.5.9
    return z
end

local function Evaluate()
    S.evalTimer = nil
    local restart = S.needRestart
    S.needRestart = false
    local force = S.forceStop -- 0.5.9: the zone being played was just disabled: stop now (no delay, no second reading)
    S.forceStop = false
    if S.testing then return end
    if UpdateTaxi() == "locked" and DB.enabled then -- 0.5.3 flight lock: no zone reading at all
        if S.taxiZone and ZoneDisabled(S.taxiZone) then -- 0.5.9: the zone this flight plays for was disabled
            Debug("flight lock: " .. S.taxiZone.title .. " is disabled, MusicPlus stays off for this flight")
            S.taxiZone, DB.taxiZone = nil, false
            if S.active and not S.fade then FadeStopRotation(FADE_LEAVE) end
            return
        end
        if not S.active then
            if S.taxiZone and not S.fade then StartRotation(S.taxiZone) end -- /reload mid-flight, /mplus on in flight
        elseif restart then
            RestartCurrent("loading screen")
        end
        return
    end
    local z = DB.enabled and FindZone() or nil
    if z and not S.active and not S.innSpot then
        -- nothing playing yet (login, /reload, arriving): don't start a song just to stop it at the next poll
        local spot = SpotHere(z)
        if spot then SetInnLatch(spot, z) end
    end
    local inn = false
    if z and InInn(z) then z, inn = nil, true end
    local off = false
    if ZoneDisabled(z) then z, off = nil, true end -- 0.5.9: disabled for this zone = outside the zones
    local stopNow = off and force -- 0.5.9: ticked here: fade out at once, like /mplus off
    local delay = SwitchDelay()
    if z then
        if S.pendingStop and S.stopLong then Debug("pending stop cancelled (" .. (z == S.zone and "back" or "now") .. " in " .. z.title .. ")") end
        S.pendingStop = false
        if S.fade then CancelFade("back in " .. z.title) end -- left the inn / came back mid-fade: keep playing
        if not S.active then S.pendingSwitch = nil; StartRotation(z)
        elseif z ~= S.zone then -- moved straight into another configured zone: its own rotation
            if S.pendingSwitch == z and (not S.pendingLong or not delay or GetTime() - S.pendingAt >= delay - 0.001) then
                S.pendingSwitch = nil
                Debug("zone switch confirmed: " .. z.title)
                StopCurrent(0, true); MuteZoneMusic(false); StartRotation(z)
            elseif S.pendingSwitch == z then -- 0.5.3: walking, the delay isn't over yet
                S.needRestart = restart
                ScheduleEvaluate(delay - (GetTime() - S.pendingAt))
            else
                if S.pendingSwitch then Debug("pending zone switch to " .. S.pendingSwitch.title .. " cancelled (now in " .. z.title .. ")") end
                S.pendingSwitch, S.pendingAt, S.pendingLong = z, GetTime(), delay ~= nil
                Debug(("pending zone switch started: %s -> %s (%s)"):format(S.zone.title, z.title,
                    delay and (delay .. " s in the new zone") or "prompt: loading screen / landing"))
                S.needRestart = restart -- keep a pending loading-screen replay if we end up staying
                ScheduleEvaluate(delay or CONFIRM_PROMPT)
            end
        else
            if S.pendingSwitch then Debug("pending zone switch to " .. S.pendingSwitch.title .. " cancelled (still in " .. z.title .. "), the song goes on") end
            S.pendingSwitch = nil
            if restart then RestartCurrent("loading screen") end
        end
    elseif S.active then
        if S.pendingSwitch then Debug("pending zone switch to " .. S.pendingSwitch.title .. " cancelled (" .. (inn and "inn" or (off and "zone disabled" or "outside the zones")) .. ")") end
        S.pendingSwitch = nil
        if S.fade then return end -- already fading out
        if inn or not DB.enabled or stopNow then delay = nil end -- inns (and /mplus off, 0.5.9 zone ticked off) keep their 0.5.2 timing
        if not DB.enabled or stopNow or (S.pendingStop and (not S.stopLong or not delay or GetTime() - S.stopAt >= delay - 0.001)) then
            S.pendingStop = false
            FadeStopRotation((DB.enabled and S.zone and InInn(S.zone)) and FADE_INN or FADE_LEAVE)
        elseif S.pendingStop then -- 0.5.3: walking out of the zones, the delay isn't over yet
            ScheduleEvaluate(delay - (GetTime() - S.stopAt))
        else
            S.pendingStop, S.stopAt, S.stopLong = true, GetTime(), delay ~= nil
            if delay then Debug(("pending stop started: left %s (%d s outside the zones)"):format(S.zone and S.zone.title or "?", delay)) end
            ScheduleEvaluate(delay or CONFIRM_PROMPT)
        end
    end
end

function ScheduleEvaluate(delay)
    if S.evalTimer then S.evalTimer:Cancel() end
    S.evalTimer = C_Timer.NewTimer(delay or DEBOUNCE, Evaluate)
end

-- Position poll (every POLL_INN s): walking into or out of a building fires no zone event. It only acts
-- when the wanted state (a zone, or nothing because of an inn / no zone) differs from what's playing AND
-- the same wanted state was seen on two polls in a row (or the inn state just changed: that already has its
-- own hysteresis); Evaluate then double-checks stops and switches.
local function WantedZone()
    local z = FindZone()
    local changed = UpdateInnLatch(z)
    if z and InInn(z) then return nil, changed end
    if ZoneDisabled(z) then return nil, changed end -- 0.5.9: a disabled zone = outside the zones
    return z, changed
end

local function PollPosition()
    VolumeSafety("poll") -- 0.5.13: cheap unless a fade is stuck or MusicPlus left the volume at 0
    local taxi = UpdateTaxi() -- 0.5.3: flight lock (engaged on takeoff, released on landing)
    if taxi == "landed" then ScheduleEvaluate(0) end
    if not DB.enabled or S.testing then S.seenState, S.seenCount = nil, 0; SetInnLatch(nil); return end
    if taxi == "locked" then -- in flight: only the inn exit rules run (no entry on a taxi), never a zone decision
        S.seenState, S.seenCount = nil, 0
        pcall(function() UpdateInnLatch(FindZone()) end)
        return
    end
    local ok, want, changed = pcall(WantedZone)
    if not ok then return end
    if S.evalTimer then
        if PendingBroken(want) then ScheduleEvaluate(0) end -- 0.5.3: walking delay needs the same reading all along
        S.seenState, S.seenCount = nil, 0; return
    end
    local have = (S.active and not S.fade) and S.zone or nil -- fading out = already on its way to "nothing"
    if want == have then S.seenState, S.seenCount = nil, 0; return end
    local key = want and want.key or "none"
    if S.seenState == key then S.seenCount = S.seenCount + 1 else S.seenState, S.seenCount = key, 1 end
    if changed or S.seenCount >= 2 then
        S.seenState, S.seenCount = nil, 0
        Debug("position: " .. (want and ("in " .. want.title) or "inn / outside the zones"))
        ScheduleEvaluate(0)
    end
end

local function StartPositionPoll()
    if not S.posTicker then S.posTicker = C_Timer.NewTicker(POLL_INN, PollPosition) end
end

---------------------------------------------------------------- test mode
local function StartTest()
    CancelFade("test")
    if S.active then StopRotation(0) end
    StopCurrent(0)
    S.testing = true
    WarnIfMusicOff()
    local z = ZONES[ZONE_ORDER[1]]
    local track = z.customTracks[1] or z.origTracks[1]
    S.zone = z
    local willPlay, handle = PlayTrackFile(track)
    if not willPlay then
        S.testing = false; StopCurrent(0)
        Print("|cffff4040TEST FAILED|r: could not play " .. track.file)
        return
    end
    S.track, S.handle = track, handle
    Print(("Test: playing %s (mode %s). /mplus stop to end."):format(track.name, DB.mode))
    StartTracking(track)
    RefreshUI()
end

local function StopTest()
    if not S.testing then Print("No test running (use /mplus off to stop the rotation).") return end
    StopCurrent(500)
    S.testing, S.zone = false, nil; Print("Test stopped.")
    RestoreGameMusic()
    ScheduleEvaluate(0.1)
    RefreshUI()
end

---------------------------------------------------------------- settings (background sound, volume, enable)
local function SetBgSound(on)
    DB.bgSound = on and true or false
    CVarSet(BG_CVAR, on and "1" or "0")
end

local function GetVolumePercent() -- the saved volume (never a mid-fade value)
    return math.floor(SavedVolume() * 100 + 0.5)
end

local function SetEnabled(on)
    DB.enabled = on and true or false
    if on then
        if S.taxi and S.fade and not S.fade.finishing then CancelFade("on again in flight") end -- 0.5.3: no zone check in flight
        ScheduleEvaluate(0.1)
    else
        if S.testing then StopTest() end
        if S.active then FadeStopRotation(FADE_LEAVE) else StopRotation(FADE_MS, true) end
    end
    RefreshUI()
end

-- 0.5.9: Disable MusicPlus for zone z (on = disabled) or enable it again.
local function SetZoneDisabled(z, on)
    if not z then return end
    if type(DB.disabledZones) ~= "table" then DB.disabledZones = {} end
    DB.disabledZones[z.title] = on and true or nil
    Debug(z.title .. (on and ": MusicPlus disabled for this zone" or ": MusicPlus enabled again for this zone"))
    if on then
        S.forceStop = true
        ScheduleEvaluate(0)
    else
        S.forceStop = false
        if S.fade and not S.fade.finishing and S.zone == z then -- unticked again mid-fade: keep playing
            CancelFade("zone enabled again")
            if S.taxi then S.taxiZone, DB.taxiZone = z, z.key end
        end
        ScheduleEvaluate(0.1)
    end
    RefreshUI()
end

-- 0.5.1: Loop music (MusicPlus's own setting; the game's Sound_ZoneMusicNoDelay is never changed)
local function SetLoop(on)
    DB.loop = on and true or false
    if DB.loop and S.gap and S.active then Advance(S.gen) end -- turned back on during a silence: next song now
    RefreshUI()
end

local function SetTitles(on)
    DB.titles = on and true or false
    RefreshUI()
end

-- 0.5.7: the Leveling Zone Music setting changed while a leveling zone's rotation runs. The song (or silence) that's
-- on goes on untouched (no restart, its timer and S.gen stay); only what hasn't played yet is redone: the originals
-- keep their places, the customs part becomes a fresh shuffle of the new pool minus the customs already played this
-- round (and the current one). The next round (BuildRotation) uses the new pool from the start.
local function RebuildPool()
    local r, z = S.rotation, S.zone
    local keep = math.max(S.pos, S.nOrig)
    local newR, done = {}, {}
    for i = 1, math.min(keep, #r) do newR[i] = r[i]; done[r[i].file] = true end
    local rest = {}
    for _, t in ipairs(CustomPool(z)) do if not done[t.file] then rest[#rest + 1] = t end end
    for _, t in ipairs(Shuffled(rest)) do newR[#newR + 1] = t end
    S.rotation, S.nCustom = newR, #newR - S.nOrig
    Debug(("customs pool for %s: %d songs (%s); %d left this round"):format(z.title, #CustomPool(z),
        DB.pool == "all" and "all leveling zones" or "this zone only", #newR - S.pos))
end

local function SetPool(value)
    value = (value == "all") and "all" or "zone"
    local changed = DB.pool ~= value
    DB.pool = value
    if changed and S.active and not S.testing and S.zone and not S.zone.city and S.rotation then RebuildPool() end
    RefreshUI()
end

---------------------------------------------------------------- options UI
-- Templates (all verified in the Forever 1.60.1 UI source): BasicFrameTemplateWithInset (TitleText,
-- CloseButton), UICheckButtonTemplate (.Text), UISliderTemplateWithLabels (.Text/.Low/.High),
-- UIPanelButtonTemplate, UIDropDownMenuTemplate + UIDropDownMenu_Initialize / _CreateInfo / _AddButton /
-- _SetWidth / _SetText and CloseDropDownMenus (Blizzard_SharedXML UIDropDownMenu.lua, loaded for every client
-- family). The window is in UISpecialFrames so Escape closes it.
-- 0.5.7: the 0.5.2 welcome window and the options window are one window, MusicPlusOptionsFrame.
local controlSets, optionsFrame = {}, nil
local WIN_W, WIN_H = 440, 680 -- 0.5.9: the merged window, taller for the zone checkbox and the 2nd pool description

-- Background sound checkbox (window and Settings panel): set the CVar, then show it everywhere (0.5.2: RefreshUI added)
local function OnBgClick(self)
    SetBgSound(self:GetChecked())
    RefreshUI()
end

local function Tooltip(widget, title, text)
    widget:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(title, 1, 1, 1)
        GameTooltip:AddLine(text, nil, nil, nil, true)
        GameTooltip:Show()
    end)
    widget:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-- 0.5.7: a short grey description under a checkbox (the 0.5.2 welcome style); only in the window, not the panel
local function AddDesc(parent, anchor, dx, dy, text)
    local d = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    d:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", dx, dy)
    d:SetWidth(WIN_W - 70)
    d:SetJustifyH("LEFT")
    d:SetTextColor(0.75, 0.75, 0.75)
    d:SetText(text)
    return d
end

-- 0.5.7: the Leveling Zone Music dropdown (Classic-era UIDropDownMenu API). If that API were missing, a plain button
-- that switches between the two choices takes its place, so the window always builds.
local function PoolMenu(_, level)
    for _, v in ipairs(POOL_VALUES) do
        local info = UIDropDownMenu_CreateInfo()
        info.text, info.value = POOL_LABELS[v], v
        info.checked = (DB.pool == v)
        info.func = function() SetPool(v); if CloseDropDownMenus then CloseDropDownMenus() end end
        UIDropDownMenu_AddButton(info, level)
    end
end

local function BuildPoolDropDown(parent, name)
    if UIDropDownMenu_Initialize and UIDropDownMenu_CreateInfo and UIDropDownMenu_AddButton and UIDropDownMenu_SetText then
        local dd = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate")
        if UIDropDownMenu_SetWidth then UIDropDownMenu_SetWidth(dd, 200) end
        UIDropDownMenu_Initialize(dd, PoolMenu)
        dd.SetChoice = function(self, v) UIDropDownMenu_SetText(self, POOL_LABELS[v]) end
        return dd, -16 -- the template's left border art is ~16 px of padding
    end
    local b = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
    b:SetSize(200, 22)
    b:SetScript("OnClick", function() SetPool(DB.pool == "all" and "zone" or "all") end)
    b.SetChoice = function(self, v) self:SetText(POOL_LABELS[v]) end
    return b, 0
end

-- opts (0.5.7, the window only): anchor = region to start under, descs = { bg, loop, titles } descriptions,
-- pool = add the Leveling Zone Music dropdown, bigLabels = checkbox labels in GameFontNormal (welcome style),
-- zone = add the 0.5.9 "Disable MusicPlus for this zone" checkbox under Enable.
-- Without opts (the Settings panel) the layout is exactly 0.5.6's.
local function BuildControls(parent, prefix, x, y, opts)
    opts = opts or {}
    local descs = opts.descs or {}
    local c = {}
    -- the next control goes under `last` (a checkbox, or a description lastCol px right of the checkbox column)
    local last, lastIsDesc, lastCol = nil, false, 0
    local function place(w)
        w:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0 - lastCol, lastIsDesc and -6 or -2)
    end
    local function after(cb, desc)
        if opts.bigLabels then cb.Text:SetFontObject("GameFontNormal") end
        if desc then cb.desc = AddDesc(parent, cb, 26, 3, desc); last, lastIsDesc, lastCol = cb.desc, true, 26
        else last, lastIsDesc, lastCol = cb, false, 0 end
    end

    c.enable = CreateFrame("CheckButton", prefix .. "Enable", parent, "UICheckButtonTemplate")
    if opts.anchor then c.enable:SetPoint("TOPLEFT", opts.anchor, "BOTTOMLEFT", x, y) else c.enable:SetPoint("TOPLEFT", x, y) end
    c.enable.Text:SetText("Enable MusicPlus (" .. #ZONE_ORDER .. " zones)")
    c.enable:SetScript("OnClick", function(self) SetEnabled(self:GetChecked()) end)
    after(c.enable, nil)

    if opts.zone then -- 0.5.9: Disable MusicPlus for this zone (label = the zone you're in, see RefreshZoneBoxes)
        c.zone = CreateFrame("CheckButton", prefix .. "Zone", parent, "UICheckButtonTemplate")
        place(c.zone)
        c.zone.Text:SetWidth(WIN_W - 70) -- a long zone name wraps to a 2nd line instead of running out of the window
        c.zone.Text:SetJustifyH("LEFT")
        c.zone:SetScript("OnClick", function(self)
            local z = self.zoneObj
            if z then SetZoneDisabled(z, self:GetChecked()) else self:SetChecked(false) end
        end)
        Tooltip(c.zone, "Disable MusicPlus for this zone", "Ticked: MusicPlus stays quiet in this zone (it fades out " ..
            "if playing) and the game's own music plays here, as if MusicPlus were off, but only in this zone. Other " ..
            "zones aren't affected. Saved per zone. Only for zones MusicPlus plays in. Also /mplus zone off / on.")
        after(c.zone, nil)
    end

    c.bg = CreateFrame("CheckButton", prefix .. "BgSound", parent, "UICheckButtonTemplate")
    place(c.bg)
    c.bg.Text:SetText("Play music when game is in background")
    c.bg:SetScript("OnClick", OnBgClick)
    Tooltip(c.bg, "Sound in Background", "Sets the game's \"Sound in Background\" option (" .. BG_CVAR ..
        "). On by default so alt-tabbing doesn't cut the music. It applies to all game sound.")
    after(c.bg, descs.bg)

    c.loop = CreateFrame("CheckButton", prefix .. "Loop", parent, "UICheckButtonTemplate")
    place(c.loop)
    c.loop.Text:SetText("Loop music (no silence between songs)")
    c.loop:SetScript("OnClick", function(self) SetLoop(self:GetChecked()) end)
    Tooltip(c.loop, "Loop music", "On (default): the next song starts as soon as one ends. Off: like the game's own " ..
        "music with its Loop Music option off, " .. GAP_MIN / 60 .. "-" .. GAP_MAX / 60 .. " minutes of silence between songs " ..
        "(the game's zone music stays quiet too). The game's own Loop Music option isn't changed.")
    after(c.loop, descs.loop)

    c.titles = CreateFrame("CheckButton", prefix .. "Titles", parent, "UICheckButtonTemplate")
    place(c.titles)
    c.titles.Text:SetText("Show song titles in chat")
    c.titles:SetScript("OnClick", function(self) SetTitles(self:GetChecked()) end)
    Tooltip(c.titles, "Show song titles", "Prints \"Now playing: <song> (Original 3/8)\" in chat at every song change. " ..
        "Off by default. The line below and /mplus status always show the current song.")
    after(c.titles, descs.titles)

    if opts.pool then -- 0.5.7: Leveling Zone Music
        c.poolLabel = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        c.poolLabel:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 4 - lastCol, -12)
        c.poolLabel:SetText("Leveling Zone Music")
        local dx
        c.pool, dx = BuildPoolDropDown(parent, prefix .. "Pool")
        c.pool:SetPoint("TOPLEFT", c.poolLabel, "BOTTOMLEFT", dx, -4)
        -- 0.5.9: both descriptions, the selected one brighter (RefreshUI)
        c.poolDescZone = AddDesc(parent, c.poolLabel, 0, -40, "For this zone only: plays this zone's original music, then " ..
            "its own custom songs.")
        c.poolDesc = AddDesc(parent, c.poolDescZone, 0, -4, "All zones: a leveling zone plays its own original tracks, then " ..
            "custom songs from all " .. (#ZONE_ORDER - 6) .. " leveling zones. Cities always keep their own music.")
        last, lastIsDesc, lastCol = c.poolDesc, true, 4
    end

    c.vol = CreateFrame("Slider", prefix .. "Volume", parent, "UISliderTemplateWithLabels")
    c.vol:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 8 - lastCol, lastIsDesc and -28 or -26)
    c.vol:SetWidth(220)
    c.vol:SetMinMaxValues(0, 100)
    c.vol:SetValueStep(1)
    c.vol:SetObeyStepOnDrag(true)
    c.vol.Low:SetText("0%")
    c.vol.High:SetText("100%")
    c.vol:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        self.Text:SetText(("Music volume: %d%%"):format(value))
        if self.refreshing then return end
        if S.fade then AdoptFadeVolume(value / 100) -- during a fade: new saved volume, the fade goes on
        else SetVolume(("%.2f"):format(value / 100)) end
    end)
    Tooltip(c.vol, "Music volume", "Sets the game's Music volume (" .. VOL_CVAR .. "). MusicPlus plays on " ..
        "the Music channel, so this is also the volume of the game's own music. Ambient sounds aren't affected.")

    c.skip = CreateFrame("Button", prefix .. "Skip", parent, "UIPanelButtonTemplate")
    c.skip:SetSize(80, 22)
    c.skip:SetPoint("TOPLEFT", c.vol, "BOTTOMLEFT", -8, -22)
    c.skip:SetText("Skip")
    c.skip:SetScript("OnClick", function() if S.active then Advance(S.gen) end end)

    c.now = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    c.now:SetPoint("LEFT", c.skip, "RIGHT", 8, 0)
    c.now:SetPoint("RIGHT", parent, "RIGHT", -12, 0)
    c.now:SetJustifyH("LEFT")
    controlSets[#controlSets + 1] = c
    return c
end

-- 0.5.9: the "Disable MusicPlus for this zone" checkboxes follow the zone you're in
local function CurrentZone()
    local ok, z = pcall(FindZone)
    return ok and z or nil
end

local function RefreshZoneBoxes()
    local z
    for _, c in ipairs(controlSets) do
        if c.zone then
            z = z or CurrentZone() or false
            c.zone.zoneObj = z or false -- false, not nil: a nil field would fall through to frame lookups
            if z then
                c.zone.Text:SetText("Disable MusicPlus for this zone: " .. z.title)
                c.zone.Text:SetTextColor(1, 0.82, 0)
                c.zone:SetEnabled(true)
                c.zone:SetChecked(ZoneDisabled(z))
            else
                local name = GetZoneText and GetZoneText() or ""
                if name == "" then name = "unknown" end
                c.zone.Text:SetText("Disable MusicPlus for this zone: " .. name .. " (not a MusicPlus zone)")
                c.zone.Text:SetTextColor(0.5, 0.5, 0.5)
                c.zone:SetChecked(false)
                c.zone:SetEnabled(false)
            end
        end
    end
end

function RefreshNowLabel()
    local here -- 0.5.9: "disabled for this zone" instead of "Not playing (...)" there
    for _, c in ipairs(controlSets) do
        if S.track then
            c.now:SetText(("Now: %s (%s)"):format(S.track.name, PosLabel(S.pos)))
        elseif S.gap then
            c.now:SetText(GapText())
        else
            if here == nil then here = (not S.active and ZoneDisabled(CurrentZone())) or false end
            c.now:SetText(S.active and "Now: -" or (here and "Not playing (disabled for this zone)"
                or "Not playing (only in configured zones, not in inns)"))
        end
    end
end

function RefreshUI()
    for _, c in ipairs(controlSets) do
        c.enable:SetChecked(DB.enabled)
        c.bg:SetChecked(CVarGet(BG_CVAR) ~= "0")
        c.loop:SetChecked(DB.loop)
        c.titles:SetChecked(DB.titles)
        if c.pool then c.pool:SetChoice(DB.pool) end -- 0.5.7
        if c.poolDescZone then -- 0.5.9: the selected choice's description brighter
            local a, b = (DB.pool == "all") and 0.55 or 0.95, (DB.pool == "all") and 0.95 or 0.55
            c.poolDescZone:SetTextColor(a, a, a)
            c.poolDesc:SetTextColor(b, b, b)
        end
        c.vol.refreshing = true
        c.vol:SetValue(GetVolumePercent())
        c.vol.refreshing = false
        c.skip:SetEnabled(S.active)
    end
    RefreshZoneBoxes() -- 0.5.9
    RefreshNowLabel()
end

-- 0.5.2: the common window frame: movable, clamped, X and Escape close it
local function MakeWindow(name, width, height, title)
    local f = CreateFrame("Frame", name, UIParent, "BasicFrameTemplateWithInset")
    f:SetSize(width, height)
    f:SetFrameStrata("DIALOG")
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f.TitleText:SetText(title)
    f:Hide()
    tinsert(UISpecialFrames, name)
    return f
end

-- 0.5.7: THE window (options menu + the 0.5.2 welcome). Layout, top to bottom (WIN_W x WIN_H):
--   "Welcome to MusicPlus" heading, intro line | Enable | Disable MusicPlus for this zone (0.5.9) |
--   Background sound + description | Loop music + description | Show song titles + description |
--   "Leveling Zone Music" label, dropdown, both descriptions (0.5.9) | Music volume slider |
--   Skip + song playing now | "/mplus at any time" note | Close (bottom center; "Got it" before 0.5.9). X / Escape / Close close it.
local function CreateOptionsWindow()
    local f = MakeWindow("MusicPlusOptionsFrame", WIN_W, WIN_H, "MusicPlus 0.5.16")
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, relPoint, px, py = self:GetPoint()
        DB.pos = { point, relPoint, px, py }
    end)
    local p = DB.pos
    if type(p) == "table" and p[1] then f:SetPoint(p[1], UIParent, p[2], p[3], p[4]) else f:SetPoint("CENTER") end
    f.heading = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    f.heading:SetPoint("TOPLEFT", 16, -32)
    f.heading:SetText("Welcome to MusicPlus")
    f.intro = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    f.intro:SetPoint("TOPLEFT", f.heading, "BOTTOMLEFT", 0, -6)
    f.intro:SetWidth(WIN_W - 32)
    f.intro:SetJustifyH("LEFT")
    f.intro:SetText("MusicPlus plays each zone's original Classic music plus custom songs in a shuffled rotation, " ..
        "and leaves inn music untouched wherever the game has it.")
    local c = BuildControls(f, "MusicPlusOpt", -4, -6, {
        anchor = f.intro, pool = true, bigLabels = true, zone = true,
        descs = {
            bg = "On (default): the music keeps playing when the game window isn't focused. " ..
                "It sets the game's \"Sound in Background\" option.",
            loop = "On (default): songs play back to back. Off: a random " .. GAP_MIN / 60 .. "-" .. GAP_MAX / 60 ..
                " minute silence between songs, like the game's own zone music.",
            titles = "Off (default). When on, a \"Now playing\" line appears in chat each time a new song starts.",
        },
    })
    f.controls = c
    local note = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    note:SetPoint("TOPLEFT", c.skip, "BOTTOMLEFT", 4, -14)
    note:SetWidth(WIN_W - 32)
    note:SetJustifyH("LEFT")
    note:SetText("Type /mplus at any time to open this window again.")
    f.note = note
    local ok = CreateFrame("Button", "MusicPlusOptOK", f, "UIPanelButtonTemplate")
    ok:SetSize(100, 22)
    ok:SetPoint("BOTTOM", 0, 14)
    ok:SetText("Close") -- 0.5.9: was "Got it"
    ok:SetScript("OnClick", function() f:Hide() end)
    f:SetScript("OnShow", function()
        DB.welcomeShown = true -- 0.5.2: set the moment it's shown: /reload or logout with the window open won't repeat it
        RefreshUI()
    end)
    f:SetScript("OnHide", function() if CloseDropDownMenus then CloseDropDownMenus() end end)
    return f
end

-- /mplus welcome, the first-login popup: open (never toggles it off)
local function ShowOptions()
    optionsFrame = optionsFrame or CreateOptionsWindow()
    optionsFrame:Show()
end

-- /mplus: open / close
local function ToggleOptions()
    optionsFrame = optionsFrame or CreateOptionsWindow()
    if optionsFrame:IsShown() then optionsFrame:Hide() else optionsFrame:Show() end
end

---------------------------------------------------------------- 0.5.2: shown once at the first login (0.5.7: the window above)
local welcomeChecked, welcomePending = false, false -- this session: login check done / waiting for combat to end

local function MaybeShowWelcome() -- after the login delay, and on PLAYER_REGEN_ENABLED while pending
    if DB.welcomeShown then welcomePending = false return end
    if InCombatLockdown and InCombatLockdown() then welcomePending = true return end
    welcomePending = false
    ShowOptions()
end

-- Settings > AddOns > MusicPlus (canvas category). Optional; failures are ignored.
local function RegisterSettingsPanel()
    if not (Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory) then return end
    local panel = CreateFrame("Frame")
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("MusicPlus")
    BuildControls(panel, "MusicPlusPanel", 16, -44)
    panel.OnRefresh = RefreshUI
    panel:SetScript("OnShow", RefreshUI)
    local category = Settings.RegisterCanvasLayoutCategory(panel, "MusicPlus")
    Settings.RegisterAddOnCategory(category)
end

---------------------------------------------------------------- status
local function Status()
    local mapID = GetPlayerMapID()
    local info = mapID and C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
    local yn = function(b) return b and "|cff40ff40yes|r" or "|cffff4040no|r" end
    Print(("Enabled: %s  Active: %s  Testing: %s  Mode: %s"):format(yn(DB.enabled), yn(S.active), yn(S.testing), DB.mode))
    local z = FindZone()
    Print(("Configured zone: %s  Playing for: %s  mapID: %s (%s)%s"):format(z and z.title or "none",
        S.zone and S.zone.title or "-", tostring(mapID), info and info.name or "?", S.taxi and "  (on flight path, zone locked)" or ""))
    if S.pendingSwitch and S.pendingLong then -- 0.5.3
        Print(("Zone switch pending: %s in %d s (going back cancels it)"):format(S.pendingSwitch.title,
            math.max(0, math.ceil(ZONE_SWITCH_DELAY - (GetTime() - S.pendingAt)))))
    elseif S.pendingStop and S.stopLong then
        Print(("Left the zones: the music stops in %d s (going back cancels it)"):format(
            math.max(0, math.ceil(ZONE_SWITCH_DELAY - (GetTime() - S.stopAt)))))
    end
    Print(("Zone: %s, Real: %s, Subzone: \"%s\""):format(GetZoneText() or "", GetRealZoneText() or "", GetSubZoneText() or ""))
    if z then
        Print(("%s: %d original + %d custom songs in the rotation%s"):format(z.title, #z.origTracks, #CustomPool(z),
            (z.city and DB.pool == "all") and " (a city: always its own songs)" or (CustomPool(z) ~= z.customTracks and " (customs from all leveling zones)" or "")))
        Print("This zone: " .. z.title .. " - MusicPlus " .. (ZoneDisabled(z) and "|cffff4040OFF here|r (disabled for this zone; /mplus zone on)"
            or "on here")) -- 0.5.9
    end
    do -- 0.5.9
        local list = {}
        for _, key in ipairs(ZONE_ORDER) do if ZoneDisabled(ZONES[key]) then list[#list + 1] = ZONES[key].title end end
        if #list > 0 then Print(("Disabled zones (%d): %s"):format(#list, table.concat(list, ", "))) end
    end
    local spot, dist = SpotHere(z)
    if S.innSpot then spot, dist = S.innSpot, select(2, SpotNear(z, 1e9)) or 0 end
    Print(("Inn: %s%s  IsIndoors: %s  IsResting: %s"):format(yn(InInn(z)),
        spot and (" (spot \"%s\", %.0f yd)"):format(spot.name or "?", dist) or "", yn(IsIndoors and IsIndoors()), yn(IsResting and IsResting())))
    if S.track then
        local left = math.floor(math.max(0, S.track.duration - (GetTime() - S.startTime)))
        local pos = PosLabel(S.pos)
        local playing = S.handle and tostring(IsHandlePlaying()) or "n/a (PlayMusic)"
        Print(("Track: %s (%s), %d:%02d left, IsPlaying=%s"):format(S.track.name, pos, math.floor(left / 60), left % 60, playing))
    elseif S.gap then
        Print("Track: none - " .. GapText() .. " (Loop music is off)")
    else
        Print("Track: none")
    end
    local bg = CVarGet(BG_CVAR)
    if S.fade then Print(("Fading out: volume %s -> 0, saved volume %s"):format(tostring(CVarGet(VOL_CVAR)), S.fade.origStr)) end
    Print(("CVars: EnableAllSound=%s EnableMusic=%s MusicVolume=%s %s=%s"):format(tostring(CVarGet("Sound_EnableAllSound")),
        tostring(CVarGet("Sound_EnableMusic")), tostring(CVarGet(VOL_CVAR)), BG_CVAR, tostring(bg)))
    Print(("Saved background choice: %s (MusicPlusDB %s)"):format(DB.bgSound and "on" or "off",
        type(MusicPlusDB) == "table" and "loaded" or "not loaded"))
    Print(("Loop music: %s  Song titles in chat: %s"):format(DB.loop and "on" or ("off (" .. GAP_MIN .. "-" .. GAP_MAX .. " s silence between songs)"),
        DB.titles and "on" or "off"))
    Print("Leveling Zone Music: " .. POOL_LABELS[DB.pool] .. (DB.pool == "all" and
        (" (" .. #ALL_LEVELING_CUSTOMS .. " custom songs in leveling zones; cities unchanged)") or "")) -- 0.5.7
    if S.interrupted then Print("Song is interrupted (alt-tab?); retrying every " .. RETRY .. " s.") end
    if CVarGet("Sound_EnableMusic") == "0" then
        Print("|cffffff00Warning:|r game Music is off; MusicPlus plays on the Music channel, so turn Music on.")
    end
end

---------------------------------------------------------------- slash commands
-- /mplus where: map, position, subzone, indoors (for finding inn spots)
local function Where()
    local mapID = GetPlayerMapID()
    local info = mapID and C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
    local x, y = PlayerPos(mapID)
    Print(("mapID %s (%s)  x,y = %s"):format(tostring(mapID), info and info.name or "?",
        x and ("%.1f, %.1f  (%.4f, %.4f)"):format(x * 100, y * 100, x, y) or "unknown"))
    Print(("Zone: %s  Subzone: \"%s\"  IsIndoors: %s  IsResting: %s"):format(GetZoneText() or "", GetSubZoneText() or "",
        tostring(IsIndoors and IsIndoors() or false), tostring(IsResting and IsResting() or false)))
    local z = FindZone()
    local spot, dist = SpotHere(z)
    local hold = ""
    if S.innSpot then
        spot, dist = S.innSpot, select(2, SpotNear(z, 1e9)) or 0
        if S.innOut > 0 then hold = (" - leaving? %d/%d polls outdoors/away"):format(S.innOut, INN_EXIT_OUTDOORS) end
    end
    Print(("Configured zone: %s  Inn: %s%s%s"):format(z and z.title or "none", InInn(z) and "yes" or "no",
        spot and (" (spot \"%s\", %.0f yd from the nearest spot center)"):format(spot.name or "?", dist) or "", hold))
end

local function SpotLine(spot)
    return ('{ name = "%s", maps = { %d }, x = %.4f, y = %.4f, r = %d },'):format(spot.name or "?", spot.map or 0,
        spot.x or 0, spot.y or 0, spot.r or SAVED_SPOT_RADIUS)
end

-- /mplus inn [clear|list]: save the current position as an inn spot (indoors only), list or clear them
local function InnCommand(arg)
    if arg == "clear" then
        DB.innSpots = {}
        Print("Saved inn spots cleared.")
        ScheduleEvaluate(0.1)
        return
    elseif arg == "list" then
        local spots = SavedSpots()
        if #spots == 0 then Print("No saved inn spots.") return end
        for i, spot in ipairs(spots) do Print(("%d: %s"):format(i, SpotLine(spot))) end
        return
    end
    local mapID = GetPlayerMapID()
    local x, y = PlayerPos(mapID)
    if not x then Print("Can't read your map position here.") return end
    if not (IsIndoors and IsIndoors()) then
        Print("You're not indoors. Inn spots only count indoors, so stand inside the inn and try again.")
        return
    end
    local sub = GetSubZoneText and GetSubZoneText() or ""
    local spot = { name = (sub ~= "" and sub or "Inn") .. " (saved)", map = mapID, x = x, y = y, r = SAVED_SPOT_RADIUS }
    if type(DB.innSpots) ~= "table" then DB.innSpots = {} end
    DB.innSpots[#DB.innSpots + 1] = spot
    Print(("Inn spot saved (%d yd radius, indoors only). To hard-code it:"):format(SAVED_SPOT_RADIUS))
    Print(SpotLine(spot))
    ScheduleEvaluate(0.1)
end

local function Help()
    Print("/mplus - options window (open/close)   /mplus status (or now) - show state   /mplus skip - next track")
    Print("/mplus on / off - enable/disable   /mplus replay - restart the current song")
    Print("/mplus test - play first custom MP3 anywhere   /mplus stop - stop test")
    Print("/mplus inn - save this spot as an inn (stand inside)   /mplus inn list / clear   /mplus where - position")
    Print("/mplus bgsound - toggle \"Sound in Background\"   /mplus mode - switch music/sound playback   /mplus debug")
    Print("/mplus loop [on/off] - Loop music (off = 3-5 min silence between songs)   /mplus titles [on/off] - song titles in chat")
    Print("/mplus pool [zone/all] - Leveling Zone Music: this zone's custom songs only, or all leveling zones' (cities unchanged)")
    Print("/mplus zone [on/off] - MusicPlus on/off for the zone you're in (no argument = show)   /mplus zone clear - all zones on")
    Print("/mplus welcome - open the options window (the welcome screen) again")
end

-- "on" / "off" / "" (toggle) for /mplus loop and /mplus titles; nil = not understood
local function OnOffArg(arg, current)
    if arg == "" or arg == "toggle" then return not current end
    if arg == "on" or arg == "1" then return true end
    if arg == "off" or arg == "0" then return false end
    return nil
end

SLASH_MUSICPLUS1, SLASH_MUSICPLUS2 = "/mplus", "/musicplus"
SlashCmdList["MUSICPLUS"] = function(msg)
    local cmd, rest = (msg or ""):lower():match("^%s*(%S*)%s*(.-)%s*$")
    if cmd == "" or cmd == "options" or cmd == "config" then
        ToggleOptions()
    elseif cmd == "skip" then
        if S.active then Advance(S.gen) else Print("Not playing.") end
    elseif cmd == "off" then
        SetEnabled(false); Print("Disabled; game music restored.")
    elseif cmd == "on" then
        SetEnabled(true); Print("Enabled.")
    elseif cmd == "status" or cmd == "now" then
        Status()
    elseif cmd == "test" then
        StartTest()
    elseif cmd == "stop" then
        StopTest()
    elseif cmd == "replay" then
        if S.track then RestartCurrent("/mplus replay") else Print("Not playing.") end
    elseif cmd == "debug" then
        S.debug = not S.debug; Print("Debug " .. (S.debug and "on." or "off."))
    elseif cmd == "bgsound" then
        SetBgSound(CVarGet(BG_CVAR) == "0")
        Print("Sound in Background is now " .. (CVarGet(BG_CVAR) ~= "0" and "ON." or "OFF."))
        RefreshUI()
    elseif cmd == "mode" then
        local wasActive = S.active
        if S.testing then StopTest() end
        StopRotation(0)
        DB.mode = (DB.mode == "music") and "sound" or "music"
        Print("Playback mode: " .. DB.mode .. (DB.mode == "music" and " (PlayMusic)" or " (PlaySoundFile on Music channel, zone music muted)"))
        if wasActive then ScheduleEvaluate(0.1) end
    elseif cmd == "loop" then
        local on = OnOffArg(rest, DB.loop)
        if on == nil then Print("Usage: /mplus loop [on/off]") return end
        SetLoop(on)
        Print("Loop music is now " .. (DB.loop and "ON (the next song starts right away)." or
            ("OFF (" .. GAP_MIN / 60 .. "-" .. GAP_MAX / 60 .. " minutes of silence between songs, like the game's own music).")))
    elseif cmd == "titles" then
        local on = OnOffArg(rest, DB.titles)
        if on == nil then Print("Usage: /mplus titles [on/off]") return end
        SetTitles(on)
        Print("Song titles in chat are now " .. (DB.titles and "ON." or "OFF (the window and /mplus status still show the song)."))
    elseif cmd == "inn" then
        InnCommand(rest)
    elseif cmd == "where" then
        Where()
    elseif cmd == "welcome" then
        ShowOptions() -- 0.5.7: the welcome window is the options window
    elseif cmd == "pool" then -- 0.5.7: Leveling Zone Music
        local v = (rest == "all") and "all" or ((rest == "zone" or rest == "this") and "zone" or nil)
        if rest == "" then
            Print("Leveling Zone Music: " .. POOL_LABELS[DB.pool] .. ". Usage: /mplus pool zone | all")
            return
        end
        if not v then Print("Usage: /mplus pool zone | all") return end
        SetPool(v)
        Print("Leveling Zone Music is now: " .. POOL_LABELS[DB.pool] .. (DB.pool == "all" and
            (" (leveling zones: their own original tracks, then custom songs from all " .. (#ZONE_ORDER - 6) ..
            " leveling zones; cities unchanged).") or " (each zone plays only its own songs)."))
    elseif cmd == "zone" then -- 0.5.9: Disable MusicPlus for this zone
        local z = CurrentZone()
        if rest == "clear" then
            if type(DB.disabledZones) ~= "table" then DB.disabledZones = {} end
            local n = 0
            for _ in pairs(DB.disabledZones) do n = n + 1 end
            DB.disabledZones = {}
            Print(("MusicPlus is on again in every zone (%d re-enabled)."):format(n))
            ScheduleEvaluate(0.1); RefreshUI()
            return
        end
        if not z then Print("You're not in a MusicPlus zone, so there's nothing to turn off here.") return end
        if rest == "" then
            Print(z.title .. ": MusicPlus is " .. (ZoneDisabled(z) and "OFF here (/mplus zone on)." or "on here (/mplus zone off to turn it off here)."))
            local list = {}
            for _, key in ipairs(ZONE_ORDER) do if ZoneDisabled(ZONES[key]) then list[#list + 1] = ZONES[key].title end end
            Print(#list > 0 and ("Disabled zones: " .. table.concat(list, ", ")) or "No disabled zones.")
            return
        end
        local on = OnOffArg(rest, not ZoneDisabled(z))
        if on == nil then Print("Usage: /mplus zone [on/off/clear]") return end
        SetZoneDisabled(z, not on)
        Print(z.title .. ": MusicPlus is now " .. (on and "on here." or "OFF here; the game's own music plays in this zone."))
    else
        Help()
    end
end

---------------------------------------------------------------- events
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("ZONE_CHANGED")
f:RegisterEvent("ZONE_CHANGED_INDOORS")
f:RegisterEvent("PLAYER_LOGOUT")
f:RegisterEvent("PLAYER_LEAVING_WORLD")
f:RegisterEvent("SOUND_DEVICE_UPDATE")
f:RegisterEvent("CVAR_UPDATE")
f:RegisterEvent("PLAYER_REGEN_ENABLED") -- 0.5.2: the first-login window waits for the end of combat
f:RegisterEvent("PLAYER_CONTROL_LOST")   -- 0.5.3: flight lock (taxi takeoff; the poll checks UnitOnTaxi too)
f:RegisterEvent("PLAYER_CONTROL_GAINED") -- 0.5.3: landing
f:SetScript("OnEvent", function(_, event, arg1, arg2)
    if event == "ADDON_LOADED" and arg1 == ADDON then
        if type(MusicPlusDB) ~= "table" then MusicPlusDB = {} end
        DB = MusicPlusDB
        if DB.enabled == nil then DB.enabled = true end
        if DB.mode ~= "sound" then DB.mode = "music" end
        if DB.bgSound == nil then DB.bgSound = true end   -- default ON
        if DB.bgSound then CVarSet(BG_CVAR, "1") end       -- respect a saved "off"
        if type(DB.innSpots) ~= "table" then DB.innSpots = {} end
        if type(DB.loop) ~= "boolean" then DB.loop = true end       -- 0.5.1: Loop music, default ON
        if type(DB.titles) ~= "boolean" then DB.titles = false end  -- 0.5.1: song titles in chat, default OFF
        if DB.pool ~= "all" then DB.pool = "zone" end              -- 0.5.7: Leveling Zone Music, default this zone only
        if type(DB.disabledZones) ~= "table" then DB.disabledZones = {} end -- 0.5.9: zone title -> true
        if type(DB.fadeVolume) == "string" and tonumber(DB.fadeVolume) and tonumber(DB.fadeVolume) > 0 then
            PutVolumeBack(DB.fadeVolume) -- the client stopped mid-fade last time: put the volume back
            Print("Music volume restored to " .. math.floor(tonumber(DB.fadeVolume or CVarGet(VOL_CVAR)) * 100 + 0.5) .. "% (a fade-out was interrupted).")
        end
        DB.fadeVolume = nil
        VolumeSafety("login") -- 0.5.13: a 0 that a fade left behind (volZeroed)
        if not DB.volCheck0513 then -- 0.5.13, once: 0.5.12 could leave the Music volume at 0 after an inn
            DB.volCheck0513 = true
            local cur = tonumber(CVarGet(VOL_CVAR) or "")
            if cur and cur < 0.01 then
                local back = (type(DB.lastVolume) == "string" and tonumber(DB.lastVolume) and tonumber(DB.lastVolume) > 0) and DB.lastVolume or "0.4"
                PutVolumeBack(back)
                Print("Music volume was 0% (an older MusicPlus could leave it there after an inn); set back to " ..
                    math.floor(tonumber(back) * 100 + 0.5) .. "%. Change it any time in /mplus.")
            end
        end
        do local v = tonumber(CVarGet(VOL_CVAR) or "") if v and v > 0 then DB.lastVolume = CVarGet(VOL_CVAR) end end
        pcall(RegisterSettingsPanel)
        StartPositionPoll()
    elseif event == "CVAR_UPDATE" then
        -- remember changes made in Blizzard's Settings too (arg1 = CVar name, arg2 = value)
        if type(arg1) == "string" and arg1:lower() == BG_CVAR:lower() then DB.bgSound = (arg2 ~= "0") end
        if type(arg1) == "string" and arg1:lower() == VOL_CVAR:lower() then OnVolumeUpdate(arg2) end -- 0.5.13
        if optionsFrame and optionsFrame:IsShown() then RefreshUI() end
    elseif event == "SOUND_DEVICE_UPDATE" then
        ResumeHint("SOUND_DEVICE_UPDATE")
    elseif event == "PLAYER_LOGOUT" then
        CancelFade("logout") -- the saved volume must be what the client writes to its config
        StopCurrent(0) -- also fires on /reload; the rotation restarts after the reload
        FinishMusicRestore() -- never leave Music switched off
    elseif event == "PLAYER_LEAVING_WORLD" then
        S.inWorld = false -- 0.5.3: taxi state isn't trusted until PLAYER_ENTERING_WORLD
        CancelFade("loading screen") -- keep playing; the zone check after loading decides again
    elseif event == "PLAYER_ENTERING_WORLD" then
        S.inWorld = true
        VolumeSafety("loading screen") -- 0.5.13
        S.promptUntil = GetTime() + PROMPT_WINDOW -- 0.5.3: a teleport is a real move: prompt ~1 s confirmation
        S.needRestart = true -- music stops on loading screens: replay the current track if still in the zone
        ScheduleEvaluate(1.0)
        RefreshZoneBoxes() -- 0.5.9
        if not welcomeChecked then -- 0.5.2: first loading screen of the session only (login or /reload)
            welcomeChecked = true
            if not DB.welcomeShown then C_Timer.After(WELCOME_DELAY, MaybeShowWelcome) end
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        if welcomePending then MaybeShowWelcome() end
    elseif event == "PLAYER_CONTROL_LOST" or event == "PLAYER_CONTROL_GAINED" then -- 0.5.3
        if UpdateTaxi(event) == "landed" then ScheduleEvaluate(0) end
    else
        VolumeSafety("zone change") -- 0.5.13
        -- 0.5.3: during a walking delay, a zone event that reads any other place breaks it at once
        local ok, want = true, nil
        if LongPending() then ok, want = pcall(ReadZone) end
        if ok and PendingBroken(want) then ScheduleEvaluate(0) else ScheduleEvaluate(DEBOUNCE) end
        RefreshZoneBoxes() -- 0.5.9: the zone checkbox label follows the zone (ZONE_CHANGED*)
    end
end)

-- A large gap between frames (client stalled/minimized) is a hint that we just came back.
local lastFrame = 0
f:SetScript("OnUpdate", function()
    local now = GetTime()
    if lastFrame > 0 and now - lastFrame > 1.5 then ResumeHint(("frame gap %.1f s"):format(now - lastFrame)) end
    lastFrame = now
end)

Print("v0.5.16 loaded (" .. #ZONE_ORDER .. " zones). /mplus for options, /mplus help for commands.")
