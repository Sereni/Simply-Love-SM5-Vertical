local af = Def.ActorFrame{}

-- -----------------------------------------------------------------------
-- verify certain settings/configurations are compatible with Simply Love
--    render-to-texture is needed for Simply Thonk but not possible with the d3d renderer
--    some StepMania game types (popn, beat, kickbox, etc.) are not supported in SL
--    SL only supports official StepMania releases, and a limited range of versions at that
af[#af+1] = LoadActor("./Support.lua")
-- -----------------------------------------------------------------------

return af
