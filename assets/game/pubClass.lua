---@alias Techmino.Player.Type 'brik'|'gela'|'acry'
---@alias Techmino.EndReason
---|'win'        Win (AC, Accepted)
---|'suffocate'  Suffocate (WA, Wrong Answer)
---|'lockout'    Lock out (CE, Compile Error)
---|'topout'     Top out (MLE, Memory Limit Exceeded)
---|'timeout'    Time out (TLE, Time Limit Exceeded)
---|'rule'       Rule violation (OLE, Output Limit Exceeded)
---|'exhaust'    Ran out pieces (ILE, Idleness Limit Exceeded)
---|'taskfail'   Task failed (PE, Presentation Error)
---|'other'      Other reason (UKE, Unknown Error)

---@alias Techmino.EventName -- All event function will be called with format `Event(P[,see below])`
---| 'beforePress'     -- General(act)
---| 'afterPress'      -- General(act)
---| 'beforeRelease'   -- General(act)
---| 'afterRelease'    -- General(act)
---| 'playerInit'      -- General
---| 'gameStart'       -- General
---| 'gameOver'        -- General(reason)
---| 'always'          -- General
---|
---| 'afterResetPos'   -- Brik, Gela
---| 'afterSpawn'      -- Brik, Gela
---| 'afterDrop'       -- Brik, Gela
---| 'afterLock'       -- Brik, Gela
---| 'beforeClear'     -- Brik(lines)
---| 'afterClear'      -- Brik(clear), Gela
---| 'beforeCancel'    -- Brik(atk), Gela(atk)
---| 'beforeSend'      -- Brik(atk), Gela(atk)
---| 'beforeDiscard'   -- Brik, Gela
---| 'drawBelowField'  -- Brik, Gela, Acry
---| 'drawBelowBlock'  -- Brik, Gela, Acry
---| 'drawBelowMarks'  -- Brik,       Acry
---| 'drawInField'     -- Brik, Gela, Acry
---| 'drawOnPlayer'    -- Brik, Gela, Acry
---|
---| 'whenSuffocate'   -- Brik, Gela
---| 'beforeResetPos'  -- Brik
---| 'extraSolidCheck' -- Brik
---|
---| 'legalMove'       -- Acry(mode)
---| 'illegalMove'     -- Acry(mode)

---@class Techmino.ParticleSystems
---@field rectShade love.ParticleSystem
---@field rectTilt love.ParticleSystem
---@field rectScale love.ParticleSystem
---@field spinArrow table
---@field star love.ParticleSystem
---@field boardSmoke love.ParticleSystem
---@field line love.ParticleSystem
---@field hitSparkle love.ParticleSystem
---@field cornerCheck love.ParticleSystem
---@field trail love.ParticleSystem
---@field exMapBack love.ParticleSystem

---@alias Techmino.Event string | {[1]:number, [2]:fun(P:Techmino.Player):...} | fun(P:Techmino.Player):...
---@alias Techmino.Event.Brik string | {[1]:number, [2]:fun(P:Techmino.Player.Brik):...} | fun(P:Techmino.Player.Brik):...
---@alias Techmino.Event.Gela string | {[1]:number, [2]:fun(P:Techmino.Player.Gela):...} | fun(P:Techmino.Player.Gela):...
---@alias Techmino.Event.Acry string | {[1]:number, [2]:fun(P:Techmino.Player.Acry):...} | fun(P:Techmino.Player.Acry):...



---@class Techmino.Brik.Cell
---@field id number piece id
---@field did number drop id (exist when hand piece locks)
---@field cid string cell id (unique) (already exist when piece display in next queue)
---@field color number 0~63
---@field alpha? number 0~1
---@field conn table<string, any>
---@field bias {expBack?:number, lineBack?:number, teleBack?:number, x:number, y:number}
---@field visTimer? number
---@field fadeTime? number
---@field visStep? number
---@field visMax? number
---
---@field diggable boolean Gela only
---@field connClear boolean Gela only

---@alias Techmino.RectPiece Mat<Techmino.Brik.Cell|false>

---@class Techmino.Piece
---@field id Techmino.Brik.ID
---@field shape number
---@field direction 0|1|2|3|number
---@field name Techmino.Brik.Name
---@field matrix Techmino.RectPiece
---@field _origin Techmino.Piece
---
---@field size number Gela only

---@class Techmino.BrikDropHis
---@field id number
---@field x number
---@field y number
---@field direction number
---@field time number
---@field gameTime number

---@class Techmino.BrikClearHis
---@field combo number
---@field line number
---@field linePos number[]
---@field time number
---@field gameTime number

---@class Techmino.BrikMovement
---@field action string
---@field brik Techmino.Piece
---@field x number
---@field y number
---@field immobile? boolean
---@field corners? boolean
---@field clear? number[]
---@field combo? number



---@alias Techmino.Acry.Prop 'fire'|'elec'|'hyper'|'lock'|'stepbomb'|'timebomb'|'butterfly'|'multiplier'|string
---@alias Techmino.Acry.State
---|'idle'
---|'fall'
---|'moveAhead'
---|'moveBack'
---|'moveWait'
---|'clear'
---
---|'_discard'

---@class Techmino.Acry.Cell
---@field id string cell id (unique)
---@field color number 1~7
---@field prop Techmino.Acry.Prop[]
---@field propData table
---
---@field gridX integer
---@field gridY integer
---@field biasX number
---@field biasY number
---
---@field state Techmino.Acry.State
--- 'idle':
---     @field stableTime integer
--- 'moveAhead':
---     @field active boolean
---     @field wallHit boolean
---     @field moveDirection integer[]
---     @field moveTimer integer
---     @field moveDelay integer
---     @field moveReadyDelay integer
--- 'moveWait':
---     @field waitTimer integer
---     @field waitDelay integer
--- 'moveBack':
---     moveTimer integer (same as in moveAhead)
---     moveDelay integer (same as in moveAhead)
--- 'fall':
---     @field fallSpeed integer
--- 'clear':
---     @field clearTimer integer
---     @field clearDelay integer
---     @field craftTargetBias integer[]
--- '_discard':
---
---@field _newState Techmino.Acry.State|false



---@class Techmino.Mode
---@field initialize function Called when initializing the mode
---@field settings {brik:Techmino.Mode.Setting.Brik?, gela:Techmino.Mode.Setting.Gela?, acry:Techmino.Mode.Setting.Acry?}
---@field layout 'default' Layout mode
---@field checkFinish function Return if the game should end when a player finishes
---@field result function Called when the game ends
---@field resultPage fun(time:number) Drawing the result page
---@field name string Mode name, for debug use

---@class Techmino.PlayerModeData
---@field subMode string
---@field music Techmino.PlayerModeData.MusicTable
---@field target {[any]:any}
---@field [any] any

---@class Techmino.PlayerModeData.MusicTable
---@field id? string FMOD parameter name, default to 'intensity'
---@field path string Lerping value path, like 'modeData.xxx.yyy' or '.xxx.yyy' in short
---@field s? number Lerping start point, leave this empty to use direct value instead of 0~1 lerping
---@field e? number Lerping end point
