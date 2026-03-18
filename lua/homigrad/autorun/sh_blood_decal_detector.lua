if SERVER then
    blood_drops = blood_drops or {}
    
    local AREA_RADIUS = 50
    local MIN_COUNT = 3
    local GRID_SIZE = 10
    local CLEANUP_TIME = 60
    local CHECK_INTERVAL = 1.0
    
    local function get_key(pos)
        return math.Round(pos.x / GRID_SIZE) .. "," .. math.Round(pos.y / GRID_SIZE) .. "," .. math.Round(pos.z / GRID_SIZE)
    end
    
    local function count_nearby(center_pos)
        local now = CurTime()
        local count = 0
        for key, data in pairs(blood_drops) do
            if now - data.time > CLEANUP_TIME then
                blood_drops[key] = nil
            elseif center_pos:DistToSqr(data.pos) <= AREA_RADIUS ^ 2 then
                count = count + 1
            end
        end
        return count
    end
    
    hook.Add("HG_BloodParticleStartedDropping", "BloodDecalDetector", function(owner, org, wound, dir, artery)
        if not IsValid(owner) then return end
        local ent = IsValid(owner.FakeRagdoll) and owner.FakeRagdoll or owner
        local bone = ent:LookupBone(wound[4])
        if not bone then return end
        local pos, ang = ent:GetBonePosition(bone)
        if not pos then return end
        
        local trace_data = {
            start = pos,
            endpos = pos - Vector(0, 0, 1000),
            filter = ent
        }
        local tr = util.TraceLine(trace_data)
        
        if tr.HitWorld and tr.Hit then
            local hit_pos = tr.HitPos
            local key = get_key(hit_pos)
            local owner_id = owner:EntIndex()
            blood_drops[key] = blood_drops[key] or {pos = hit_pos, time = CurTime(), count = 0, detected = {}, pool_count = 0}
            blood_drops[key].count = blood_drops[key].count + 1
            blood_drops[key].pool_count = blood_drops[key].pool_count + 1
            blood_drops[key].pos = hit_pos
            blood_drops[key].time = CurTime()
            
            -- Large pool when pool_count high
            if blood_drops[key].pool_count >= 50 and not artery then
                if not blood_drops[key].detected[owner_id] then
                    blood_drops[key].detected[owner_id] = true
                    PrintMessage(HUD_PRINTTALK, "LARGE BLOOD POOL DETECTED at poça location!")
                    -- Spawn large decal exactly where detected using extra_realistic_blood_mod texture (larger scale)
                    local decal_name = "decals/gm_bloodstains_001" -- Larger one with $decalscale 0.08
                    util.Decal(decal_name, hit_pos + tr.HitNormal * 0.1, hit_pos - tr.HitNormal * 10, owner)
                end
            elseif count_nearby(hit_pos) >= MIN_COUNT then
                if not blood_drops[key].detected[owner_id] then
                    blood_drops[key].detected[owner_id] = true
                    PrintMessage(HUD_PRINTTALK, "BLOOD DECALS DETECTED: " .. count_nearby(hit_pos) .. " drops in small area!")
                end
            end
        end
    end)
    
    timer.Create("BloodDropsCleanup", CHECK_INTERVAL, 0, function()
        local now = CurTime()
        for key, data in pairs(blood_drops) do
            if now - data.time > CLEANUP_TIME then
                blood_drops[key] = nil
            end
        end
    end)
    
    concommand.Add("test_blood_drop", function(ply)
        if IsValid(ply) and not ply:IsAdmin() then return end
        local pos = (ply or Entity(1)):GetPos()
        local hit_pos = pos + Vector(0, 0, -100)
        local tr = util.TraceLine({start = hit_pos + Vector(0,0,100), endpos = hit_pos - Vector(0,0,100)})
        local key = get_key(hit_pos)
        blood_drops[key] = blood_drops[key] or {pos = hit_pos, time = CurTime(), count = 0, detected = {}, pool_count = 0}
        blood_drops[key].count = blood_drops[key].count + 1
        blood_drops[key].pool_count = blood_drops[key].pool_count + 1
        blood_drops[key].pos = hit_pos
        blood_drops[key].time = CurTime()
        local nearby_count = count_nearby(hit_pos)
        PrintMessage(HUD_PRINTTALK, "Test drop #" .. blood_drops[key].pool_count .. " nearby: " .. nearby_count)
        if ply then ply:ChatPrint("Test at poça=" .. blood_drops[key].pool_count) end
    end)
end
