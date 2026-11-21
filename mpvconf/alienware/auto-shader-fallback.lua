local mp = require 'mp'

local fallback_active = false
local drop_threshold = 3       -- Quantidade de quadros perdidos para acionar o fallback
local startup_grace_sec = 2.0  -- Ignora drops iniciais nos primeiros 2s de buffering/seek
local last_reset_time = mp.get_time()
local baseline_drops = 0
local fallback_enabled = true
local current_mode = nil       -- "high_fps", "c4f32", ou "c4f16"

local shaders_c4f32 = {
    "~~/shaders/01_CfL_Prediction.glsl",
    "~~/shaders/02_ArtCNN_C4F32.glsl",
    "~~/shaders/03_SSimDownscaler.glsl"
}

local shaders_c4f16 = {
    "~~/shaders/01_CfL_Prediction.glsl",
    "~~/shaders/02_ArtCNN_C4F16.glsl",
    "~~/shaders/03_SSimDownscaler.glsl"
}

local shaders_high_fps = {
    "~~/shaders/01_CfL_Prediction.glsl"
}

local function is_high_fps()
    local container_fps = mp.get_property_number("container-fps", 24)
    local estimated_fps = mp.get_property_native("estimated-vf-fps")
    if type(estimated_fps) ~= "number" then
        estimated_fps = 24
    end
    return math.max(container_fps or 24, estimated_fps) >= 48
end

local function apply_shader_mode(mode)
    if current_mode == mode then return end
    current_mode = mode
    if mode == "high_fps" then
        mp.set_property_native("glsl-shaders", shaders_high_fps)
    elseif mode == "c4f16" then
        mp.set_property_native("glsl-shaders", shaders_c4f16)
    else
        mp.set_property_native("glsl-shaders", shaders_c4f32)
    end
end

local function reset_to_c4f32()
    fallback_active = false
    current_mode = nil
    last_reset_time = mp.get_time()
    baseline_drops = mp.get_property_number("frame-drop-count", 0)
    apply_shader_mode(is_high_fps() and "high_fps" or "c4f32")
end

-- Restaura o pipeline adequado ao carregar um novo arquivo
mp.register_event("file-loaded", reset_to_c4f32)

-- Reage imediatamente caso o FPS estimado estabilize >= 48fps apos os primeiros frames
mp.observe_property("estimated-vf-fps", "number", function(_, fps)
    if type(fps) ~= "number" then return end
    if is_high_fps() then
        if current_mode ~= "high_fps" then
            fallback_active = false
            apply_shader_mode("high_fps")
            baseline_drops = mp.get_property_number("frame-drop-count", 0)
        end
    elseif current_mode == "high_fps" then
        fallback_active = false
        last_reset_time = mp.get_time()
        baseline_drops = mp.get_property_number("frame-drop-count", 0)
        apply_shader_mode("c4f32")
    end
end)

-- Atualiza a linha de base apos seeks para nao disparar falso positivo
mp.register_event("seek", function()
    last_reset_time = mp.get_time()
    baseline_drops = mp.get_property_number("frame-drop-count", 0)
end)

-- Permite reativar manualmente o perfil neural apos uma queda ou troca manual.
mp.register_script_message("shader-fallback-reset", function()
    reset_to_c4f32()
    mp.osd_message("Auto-Fallback: qualidade restaurada", 2)
end)

mp.register_script_message("shader-fallback-toggle", function()
    fallback_enabled = not fallback_enabled
    if fallback_enabled then
        mp.osd_message("Auto-Fallback: habilitado", 2)
    else
        fallback_active = false
        mp.osd_message("Auto-Fallback: desabilitado", 2)
    end
end)

-- Monitora perda de quadros na saida a cada 0.5s
mp.add_periodic_timer(0.5, function()
    if not fallback_enabled or fallback_active then return end
    if is_high_fps() then
        baseline_drops = mp.get_property_number("frame-drop-count", 0)
        return
    end
    if (mp.get_time() - last_reset_time) < startup_grace_sec then
        baseline_drops = mp.get_property_number("frame-drop-count", 0)
        return
    end

    local current_drops = mp.get_property_number("frame-drop-count", 0)
    if (current_drops - baseline_drops) >= drop_threshold then
        fallback_active = true
        apply_shader_mode("c4f16")
        mp.osd_message("Auto-Fallback: ArtCNN C4F16 (Frame drops detected)", 3)
    end
end)