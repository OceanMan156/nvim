local curl = require("plenary.curl")
local encodedClient = os.getenv("clientCredentials")
local clientRefreshtoken = os.getenv("clientRefreshtoken")
local namespaceid
local playlists
local playlistId = {}
local trackUri = {}
local playlistUri = {}
local selectedPlaylist
local tracks
local devices = {}
local selectedDevice

local open = false
local retrived = false
local retrivedSongs = false

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

local function Play()
  local token = getAuth()
  local url = "https://api.spotify.com/v1/me/player/play?device_id=" .. selectedDevice
  local res = curl.put(url, {
    headers = {
      Authorization = "Bearer " .. token,
      content_type = "application/json",
    },
  })
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

local function getDevices()
  local token = getAuth()
  local url = "https://api.spotify.com/v1/me/player/devices"
  local res = curl.get(url, {
    headers = {
      Authorization = "Bearer " .. token,
    },
  })
  local dev = vim.fn.json_decode(res.body)
  for i, vlaue in ipairs(dev.devices) do
    devices[dev.devices[i].name] = dev.devices[i].id
  end
end

local function ListDevices()
  vim.api.nvim_buf_set_lines(0,0,0,0,{"    Available Devices"})
  local index = 1
  for key, vlaue in pairs(devices) do
    vim.api.nvim_buf_set_lines(0,index,index,0,{" =: "..key})
    index = index + 1
  end
  vim.api.nvim_buf_set_lines(0,index,index,0,{""})
end

local function ListSongs(index)
  if not retrivedSongs then
    local token = getAuth()
    local url = "https://api.spotify.com/v1/playlists/" .. playlistId[index] .. "/tracks"
    local res = curl.get(url, {
      headers = {
        Authorization = "Bearer " .. token,
      },
    })
    tracks = vim.fn.json_decode(res.body)
    retrivedSongs = true
  end

  for i, value in ipairs(tracks.items) do
    local line = "    -: " .. tracks.items[i].track.name
    trackUri[tracks.items[i].track.name] = tracks.items[i].track.uri
    vim.api.nvim_buf_set_lines(0,index+1,index+1,0,{line})
  end
end

local function checkEnter(key)
  if string.byte(key) == 13 then
    local line = vim.api.nvim_get_current_line()
    line = vim.split(line,":")
    -- Sending Line Index
    if vim.trim(line[1]) ~= "-" and vim.trim(line[1]) ~= "=" and not string.match(line[1], "Available Playlists") then
      selectedPlaylist = vim.trim(line[2])
      ListSongs(tonumber(line[1]))
      ListDevices()
    end
    if vim.trim(line[1]) == "-" then
      PlayUri(trackUri[vim.trim(line[2])], playlistUri[selectedPlaylist])
    end
    if vim.trim(line[1]) == "=" then
      selectedDevice = devices[vim.trim(line[2])]
    end
  end
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

local function List()
  if not retrived then
    getPlaylist()
    getDevices()
  end
  if open then
    vim.on_key(nil, namespaceid)
    open = false
    vim.cmd("close")
  else

    vim.cmd('vsplit')
    local buffer = vim.api.nvim_create_buf(true, true)
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buffer)

    local firstLine = "    Available Playlists:"
    vim.api.nvim_buf_set_lines(0,0,0,0,{firstLine})
    vim.cmd("vertical resize 42")

    for index, value in ipairs(playlists.items) do
      local line = " " .. index .. ": " .. playlists.items[index].name
      playlistId[index] = playlists.items[index].id
      playlistUri[playlists.items[index].name] = playlists.items[index].uri
      vim.api.nvim_buf_set_lines(0,index,index,0,{line})
    end

    namespaceid = vim.on_key(checkEnter)
    open = true
  end
end

return {
  Play = Play,
  Pause = Pause,
  Next = Next,
  List = List,
  AddtoQueue = AddtoQueue
}
