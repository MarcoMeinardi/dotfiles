return {
	{
		"Eandrju/cellular-automaton.nvim",
		config = function()
			local rotate_animation = {
				name = "rotate",
				fps = 10,
				delta_th = math.pi / 30  -- Step angle
			}

			local initial_grid
			local nrows  -- #rows
			local h_nrows  -- floor(#rows / 2)
			local ncols  -- #columns
			local h_ncols  -- floor(#columns / 2)
			local th  -- Actual angle of rotation

			rotate_animation.init = function(grid)
				initial_grid = vim.deepcopy(grid)
				nrows = #initial_grid
				h_nrows = math.floor(nrows / 2)
				ncols = #initial_grid[1]
				h_ncols = math.floor(ncols / 2)
				th = 0
			end

			local round = function(x)
				return math.ceil(x + 0.5)
			end

			rotate_animation.update = function(grid)
				-- Update th
				th = th + rotate_animation.delta_th
				if th >= math.pi * 2 then
					th = th - math.pi * 2
				end
				-- Reset grid, we always rotate the initial grid
				for i=1,nrows do
					for j=1,ncols do
						grid[i][j] = { char = " " }
					end
				end

				for i=1,nrows do
					for j=1,ncols do
						-- Offset because the center is not in the upper left corner
						local y = i - h_nrows
						local x = j - h_ncols
						-- Quick maths
						local ny = round(x * math.sin(th) + y * math.cos(th))
						local nx = round(x * math.cos(th) - y * math.sin(th))
						-- Revert the offset
						local ni = ny + h_nrows
						local nj = nx + h_ncols
						if (0 < ni and ni <= nrows and 0 < nj and nj <= ncols) then
							grid[ni][nj] = initial_grid[i][j]
						end
					end
				end

				return true
			end

			require("cellular-automaton").register_animation(rotate_animation)
		end,
		keys = {
			{
				"<leader>mir",
				function() require("cellular-automaton").start_animation("make_it_rain") end
			},
			{
				"<leader>rot",
				function() require("cellular-automaton").start_animation("rotate") end
			},
			{
				"<leader>gol",
				function() require("cellular-automaton").start_animation("game_of_life") end
			}
		}
	}
}




