
local function trim(str)
    return string.gsub(str, "^%s*(.-)%s*$", "%1")
end

local function escapePattern(pattern)
    return pattern:gsub("([%.%+%-%*%?%^%$%(%)%%%[%]%{%}%|])", "%%%1")
end

local function removeBasePath(source, base)
    local escapedBase = escapePattern(base)
    return (source:gsub("^" .. escapedBase .. "/?", ""))
end

local function exec(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return trim(result)
end

local function Gotogh()
    local url = exec("git config remote.origin.url")
    local branch = exec("git branch --show-current")
    local basePath = exec("git rev-parse --show-toplevel")

    if string.find(url, "@") then
        url = string.gsub(url, ":", "/")
        url = string.gsub(url, "git@", "https://")
        url = string.gsub(url, ".git$", "")
    end

    local file = vim.fn.expand("%:p")
    local line = vim.fn.line(".")

    local filePath = removeBasePath(file, basePath)

    local cmd = "open " .. url .. "/blob/" .. branch .. "/" .. filePath .. "#L" .. line

    os.execute(cmd)
end

local function setup()
    vim.api.nvim_create_user_command("Gotogh", Gotogh, {
        desc = "open the current file in the github",
        nargs = 0,
    })
end

return {
    setup = setup
}

