
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

local function jump(url)
    -- isBrowserEnvAvailable
    if vim.fn.exists("$BROWSER") == 1 then
        local cmd = "bash -c '" .. os.getenv("BROWSER") .. " " .. url .. " 2>/dev/null'"
        os.execute(cmd)
        return
    end
    
    -- isOpenAvailable
    if vim.fn.has("mac") == 1 then
        local cmd = "open " .. url
        os.execute(cmd)
        return
    end

    print("No browser available. Click: " .. url)
    return
end

local function file(base, filepath, ln)
    local basePath = exec("git rev-parse --show-toplevel")
    local gitpath = removeBasePath(filepath, basePath)
    local branch = exec("git branch --show-current")
    local ghUrl = base .. "/blob/" .. branch .. "/" .. gitpath .. "#L" .. ln
    jump(ghUrl)
end

local function commit(base, fullpath, ln)
    local sha = exec("git blame -c -l -L " .. ln .. "," .. ln .. " " .. fullpath .. " | awk '{print $1}' | head -1")
    local ghUrl = base .. "/commit/" .. sha
    jump(ghUrl)
end

local function pr(base, fullpath, ln)
    local sha = exec("git blame -c -l -L " .. ln .. "," .. ln .. " " .. fullpath .. " | awk '{print $1}' | head -1")
    local ghUrl = base .. "/pulls?q=" .. sha
    jump(ghUrl)
end

local function Gotogh(mode)
    local url = exec("git config remote.origin.url")

    if string.find(url, "@") then
        url = string.gsub(url, ":", "/")
        url = string.gsub(url, "git@", "https://")
        url = string.gsub(url, ".git$", "")
    end

    local ln = vim.fn.line(".")
    local filepath = vim.fn.expand("%:p")

    if mode == "commit" then
        commit(url, filepath, ln)
    elseif mode == "pr" then
        pr(url, filepath, ln)
    else
        file(url, filepath, ln)
    end
end

local function setup()
    vim.api.nvim_create_user_command("Gotogh", function()
        Gotogh("file")
    end, {
        nargs = 0,
    })

    vim.api.nvim_create_user_command("GotoghCommit", function()
        Gotogh("commit")
    end, {
        nargs = 0,
    })

    vim.api.nvim_create_user_command("GotoghPr", function()
        Gotogh("pr")
    end, {
        nargs = 0,
    })
end

return {
    setup = setup
}

