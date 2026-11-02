obs = obslua

local timer_fired = false

function open_projector()
    if timer_fired then return end
    timer_fired = true
    obs.remove_current_callback()
    obs.blog(obs.LOG_INFO, ">>> LUA: Abrindo projetor em tela cheia no monitor 1 <<<")
    obs.obs_frontend_open_projector("Scene", 1, "", "CoopSplitScene")
    obs.obs_frontend_open_projector("Preview", 1, "", "")
end

function script_load(settings)
    obs.blog(obs.LOG_INFO, ">>> LUA: script_load iniciado <<<")
    obs.timer_add(open_projector, 2000)
end
