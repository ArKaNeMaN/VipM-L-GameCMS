#include <amxmodx>
#include <VipModular>
#include <gamecms5>

#if !defined GCMS_GROUP_NAME_MAX_LEN
    #define GCMS_GROUP_NAME_MAX_LEN (MAX_NAME_LENGTH * 2)
#endif

#if !defined GCMS_SERVICE_NAME_MAX_LEN
    #define GCMS_SERVICE_NAME_MAX_LEN (MAX_STRING_LEN * 2)
#endif

#pragma semicolon 1
#pragma compress 1

public stock const PluginName[] = "[VipM-L] GameCMS";
public stock const PluginVersion[] = _VIPM_VERSION;
public stock const PluginAuthor[] = "ArKaNeMaN";
public stock const PluginURL[] = "t.me/arkanaplugins";
public stock const PluginDescription[] = "[VipModular-Limit] Integration with GameCMS API";

public VipM_OnInitModules() {
    register_plugin(PluginName, PluginVersion, PluginAuthor);

    VipM_Limits_RegisterType("GCMS-Service", true, false);
    VipM_Limits_AddTypeParams("GCMS-Service",
        "Service", ptString, true
    );
    VipM_Limits_RegisterTypeEvent("GCMS-Service", Limit_OnCheck, "@OnServiceCheck");

    VipM_Limits_RegisterType("GCMS-Member", false, false);
    VipM_Limits_AddTypeParams("GCMS-Member",
        "GroupName", ptString, false
    );
    VipM_Limits_RegisterTypeEvent("GCMS-Member", Limit_OnCheck, "@OnMemberCheck");
}

@OnMemberCheck(const Trie:Params, const UserId) {
    new sUserGroupName[GCMS_GROUP_NAME_MAX_LEN];
    new iGroupId = cmsapi_get_user_group(UserId, sUserGroupName, charsmax(sUserGroupName));
    if (!iGroupId) {
        return false;
    }

    new sGroupName[GCMS_GROUP_NAME_MAX_LEN];
    VipM_Params_GetStr(Params, "GroupName", sGroupName, charsmax(sGroupName));
    if (!sGroupName[0]) {
        return true;
    }

    return equali(sUserGroupName, sGroupName);
}

@OnServiceCheck(const Trie:Params, const UserId) {
    new sServiceName[GCMS_SERVICE_NAME_MAX_LEN];
    VipM_Params_GetStr(Params, "Service", sServiceName, charsmax(sServiceName));

    return cmsapi_service_timeleft(UserId, .srvName=sServiceName, .part=false) > TIME_TRACKING_STOPPED;
}
