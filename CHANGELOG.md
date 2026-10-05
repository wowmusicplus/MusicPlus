# Changelog

All notable changes to MusicPlus. Versions are for WoW Forever 1.60.1 (Interface 16001).

## 0.5.14

Changes since 0.5.12:

- Fixed the Music volume getting stuck at 0 after entering some inns (for example the Scarlet Raven Tavern in Darkshire), which also kept the tavern music from playing. Your Music volume is now always put back after the fade-out, and MusicPlus checks it again at login, `/reload`, loading screens and zone changes. If an older version left your Music volume at 0, the first load of this version sets it back to your last volume (or the game default of 40%) once and says so in chat.
- Updated music in Stonetalon Mountains: "Protect Kaya Flathoof" is now a calmer take (same title and file name).

## 0.5.12

Changes since 0.5.10:

- Renamed all 150 custom songs with titles drawn from the lore of vanilla WoW and earlier Warcraft games (same songs, same zones). The song files in each zone folder carry the new names.
- Song titles now show proper punctuation in game, e.g. "Vol'jin's Counsel" and "Hakkar Sleeps in Zul'Gurub", in the "Now playing" chat line, `/mplus status`, `/mplus test` and the options window. File names stay without apostrophes.

## 0.5.10

Changes since 0.5.7:

- Added music for Zephras Isle, the Skyborne starting zone (25 zones in total).
- New option to disable MusicPlus for the current zone only (`/mplus zone on` / `off`, `/mplus zone clear` turns every zone back on).
- Updated music in Ashenvale.
- Small options window tweaks: both Leveling Zone Music choices now have a description, and the "Got it" button is now "Close".

## 0.5.7

- Combined the welcome and options windows into one window, opened with `/mplus`.
- Added a Leveling Zone Music option: play music from just the current zone, or from all leveling zones. Also available as `/mplus pool zone` or `/mplus pool all`.

## 0.5.6

Changes since 0.5.2:

- Updated music in various zones to improve their themes.
- Flight path fix: music no longer switches zones while you're on a flight path; it checks your zone shortly after landing. Walking across a zone border now waits a few seconds before switching, so brief border crossings don't interrupt the music.

## 0.5.2

- New **"Welcome to MusicPlus"** window, shown once, about 2 seconds after the first loading screen (after combat if you're fighting). It has one line on what MusicPlus does, plus the **Loop music**, **Show song titles** and **background sound** options with short descriptions. These are the same settings as in `/mplus` and Options → AddOns, kept in sync. It ends with the note "Type /mplus at any time to open the options window again." and a **Got it** button (X and Escape close it too).
- It's remembered in `MusicPlusDB.welcomeShown` as soon as it opens, so `/reload`, relogging and later loading screens don't show it again. Existing users see it once too.
- New `/mplus welcome` to reopen it.
- Nothing else changed: music, timing and chat output are exactly as in 0.5.1.

## 0.5.1

Two new options in the window (and Options → AddOns → MusicPlus), saved in `MusicPlusDB`:

- **Loop music** (default ON, unchanged behavior: the next song starts as soon as one ends). OFF works like the game's own zone music with its Loop Music option off: after each song, 3–5 minutes of silence (random), then the next song. 3–5 minutes is the game's own silence between zone-music tracks (the same for every zone MusicPlus covers). During the silence MusicPlus keeps the Music channel with a silent placeholder, so the game's zone music stays quiet too. Skip, or ticking Loop music again, starts the next song at once. Inns, leaving the zones, `/mplus off` and zone changes work the same as during a song. After a loading screen the silence just continues. The game's own Loop Music option is never touched.
- **Show song titles in chat** (default OFF): the "Now playing: ..." chat line on song changes only appears when this is ticked. The window, `/mplus status` and `/mplus now` always show the song (or the silence).
- New `/mplus loop [on/off]` and `/mplus titles [on/off]`. `/mplus status` shows both options.

## 0.5.0

- **21 new zones (24 in total)**, each with its own original Classic tracks (day and night) and 6 custom songs in a folder named after the zone (126 new songs):
  - Capitals: Ironforge, Darnassus, Orgrimmar, Thunder Bluff, Undercity
  - 1–10: Dun Morogh, Teldrassil, Durotar, Mulgore, Tirisfal Glades
  - 10–25: Loch Modan, Darkshore, Silverpine Forest, The Barrens
  - 15–30: Redridge Mountains, Stonetalon Mountains, Duskwood, Ashenvale
  - 20–45: Wetlands, Hillsbrad Foothills, Stranglethorn Vale
- Every capital beats the zone around it (Ironforge is never Dun Morogh, Undercity is never Tirisfal).
- Inns: MusicPlus only stops where the game has real inn/tavern music in the Forever data, found by position + indoors (with the 0.4.4 hysteresis), plus the subzone name where there is one. Everywhere else, including inns without their own music (Razor Hill, Crossroads, Tarren Mill ...), the rotation keeps playing. The outdoor troll villages Sen'jin Village, Malaka'jin and Zoram'gar Outpost play tavern drums outdoors, but they're villages, not inns: outdoors there the rotation keeps playing (only Sen'jin's big hut and the Malaka'jin den stop it).

## 0.4.5

- Songs **fade out** instead of cutting off: 2 s when entering an inn, 1.5 s when leaving the zones or on `/mplus off` (Music volume ramped to 0 in small steps, then the song stops and your volume is put back while the game's music restarts).
- Your volume is always restored: fade done or cancelled, walking back out mid-fade, `/mplus off`/`on`/`mode`/`test`, loading screens, logout, `/reload`, even a crash.
- A volume change during a fade becomes the kept volume; the `/mplus` slider never shows the fading value.

## 0.4.4

- No more jumping between inn music and the rotation while moving around inside an inn. Once in an inn, MusicPlus stays in inn mode until you're clearly out: 5 checks in a row (2.5 s) outdoors, or 2 checks well away from the building (10 yards past its area). Short "outdoors" readings on stairs and in doorways are ignored. Entering still needs two checks in a row inside and indoors.
- Applies to every position-based inn spot (Lion's Pride Inn, Slaughtered Lamb, spots saved with `/mplus inn`).
- Lion's Pride Inn area slightly larger.

## 0.4.3

- Lion's Pride Inn works in Forever: the subzone inside is just "Goldshire", so it's now found by position + indoors (two circles covering the whole building). The subzone name stays as a fallback. The blacksmith next door is not caught.

## 0.4.2

- The rotation keeps playing in the Gilded Rose, Pig and Whistle Tavern and Blue Recluse: they have no inn music in Forever. MusicPlus now only stops where the game plays real inn/tavern music: the Slaughtered Lamb bar floor (Stormwind) and the Lion's Pride Inn (Goldshire).

## 0.4.1

- Stormwind inns are found by position (map coordinates) plus "indoors", since in Forever they have no subzone of their own. Position is checked every 0.5 s and must be seen twice before anything changes, so doorways don't flicker.
- `/mplus inn` saves your current position as an inn spot (kept in `MusicPlusDB`, coordinates printed); `/mplus inn list` / `clear`; new `/mplus where`.
- The game's own music now comes back right away when MusicPlus stops (inn, leaving the zones, `/mplus off`, end of `/mplus test`). Music off in your settings stays off; Ambience is untouched.

## 0.4.0

- Two new zones: **Elwynn Forest** (3 original forest tracks + 6 custom songs) and **Westfall** (4 original plains tracks + 6 custom songs).
- Northshire counts as Elwynn; the Lion's Pride Inn (Goldshire) keeps its inn music. Stormwind is always detected as Stormwind, never as Elwynn.
- Walking between zones switches to the new zone's rotation (checked twice, about 1 s apart).
- Sound mode fix: Stormwind's zone-music mute list now also has the re-encoded files Forever actually plays, so the city's own music is muted during custom songs.

## 0.3.0

- New rotation: all 8 original Stormwind tracks (shuffled), then all 6 custom songs (shuffled), then a fresh shuffle of both. Reshuffled every time you enter Stormwind; the last song heard never starts the next round.
- Position shown as "Original 3/8" / "Custom 2/6" in chat, the window and `/mplus status`.
- Zone setup moved into one data table so more zones can be added later.

## 0.2.0

- Plays on the Music channel instead of Ambience. Game music is no longer switched off, and ambient sounds are untouched.
- New options window (`/mplus`) and Settings → AddOns panel with Enable, "Play music when game is in background" (default ON, remembered) and a Music volume slider.
- New `/mplus replay`, `/mplus mode`, `/mplus help`. Restarts the song after loading screens. Settings are saved (`MusicPlusDB`).

## 0.1.2

- Alt-tab: a song cut off by the game is detected and the same song restarts when you're back, instead of silence until the next song.
- New `/mplus bgsound` and `/mplus debug`. `/mplus status` shows the "Sound in Background" setting.

## 0.1.1

- Alt-tabbing no longer skips to the next song. Songs now advance only when their length is up.
- Exact lengths for the original tracks.
- Leaving Stormwind or entering an inn is double-checked (about 1 s) before the music stops, so a single glitchy zone reading can't restart the rotation.
