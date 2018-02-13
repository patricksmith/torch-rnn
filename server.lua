require 'torch'
require 'nn'

require 'LanguageModel'

local cmd = torch.CmdLine()
cmd:option('-port', 9090)
local server_opts = cmd:parse(arg)

local opt = {}
opt.checkpoint = 'cv/checkpoint_20000.t7'
opt.length = 120
opt.start_text = 'Read me from the query'
opt.sample = 1
opt.gpu = -1
opt.verbose = 0
opt.temperature = 0.6


local checkpoint = torch.load(opt.checkpoint)
local model = checkpoint.model
model:evaluate()

local pegasus = require 'pegasus'
local server = pegasus:new({
  port=server_opts.port,
  location='/views/'
})

server:start(function (request, response)
  print('method', request:method())
  print('path', request:path())
  local params = request:params()
  print('params', params)
  local start = params.start
  print('starting with', start)

  response = response:statusCode(200):contentType('application/json')
  if (start ~= nil) then
    opt.start_text = start
    opt.length = 100 + string.len(start)
    local sample = model:sample(opt)
    response:write('{ "data": "' .. sample .. '" }')
  else
    response:write('{ "error": "Give me something to work with" }')
  end
end)
