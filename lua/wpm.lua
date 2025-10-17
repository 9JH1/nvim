local M = {}

local last_time = os.time()
local last_word_count = 0
local wpm_history = {} -- Store recent WPM samples

local function calculate_wpm()
    local current_word_count = vim.fn.wordcount().words
    local current_time = os.time()

    if current_word_count > last_word_count and current_time > last_time then
        local words_typed = current_word_count - last_word_count
        local time_elapsed = current_time - last_time -- in seconds
        local wpm = math.floor((words_typed / time_elapsed) * 60)
        table.insert(wpm_history, wpm)
        -- Keep a limited history, e.g., last 10 samples
        if #wpm_history > 10 then
            table.remove(wpm_history, 1)
        end
    end

    last_word_count = current_word_count
    last_time = current_time

    -- Calculate average WPM from history or return the last calculated WPM
    if #wpm_history > 0 then
        local total_wpm = 0
        for _, w in ipairs(wpm_history) do
            total_wpm = total_wpm + w
        end
        return math.floor(total_wpm / #wpm_history)
    else
        return 0
    end
end

M.wpm_component = function()
    if vim.fn.mode() == "i" or vim.fn.mode() == "R" then
        return calculate_wpm() .. " WPM"
    else
        return "Enter Insert Mode"
    end
end

return M
