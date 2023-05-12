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
  local url = "https://api.spotify.com/v1/me/player/play"
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
  local url = "https://api.spotify.com/v1/me/player/play"
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
    if vim.trim(line[1]) ~= "-" and not string.match(line[1], "Available Playlists") then
      selectedPlaylist = vim.trim(line[2])
      ListSongs(tonumber(line[1]))
    end
    if vim.trim(line[1]) == "-" then
      PlayUri(trackUri[vim.trim(line[2])], playlistUri[selectedPlaylist])
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

    local firstLine = "Available Playlists:"
    vim.api.nvim_buf_set_text(0,0,0,0,0,{firstLine})
    vim.cmd("center")

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
  List = List
}
