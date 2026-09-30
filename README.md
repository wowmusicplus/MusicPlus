# MusicPlus

**Additional zone music for WoW Forever (Classic 1.60.1).** MusicPlus adds 144 new songs: 6 per zone across 24 zones, covering all 6 classic capitals plus 18 Alliance and Horde zones from level 1 to 45. Each new song is written around the mood of its zone. Each zone plays its original Classic tracks first, then its 6 new songs, shuffled and blended seamlessly. Inns with their own tavern music keep it, unchanged, and you can choose between continuous music or the original experience, with gaps of silence between songs.

- Client: WoW Forever (classic-style beta), version 1.60.1, TOC Interface `16001`
- Current version: **0.5.2**

> **Get the addon from the [Releases page](https://github.com/wowmusicplus/MusicPlus/releases/latest)**, not the green **Code** button. The Code download is only the source and has **no songs** in it.

---

## What it does

In each supported zone, MusicPlus plays:

1. **All of that zone's original Classic tracks** (day and night together), in a shuffled order. These are played straight from your game client by file ID, so they aren't included in the download.
2. **Then all 6 new songs** for that zone, also shuffled.
3. Then it starts over with a fresh shuffle of both groups.

A few details:

- Every time you enter a zone (login, crossing a border, walking out of an inn) you get a new shuffle, and the song you just heard is never the first one of the next round.
- Capitals always count as the capital, never as the zone around them (Stormwind is never Elwynn, Ironforge is never Dun Morogh, Undercity is never Tirisfal).
- The songs play on the game's **Music** channel, so the game's own **Music volume** controls how loud they are. Ambience and all other sounds are left alone.
- When MusicPlus stops (an inn, leaving the supported zones, `/mplus off`), the song **fades out smoothly** and the game's own music comes right back. Your Music volume is always put back exactly as it was.

### The 24 zones

6 capital cities, 6 starting zones and 12 leveling zones, from level 1 to 45. The number after each zone is how many original Classic tracks it has. Every zone also has 6 new songs.

| Group | Zones |
|---|---|
| Capital cities | Stormwind (8), Ironforge (3), Darnassus (3), Orgrimmar (2), Thunder Bluff (3), Undercity (3) |
| Starting zones (1–10) | Elwynn Forest (3), Dun Morogh (7), Teldrassil (5), Durotar (4), Mulgore (4), Tirisfal Glades (6) |
| Leveling zones (10–45) | Westfall (4), Loch Modan (3), Darkshore (4), Silverpine Forest (6), The Barrens (6), Redridge Mountains (3), Stonetalon Mountains (6), Duskwood (6), Ashenvale (5), Wetlands (5), Hillsbrad Foothills (3), Stranglethorn Vale (6) |

Zones that share music in the game share the same originals. For example, Elwynn, Loch Modan, Redridge and Hillsbrad all use the Forest tracks.

---

## Install

1. Go to the **[Releases page](https://github.com/wowmusicplus/MusicPlus/releases/latest)** and download **`MusicPlus-v0.5.2.zip`** (under *Assets*).
   Don't use the green **Code → Download ZIP** button: that one has no songs.
2. Extract the zip into your WoW Forever AddOns folder so the path looks exactly like this:
   ```
   World of Warcraft\_classic_beta_\Interface\AddOns\MusicPlus\MusicPlus.toc
   ```
   The zip already contains the `MusicPlus` folder, so extract it straight into `AddOns`. Make sure you don't end up with `MusicPlus\MusicPlus\...`.
3. Start the game. At character select, click **AddOns** and make sure **MusicPlus** is enabled (tick *Load out of date AddOns* if it's listed as out of date).
4. Log in. You should see `MusicPlus: v0.5.2 loaded (24 zones)` in chat, and a welcome window pops up once.

**Nothing to hear?** Check that the game's Music is turned on and its volume is up. `/mplus status` warns you if Music is off. `/mplus test` plays one of the custom songs anywhere, as a quick check.

---

## Options

Type **`/mplus`** to open the options window. Drag it to move it; X or Escape closes it. The same options are also under **Game Menu → Options → AddOns → MusicPlus**.

| Option | Default | What it does |
|---|---|---|
| Enable MusicPlus | On | Turns the addon on or off. |
| Loop music | **On** | Songs play back to back. **Off:** after each song there's a random 3–5 minutes of silence before the next one, like the game's own music with its Loop Music option off. Nothing plays during the silence, including the game's zone music. |
| Show song titles in chat | **Off** | **On:** prints `Now playing: <song> (Original 3/8)` in chat at every song change. The window and `/mplus status` always show the current song either way. |
| Play music when game is in background | **On** | The game's "Sound in Background" setting, so alt-tabbing doesn't interrupt the music. If you turn it off, MusicPlus remembers that. |
| Music volume slider | – | The same as the game's Music volume. |

The window also has a **Skip** button and shows the song playing now (or a countdown during a silence).

### Welcome window

The first time MusicPlus loads, a small **Welcome to MusicPlus** window appears with the three main options (Loop music, Show song titles, background sound). It only shows once. Type **`/mplus welcome`** to open it again any time.

---

## Commands

Use `/mplus` or `/musicplus`.

| Command | What it does |
|---|---|
| `/mplus` | Open or close the options window (also `/mplus options`) |
| `/mplus status` or `/mplus now` | Show what's playing, the zone, the position in the rotation and your settings |
| `/mplus skip` | Next song |
| `/mplus off` / `/mplus on` | Turn MusicPlus off (the game's music comes back) / back on |
| `/mplus replay` | Restart the current song from the beginning |
| `/mplus loop [on/off]` | Loop music on or off (no argument toggles it) |
| `/mplus titles [on/off]` | Song titles in chat on or off (no argument toggles it) |
| `/mplus bgsound` | Toggle "Sound in Background" |
| `/mplus welcome` | Show the welcome window again |
| `/mplus test` / `/mplus stop` | Play a custom song anywhere, as a sound check / stop the test |
| `/mplus where` | Show your map ID, position, zone, subzone and whether it counts as an inn |
| `/mplus inn` | Save the spot you're standing on (inside an inn) as an inn; `/mplus inn list` shows saved spots and `/mplus inn clear` removes them |
| `/mplus mode` | Switch playback method between `music` (default) and `sound` (for troubleshooting only) |
| `/mplus debug` | Show debug lines |
| `/mplus help` | List the commands |

---

## Inns

MusicPlus steps aside wherever the game plays **real tavern music**, so you still get the proper inn atmosphere. When you walk into one of these inns, the current song fades out over 2 seconds and the tavern music starts. When you walk back out, a fresh rotation begins.

| Zone | Inns with tavern music |
|---|---|
| Stormwind | The Slaughtered Lamb, bar floor (not the basement) |
| Elwynn Forest | Lion's Pride Inn, Goldshire (the whole building, including upstairs and cellar) |
| Ironforge | The Stonefire Tavern, Bruuk Barleybeard's bar (Military Ward), Cask 'n' Anvil (Great Forge) |
| Dun Morogh | Thunderbrew Distillery, Kharanos |
| Tirisfal Glades | Gallows' End Tavern, Brill |
| Durotar | The big hut in Sen'jin Village |
| Loch Modan | Stoutlager Inn, Thelsamar |
| Silverpine Forest | The inn in Pyrewood Village |
| The Barrens | Ratchet inn |
| Redridge Mountains | Lakeshire Inn |
| Stonetalon Mountains | The troll den at Malaka'jin |
| Duskwood | Scarlet Raven Tavern, Darkshire |
| Wetlands | Deepwater Tavern and the ship at Menethil, Dun Modr tavern, The Drunken Dwarf |
| Hillsbrad Foothills | Southshore inn |
| Stranglethorn Vale | The Salty Sailor Tavern (Booty Bay), the troll hut outside Zul'Gurub |
| Darkshore | The hut in the hidden troll village in the far north-east |

Good to know:

- **Other inns keep the rotation playing.** Places like the Gilded Rose, Razor Hill, the Crossroads, Bloodhoof Village, Astranaar, Auberdine, Tarren Mill and Grom'gol have no tavern music of their own in WoW Forever (the game plays the normal zone music there), so MusicPlus keeps going.
- Inns are recognized by your position plus being indoors. You need to be inside for about a second before the music switches, and it only switches back once you've clearly left, so doorways and stairs don't make the music flicker.
- **An inn isn't recognized?** Stand inside it and type `/mplus inn`. That saves the spot and prints its coordinates. Please [open an issue](https://github.com/wowmusicplus/MusicPlus/issues) with that line (or the output of `/mplus where`) so it can be built in.

---

## Quick check (optional)

1. `/reload`: chat says `MusicPlus: v0.5.2 loaded (24 zones)`.
2. `/mplus titles on`, then walk into Stormwind: `Now playing: ... (Original 1/8)`. Use `/mplus skip` to get to the custom songs (`Custom 1/6`).
3. Walk into the Slaughtered Lamb bar or the Lion's Pride Inn: the song fades out and tavern music plays. Walk back out: a new rotation starts.
4. Untick **Loop music** and let a song end: silence with a countdown in the window, then the next song 3–5 minutes later.

---

## Notes

- Settings are saved in `MusicPlusDB` (SavedVariables). If the Forever beta doesn't restore SavedVariables on your setup, the defaults come back at every login and the welcome window shows each time. MusicPlus can't do anything about that.
- If "Play music when game is in background" is off, the game cuts the song when you alt-tab. MusicPlus tries to restart it when you come back; if it ever misses, type `/mplus replay`.

See [CHANGELOG.md](CHANGELOG.md) for the version history.

---

## Music credits

- **Custom songs:** the 144 custom songs (6 per zone) were created by the author with [Suno](https://suno.com) on a Pro plan, which includes commercial rights.
- **Original Warcraft music:** the original zone music is © Blizzard Entertainment. MusicPlus plays it from your own game client; none of it is included in this repository or the release zip.

## License

The **code** (MusicPlus.lua, MusicPlus.toc and the rest of this repository) is released under the [MIT License](LICENSE).

The **custom songs** in the release zip are free to use with this addon, but they are **not** covered by the MIT license and aren't licensed for redistribution on their own.

---

*MusicPlus is an unofficial fan addon. It is not affiliated with or endorsed by Blizzard Entertainment. Built with Grok Bot. World of Warcraft and Warcraft are trademarks of Blizzard Entertainment, Inc.*
