<<<<<<< Updated upstream
# ZCity Blood Decal Detector Task - COMPLETE

1. [x] Create zcity_blood_decal_detector.lua in lua/autorun/
2. [x] Implement damage hook for surface blood impacts
3. [x] Add timer for location checking and console print
4. [x] Test and adjust threshold. Added extra_realistic_blood_mod "blood_pool" effect + sprite on alert.
5. [x] Complete task

Run in console: lua_openscript_cl zcity_blood_decal_detector.lua (client no-op). Reload server to activate autorun.

System ready: Shoots/blood hits on same floor spot accumulate, >=20 in 64x64 grid within 30s -> "Funcionando" in server console + chat.

=======
# TTT Submodo Homicide (Variação Wild West)

## Information Gathered
- Subtipo MODE.Types.ttt em homicide/.
- Base: sv_homicide.lua (lógica principal).
>>>>>>> Stashed changes

## Steps Pendentes:
- [x] 1. Editar sv_homicide.lua ✅
- [x] 2. Editar sh_homicide.lua ✅
- [x] 3. Editar cl_homicide.lua ✅
1. [x] Test round: Force tipo "ttt" em homicide. Loadout variado (rifles/SMGs/shotguns + traitor tools). ✅


Progresso será atualizado após cada step.
