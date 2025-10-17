local M = {}

local last_time = vim.loop.hrtime() -- High-resolution timer (nanoseconds)
local last_word_count = 0
local wpm_history = {}              -- Store recent WPM samples
local typing_started = false        -- Track if typing has started
local MIN_TIME_ELAPSED = 0.5e9      -- 0.5 seconds in nanoseconds
local HISTORY_SIZE = 10             -- Number of WPM samples to average
local TIME_WINDOW = 30e9            -- 30 seconds in nanoseconds

-- Animation state for number display
local animation_states = { "%d WPM", "[%d WPM]" } -- Alternate between formats
local animation_index = 1                         -- Current animation frame
local animation_timer = nil                       -- Timer for animation updates
local ANIMATION_INTERVAL = 1000                   -- Slower animation: 1 second per update

-- Function to calculate WPM
local function calculate_wpm()
	local current_word_count = vim.fn.wordcount().words
	local current_time = vim.loop.hrtime()

	if vim.fn.mode() == "i" or vim.fn.mode() == "R" then
		if not typing_started then
			typing_started = true
			last_word_count = current_word_count
			last_time = current_time
			return 0
		end

		local words_typed = current_word_count - last_word_count
		local time_elapsed = current_time - last_time

		-- Handle deletions: reset if word count drops significantly
		if current_word_count < last_word_count then
			wpm_history = {}       -- Clear history on significant deletion
			last_word_count = current_word_count
			last_time = current_time
			return 0
		end

		-- Calculate WPM if words were typed and enough time has elapsed
		if words_typed > 0 and time_elapsed >= MIN_TIME_ELAPSED then
			local wpm = (words_typed / (time_elapsed / 1e9)) * 60
			table.insert(wpm_history, { wpm = wpm, timestamp = current_time })

			-- Remove samples outside the time window
			while #wpm_history > 0 and (current_time - wpm_history[1].timestamp) > TIME_WINDOW do
				table.remove(wpm_history, 1)
			end

			-- Cap history size
			if #wpm_history > HISTORY_SIZE then
				table.remove(wpm_history, 1)
			end

			-- Calculate average WPM
			local total_wpm = 0
			for _, entry in ipairs(wpm_history) do
				total_wpm = total_wpm + entry.wpm
			end
			last_word_count = current_word_count
			last_time = current_time
			return math.floor(total_wpm / #wpm_history)
		end
	else
		-- Reset when exiting insert mode
		typing_started = false
		wpm_history = {}
		last_word_count = current_word_count
		last_time = current_time
	end

	-- Return last WPM or 0 if no history
	return #wpm_history > 0 and math.floor(wpm_history[#wpm_history].wpm) or 0
end

-- Function to update animation
local function update_animation()
	animation_index = animation_index % #animation_states + 1
	vim.api.nvim_command('redrawstatus')   -- Force statusline refresh
end

-- Start animation timer
local function start_animation()
	if animation_timer then
		animation_timer:stop()
		animation_timer:close()
	end
	animation_timer = vim.loop.new_timer()
	animation_timer:start(ANIMATION_INTERVAL, ANIMATION_INTERVAL, vim.schedule_wrap(update_animation))
end

-- Stop animation timer
local function stop_animation()
	if animation_timer then
		animation_timer:stop()
		animation_timer:close()
		animation_timer = nil
	end
	animation_index = 1
end

M.wpm_component = function()
	local mode = vim.fn.mode()
	if mode == "i" or mode == "R" then
		-- Start animation in insert mode
		start_animation()
		local wpm = calculate_wpm()
		return string.format(animation_states[animation_index], wpm)
	else
		-- Stop animation outside insert mode
		stop_animation()
		return "Enter Insert Mode"
	end
end

-- Clean up timer when Neovim exits
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		stop_animation()
	end,
})

return M
