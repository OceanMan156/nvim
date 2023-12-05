-- Spotify specific function for operation
local curl = require("plenary.curl")
local encodedClient = os.getenv("clientCredentials")
local clientRefreshtoken = os.getenv("clientRefreshtoken")
local defaultDeviceName = os.getenv("defaultDeviceName")

-- Telescope imports for floating windows
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values
vim.notify = require("notify")
local Job = require'plenary.job'


-- PLaylist and tract objects
local playlists
local playlistId = {}
local trackUri = {}
local playlistUri = {}
local selectedPlaylist
local tracks
local devices = {}
local selectedDevice
local retrived = false

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

Job:new({
  command = 'sleep',
  args = {'10'},
  on_exit = function(j, return_val)
    print(return_val)
    print(dump(j:result()))
  end,
}):start() -- or start()

local function getAuth()
 local url = "https://accounts.spotify.com/api/token"
  local res = curl.post(url, {
    headers = {
      Authorization = "Basic " .. encodedClient
    },
    body = {
      grant_type = "refresh_token",
      refresh_token = clientRefreshtoken,
    }
    --body = {
    --  grant_type = "authorization_code",
    --  code = "",
    --  redirect_uri = "https://example.com/callback"
    --}
  })
  --print(res.body)
  return vim.fn.json_decode(res.body).access_token
end


local function getDevices()
  local token = getAuth()
  local url = "https://api.spotify.com/v1/me/player/devices"
  local res = curl.get(url, {
    headers = {
      Authorization = "Bearer " .. token,
    },
  })
  local dev = vim.fn.json_decode(res.body)
  local empty = true
  for i, _ in ipairs(dev.devices) do
    devices[dev.devices[i].name] = dev.devices[i].id
    empty = false
  end

  if empty then
    vim.notify("No device found","error")
  end
end

local function Play()
  if devices[defaultDeviceName] == nil then
    getDevices()
    selectedDevice = devices[defaultDeviceName]
  end

  local token = getAuth()
  local url = "https://api.spotify.com/v1/me/player/play?device_id=" .. selectedDevice
  local res = curl.put(url, {
    headers = {
      Authorization = "Bearer " .. token,
      content_type = "application/json",
    },
  })
  vim.notify(dump(res))
end

local function PlayUri(Uri, playlisturi)
  local token = getAuth()
  local jsonUri = {uri = Uri}
  local json = {context_uri = playlisturi, position_ms = 0, offset = jsonUri}
  local url = "https://api.spotify.com/v1/me/player/play?device_id=" .. selectedDevice
  local res = curl.put(url, {
    headers = {
      Authorization = "Bearer " .. token,
      content_type = "application/json",
    },
    body = vim.fn.json_encode(json)
  })
end

local function Pause()
  local token = getAuth()
  local url = "https://api.spotify.com/v1/me/player/pause"
  local res = curl.put(url, {
    headers = {
      Authorization = "Bearer " .. token,
    },
  })
end

-- NOT WORKING
local function AddtoQueue(Uri)
  local line = vim.trim(vim.api.nvim_get_current_line())
  if line[1] == "-" then
    local token = getAuth()
    local query = {uri = trackUri[vim.trim(line[2])]}
    local url = "https://api.spotify.com/v1/me/player/queue"
    local res = curl.post(url, {
      query = query,
      headers = {
        Authorization = "Bearer " .. token,
      },
    })
    print(res.body)
  end
end

local function Next()
  local token = getAuth()
  local url = "https://api.spotify.com/v1/me/player/next"
  local res = curl.post(url, {
    headers = {
      Authorization = "Bearer " .. token,
    },
  })
end

local function ListSongs(index)
  local sl = {}

  getDevices()

  local token = getAuth()
  local url = "https://api.spotify.com/v1/playlists/" .. playlistId[index] .. "/tracks"
  local res = curl.get(url, {
    headers = {
      Authorization = "Bearer " .. token,
    },
  })
  tracks = vim.fn.json_decode(res.body)

  for key, _ in pairs(devices) do
    table.insert(sl, "Devices: " .. key)
  end

  for i, _ in ipairs(tracks.items) do
    table.insert(sl, "Songs: " .. tracks.items[i].track.name)
    trackUri[tracks.items[i].track.name] = tracks.items[i].track.uri
  end

  return sl
end

-- Get Playlist once rather than everytime
local function getPlaylist()
    local token = getAuth()
    local url = "https://api.spotify.com/v1/me/playlists"
    local res = curl.get(url, {
      headers = {
        Authorization = "Bearer " .. token,
      },
    })
    playlists = vim.fn.json_decode(res.body)
    retrived = true
end

local TeleSongs = function(opts, pl)
  local songlist = ListSongs(pl)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Songs",
    finder = finders.new_table {
      results = songlist
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        --actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local type = vim.split(selection[1], ":")[1]
        local val = vim.split(selection[1], ":")[2]

        val = vim.trim(val)

        if type == "Devices" then
          selectedDevice = devices[val]
        end

        if type == "Songs" then
          actions.close(prompt_bufnr)
          vim.notify("Playing: " .. val, "info")
          PlayUri(trackUri[val], playlistUri[selectedPlaylist])
        end
      end)
      return true
    end,
  }):find()
end

local TelePlaylist = function(opts, pl)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Playlist",
    finder = finders.new_table {
      results = pl
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        selectedPlaylist = selection[1]
        TeleSongs(require("telescope.themes").get_dropdown{}, selection[1])
      end)
      return true
    end,
  }):find()
end

local function List()
  if not retrived then
    getPlaylist()
    getDevices()
  end
    local pl = {}

    for index, _ in ipairs(playlists.items) do
      table.insert(pl, playlists.items[index].name)
      playlistId[playlists.items[index].name] = playlists.items[index].id
      playlistUri[playlists.items[index].name] = playlists.items[index].uri
    end
    TelePlaylist(require("telescope.themes").get_dropdown{}, pl)
end

return {
  Play = Play,
  Pause = Pause,
  Next = Next,
  List = List,
  AddtoQueue = AddtoQueue
}
