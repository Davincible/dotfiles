local fn = vim.fn
local git = require("uno.heirline.astro.git")
--- Updater settings overridden with any user provided configuration
local options = unoline.user_plugin_opts("updater", {
	remote = "origin",
	channel = "stable",
	show_changelog = true,
	auto_reload = true,
	auto_quit = true,
})

-- set the install channel
if options.branch then
	options.channel = "nightly"
end
if unoline.install.is_stable ~= nil then
	options.channel = unoline.install.is_stable and "stable" or "nightly"
end

unoline.updater = { options = options }
-- -- if the channel is stable or the user has chosen to pin the system plugins
-- if options.pin_plugins == nil and options.channel == "stable" or options.pin_plugins then
-- 	-- load the current packer snapshot from the installation home location
-- 	local loaded, snapshot = pcall(fn.readfile, unoline.install.home .. "/packer_snapshot")
-- 	if loaded then
-- 		-- decode the snapshot JSON and save it to a variable
-- 		loaded, snapshot = pcall(fn.json_decode, snapshot)
-- 		unoline.updater.snapshot = type(snapshot) == "table" and snapshot or nil
-- 	end
-- 	-- if there is an error loading the snapshot, print an error
-- 	if not loaded then
-- 		vim.api.nvim_err_writeln("Error loading packer snapshot")
-- 	end
-- end

--- Get the current unoline version
-- @param quiet boolean to quietly execute or send a notification
-- @return the current unoline version string
function unoline.updater.version(quiet)
	local version = unoline.install.version or git.current_version(false)
	if version and not quiet then
		unoline.notify("Version: " .. version)
	end
	return version
end

--- Get the full unoline changelog
-- @param quiet boolean to quietly execute or display the changelog
-- @return the current unoline changelog table of commit messages
function unoline.updater.changelog(quiet)
	local summary = {}
	vim.list_extend(summary, git.pretty_changelog(git.get_commit_range()))
	if not quiet then
		unoline.echo(summary)
	end
	return summary
end

--- Attempt an update of unoline
-- @param target the target if checking out a specific tag or commit or nil if just pulling
local function attempt_update(target)
	-- if updating to a new stable version or a specific commit checkout the provided target
	if options.channel == "stable" or options.commit then
		return git.checkout(target, false)
		-- if no target, pull the latest
	else
		return git.pull(false)
	end
end

--- Cancelled update message
local cancelled_message = { { "Update cancelled", "WarningMsg" } }

--- Reload the unoline configuration live (Experimental)
-- @param quiet boolean to quietly execute or send a notification
function unoline.updater.reload(quiet)
	-- stop LSP if it is running
	if vim.fn.exists(":LspStop") ~= 0 then
		vim.cmd("LspStop")
	end
	local reload_module = require("plenary.reload").reload_module
	-- unload unoline configuration files
	reload_module("user", false)
	reload_module("configs", false)
	reload_module("default_theme", false)
	reload_module("core", false)
	-- manual unload some plugins that need it if they exist
	reload_module("cmp", false)
	reload_module("which-key", false)
	-- source the unoline configuration
	local reloaded, _ = pcall(dofile, vim.fn.expand("$MYVIMRC"))
	-- if successful reload and not quiet, display a notification
	if reloaded and not quiet then
		unoline.notify("Reloaded unoline")
	end
end

--- unoline's updater function
function unoline.updater.update()
	-- if the git command is not available, then throw an error
	if not git.available() then
		unoline.notify(
			"git command is not available, please verify it is accessible in a command line. This may be an issue with your PATH",
			"error"
		)
		return
	end

	-- if installed with an external package manager, disable the internal updater
	if not git.is_repo() then
		unoline.notify("Updater not available for non-git installations", "error")
		return
	end
	-- set up any remotes defined by the user if they do not exist
	for remote, entry in pairs(options.remotes and options.remotes or {}) do
		local url = git.parse_remote_url(entry)
		local current_url = git.remote_url(remote, false)
		local check_needed = false
		if not current_url then
			git.remote_add(remote, url)
			check_needed = true
		elseif
			current_url ~= url
			and unoline.confirm_prompt({
				{ "Remote " },
				{ remote, "Title" },
				{ " is currently set to " },
				{ current_url, "WarningMsg" },
				{ "\nWould you like us to set it to " },
				{ url, "String" },
				{ "?" },
			})
		then
			git.remote_update(remote, url)
			check_needed = true
		end
		if check_needed and git.remote_url(remote, false) ~= url then
			vim.api.nvim_err_writeln("Error setting up remote " .. remote .. " to " .. url)
			return
		end
	end
	local is_stable = options.channel == "stable"
	if is_stable then
		options.branch = "main"
	elseif not options.branch then
		options.branch = "nightly"
	end
	-- fetch the latest remote
	if not git.fetch(options.remote) then
		vim.api.nvim_err_writeln("Error fetching remote: " .. options.remote)
		return
	end
	-- switch to the necessary branch only if not on the stable channel
	if not is_stable then
		local local_branch = (options.remote == "origin" and "" or (options.remote .. "_")) .. options.branch
		if git.current_branch() ~= local_branch then
			unoline.echo({
				{ "Switching to branch: " },
				{ options.remote .. "/" .. options.branch .. "\n\n", "String" },
			})
			if not git.checkout(local_branch, false) then
				git.checkout("-b " .. local_branch .. " " .. options.remote .. "/" .. options.branch, false)
			end
		end
		-- check if the branch was switched to successfully
		if git.current_branch() ~= local_branch then
			vim.api.nvim_err_writeln("Error checking out branch: " .. options.remote .. "/" .. options.branch)
			return
		end
	end
	local source = git.local_head() -- calculate current commit
	local target -- calculate target commit
	if is_stable then -- if stable get tag commit
		local version_search = options.version or "latest"
		options.version = git.latest_version(git.get_versions(version_search))
		if not options.version then -- continue only if stable version is found
			vim.api.nvim_err_writeln("Error finding version: " .. version_search)
			return
		end
		target = git.tag_commit(options.version)
	elseif options.commit then -- if commit specified use it
		target = git.branch_contains(options.remote, options.branch, options.commit) and options.commit or nil
	else -- get most recent commit
		target = git.remote_head(options.remote, options.branch)
	end
	if not source or not target then -- continue if current and target commits were found
		vim.api.nvim_err_writeln("Error checking for updates")
		return
	elseif source == target then
		unoline.echo({ { "No updates available", "String" } })
		return
	elseif -- prompt user if they want to accept update
		not options.skip_prompts
		and not unoline.confirm_prompt({
			{ "Update available to ", "Title" },
			{ is_stable and options.version or target, "String" },
			{ "\nUpdating requires a restart, continue?" },
		})
	then
		unoline.echo(cancelled_message)
		return
	else -- perform update
		-- calculate and print the changelog
		local changelog = git.get_commit_range(source, target)
		local breaking = git.breaking_changes(changelog)
		local breaking_prompt = { { "Update contains the following breaking changes:\n", "WarningMsg" } }
		vim.list_extend(breaking_prompt, git.pretty_changelog(breaking))
		vim.list_extend(breaking_prompt, { { "\nWould you like to continue?" } })
		if #breaking > 0 and not options.skip_prompts and not unoline.confirm_prompt(breaking_prompt) then
			unoline.echo(cancelled_message)
			return
		end
		-- attempt an update
		local updated = attempt_update(target)
		-- check for local file conflicts and prompt user to continue or abort
		if
			not updated
			and not options.skip_prompts
			and not unoline.confirm_prompt({
				{ "Unable to pull due to local modifications to base files.\n", "ErrorMsg" },
				{ "Reset local files and continue?" },
			})
		then
			unoline.echo(cancelled_message)
			return
			-- if continued and there were errors reset the base config and attempt another update
		elseif not updated then
			git.hard_reset(source)
			updated = attempt_update(target)
		end
		-- if update was unsuccessful throw an error
		if not updated then
			vim.api.nvim_err_writeln("Error ocurred performing update")
			return
		end
		-- print a summary of the update with the changelog
		local summary = {
			{ "unoline updated successfully to ", "Title" },
			{ git.current_version(), "String" },
			{ "!\n", "Title" },
			{
				options.auto_reload and "unoline will now sync packer and quit.\n\n"
					or "Please restart and run :PackerSync.\n\n",
				"WarningMsg",
			},
		}
		if options.show_changelog and #changelog > 0 then
			vim.list_extend(summary, { { "Changelog:\n", "Title" } })
			vim.list_extend(summary, git.pretty_changelog(changelog))
		end
		unoline.echo(summary)

		-- if the user wants to auto quit, create an autocommand to quit unoline on the update completing
		if options.auto_quit then
			vim.api.nvim_create_autocmd("User", { pattern = "AstroUpdateComplete", command = "quitall" })
		end

		-- if the user wants to reload and sync packer
		if options.auto_reload then
			-- perform a reload
			unoline.updater.reload(true) -- run quiet to not show notification on reload
			-- sync packer if it is available
			local packer_avail, packer = pcall(require, "packer")
			if packer_avail then
				-- on a successful packer sync send user event
				vim.api.nvim_create_autocmd(
					"User",
					{ pattern = "PackerComplete", command = "doautocmd User AstroUpdateComplete" }
				)
				packer.sync()
				-- if packer isn't available send successful update event
			else
				vim.cmd([[doautocmd User AstroUpdateComplete]])
			end
		else
			-- send user event of successful update
			vim.cmd([[doautocmd User AstroUpdateComplete]])
		end
	end
end
