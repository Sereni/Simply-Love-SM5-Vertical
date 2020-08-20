local args = ...
local NumRows = args.NumRows
local player = args.Player
local Row = args.Row

-- the metatable for an optionrow choice
local optionrow_choice_mt = {
	__index = {
		create_actors = function(self, name)
			self.name=name

			local af = Def.ActorFrame{
				Name=self.name,
				InitCommand=function(subself)
					self.container = subself
				end,
				OffCommand=function(subself)
					subself:linear(0.2):diffusealpha(0)
				end,
			}

			af[#af+1] = Def.BitmapText{
				Font="Common normal",
				InitCommand=function(subself)
					self.bmt = subself

					subself:diffuse(Color.White)
					subself:y(10):zoom(0.8)
					subself:wrapwidthpixels(85)
				end,
			}

			return af
		end,

		transform = function(self, item_index, num_items, has_focus)
			self.container:finishtweening()
			self.container:linear(0.2)
			self.index=item_index

			local OffsetFromCenter = (item_index - math.floor(num_items/2))-1
			local x_padding = 80
			local x = x_padding * OffsetFromCenter

			if item_index <= 1 or item_index >= num_items then
				self.container:diffusealpha(0)
			else
				if has_focus then
					self.container:diffuse( Color.White ):diffusealpha(1)
					self.bmt:diffuse( Color.White )
				else
					self.container:diffuse( color("#888888") ):diffusealpha(1)
					self.bmt:diffuse( Color.White )
				end
			end

			self.container:x(x)
			self.bmt:settext( self.relic.name )

		end,

		set = function(self, relic)
			if not relic then return end
			self.relic = relic
		end
	}
}

return optionrow_choice_mt