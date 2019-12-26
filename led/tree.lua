-- luacheck: globals ws2812 hsvToRgb tmr
ws2812.init()

require('color')

local RGB = {}

function RGB:new(r, g, b)
    local newObj = {r = r, g = g, b = b}
    self.__index = self
    return setmetatable(newObj, self)
end

local BLACK = RGB:new(0,0,0)
local WHITE = RGB:new(255,255,255)
local RED = RGB:new(255,0,0)
local ORANGE = RGB:new(255, 127, 0)
local YELLOW = RGB:new(255, 255, 0)
local GREEN = RGB:new(0,255,0)
local BLUE = RGB:new(0,0,255)
local INDIGO = RGB:new(46, 43, 95)
local VIOLET = RGB:new(139, 0, 255)

local RAINBOW = {
    RED,
    ORANGE,
    YELLOW,
    GREEN,
    BLUE,
    INDIGO,
    VIOLET,
    WHITE
}

local HSV = {}

function HSV:new(h, s, v)
    local r, g, b = hsvToRgb(h, s, v)

    local newObj = {r = r, g = g, b = b}
    self.__index = self
    return setmetatable(newObj, self)
end

local Strip = {}

function Strip:new(buffer, start, length, isUp)
    local newObj = {buffer = buffer, start = start, length = length, isUp = isUp}
    self.__index = self
    return setmetatable(newObj, self)
end

function Strip:set(index, color)
    self.buffer:set(self.start + index -1, color.g, color.r, color.b)
end

function Strip:all(color)
    for i = 1, self.length do
	self:set(i, color)
    end
end

local Tree = {}

function Tree:new()
    local strip_length = 15
    local strip_count = 8
    local star_length = 16
    local buffer = ws2812.newBuffer(strip_length * strip_count + star_length, 3)
    local strips = {
	Strip:new(buffer, 1, strip_length, true), -- 1
	Strip:new(buffer, 91, strip_length, true), -- 7
	Strip:new(buffer, 76, strip_length, false), -- 6
	Strip:new(buffer, 31, strip_length, true), -- 3
	Strip:new(buffer, 16, strip_length, false), -- 2
	Strip:new(buffer, 106, strip_length, false), -- 8
	Strip:new(buffer, 61, strip_length, true),  -- 5
	Strip:new(buffer, 46, strip_length, false),  -- 4
    }
    local star = Strip:new(buffer, strip_length * strip_count + 1, star_length)

    local newObj = {strips = strips, star = star, buffer = buffer }
    self.__index = self
    return setmetatable(newObj, self)
end

function Tree:update()
    ws2812.write(self.buffer)
end

function Tree:all(rgb)
    rgb = rgb or BLACK

    if type(rgb[1]) == 'nil' then
	rgb = {rgb}
    end

    for i = 1, #self.strips do
	print("s:" .. i .. " index:" .. i % #rgb + 1)
	self.strips[i]:all(rgb[i % #rgb + 1]) -- RAINBOW[i])
    end
end


local PATTERNS = {
    GREEN, RAINBOW
}
local pattern_index = 1





local tree = Tree:new()
tree.star:all(YELLOW)

local function next_pattern()
    print("next_pattern:" .. pattern_index , " num patterns:".. #PATTERNS)
    tree:all(PATTERNS[pattern_index])
    tree:update()
    pattern_index = pattern_index % #PATTERNS + 1
    print("pattern_index is now" .. pattern_index)
end

next_pattern()


local timer = tmr.create()
timer:register(3000, tmr.ALARM_AUTO, next_pattern)
timer:start()
