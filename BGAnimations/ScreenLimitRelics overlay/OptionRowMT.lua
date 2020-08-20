local args = ...
local NumRows = args.NumRows
local player = args.Player
local AllItems = args.Items
local RowHeight = args.RowHeight

-- the metatable for a single option in any given OptionRow
local OptionRow_mt = {
	__index = {
		create_actors = function(self, name)
			self.name=name

			local af = Def.ActorFrame{
				Name=self.name,
				InitCommand=function(subself)
					self.container = subself
					subself:diffusealpha(0)
				end,
				OnCommand=function(subself)
					subself:y(RowHeight * self.index + 2)
						:sleep(0.04 * self.index)
						:linear(0.2):diffusealpha(self.index==1 and 1 or 0.65)
				end,
				OffCommand=function(subself)
					subself:sleep(0.04 * self.index)
						:linear(0.2):diffusealpha(0)
				end,
				LoseFocusCommand=function(subself) subself:diffusealpha(0.65) end,
				GainFocusCommand=function(subself) subself:diffusealpha(1) end,
			}

			af[#af+1] = Def.Quad{
				InitCommand=function(subself)
					self.BGQuad = subself
					subself:diffuse(color("#666666"))
					if ThemePrefs.Get("RainbowMode") then
						subself:diffuse(color("#222222"))
					end

					subself:zoomto(340, RowHeight-2):x(0)
				end,

			}

			af[#af+1] = Def.Quad{
				InitCommand=function(subself)
					self.TitleQuad = subself
					subself:diffuse(color("#111111"))
					subself:zoomto(70, RowHeight-2):x(-135)
				end,
				GainFocusCommand=function(subself) subself:diffuse( GetCurrentColor() ) end,
				LoseFocusCommand=function(subself) subself:diffuse( color("#111111") ) end
			}

			-- row title
			af[#af+1] = Def.BitmapText{
				Font="Common normal",
				InitCommand=function(subself)
					self.bmt = subself
					subself:x(-135)
				end,
			}

			-- cursor underline thing
			af[#af+1] = Def.Quad{
				InitCommand=function(subself)
					subself:zoomto(60,4):visible(true):xy(19, 25)
						:diffuse( GetCurrentColor() )
					self.underline = subself
				end,
				GainFocusCommand=function(subself)
					if self.index < NumRows then subself:visible(true) end
				end,
				LoseFocusCommand=function(subself) subself:visible(false) end,
			}

			return af
		end,


		transform = function(self, item_index, num_items, has_focus)
			self.container:finishtweening()
			self.container:linear(0.2)

			if has_focus then
				self.container:playcommand("GainFocus")
			else
				self.container:playcommand("LoseFocus")
			end
		end,


		set = function(self, optionrow)
			if not optionrow then return end
			self.optionrow = optionrow
			self.index = FindInTable( optionrow, AllItems ) or 1
			local text = THEME:GetString( "OptionTitles", optionrow )
			self.bmt:settext(text)
		end
	}
}

return OptionRow_mt