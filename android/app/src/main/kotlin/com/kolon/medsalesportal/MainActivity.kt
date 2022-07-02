package com.kolon.medsalesportal
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugins.GeneratedPluginRegistrant
import com.kolon.ssolib.utils.SSOUtils

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor, "mKolon.sso.channel")
        channel.setMethodCallHandler(handler)
    }

    private val handler =
        MethodCallHandler { methodCall: MethodCall, result: MethodChannel.Result ->
            if (methodCall.method == "getSsoByAndroid") {
                val  userId = SSOUtils.getKolonProviderValue(getBaseContext(), "ID", "",
                    methodCall.arguments as String?).replace("&eq;", "=").replace("&pi;", "|")
                    .replace("&sq;", "^").replace("&ps;", "%");
                val  password = SSOUtils.getKolonProviderValue(getBaseContext(), "PW", "",
                    methodCall.arguments as String?).replace("&eq;", "=").replace("&pi;", "|")
                    .replace("&sq;", "^").replace("&ps;", "%");

                if (!userId.equals("")&&!password.equals("")){
                    val resultMap: MutableMap<String, Any> = mutableMapOf<String, Any>()
                    resultMap.put("isLogedinOtherApps" , true)
                    resultMap.put("userAccount",userId)
                    resultMap.put("password",password)
                    result.success(resultMap)
                }else{
                    val resultMap: MutableMap<String, Any> = mutableMapOf<String, Any>()
                    resultMap.put("isLogedinOtherApps" , false)
                    result.success(resultMap)
                }

            } else if(methodCall.method == "saveIdOnly"){
                val arguments =  methodCall.arguments as  HashMap<String, String>;
                SSOUtils.putKolonProviderValue(getBaseContext(),"ID",arguments.get("userAccount"), arguments.get("type") );
                result.success("success")
            }
            else if(methodCall.method == "getIdOnly"){
                val  userId = SSOUtils.getKolonProviderValue(getBaseContext(), "ID", "",
                    methodCall.arguments as String?).replace("&eq;", "=").replace("&pi;", "|")
                    .replace("&sq;", "^").replace("&ps;", "%");
                result.success(userId)
            }
            else if(methodCall.method == "findKolonApps"){
                val type =  methodCall.arguments as String;
                val isFindKolonApps = SSOUtils.findKolonApps(getBaseContext(),type)
                val isFindIkenApp = SSOUtils.findIkenApp(getBaseContext(),type)
                val isFindIkenMail = SSOUtils.findKolonMail(getBaseContext(),type)
                val isFindKolonTalk = SSOUtils.findKolonTalk(getBaseContext(),type)
                val isFindKolonSign = SSOUtils.findKolonSign(getBaseContext(),type)
                val isFindOneHR = SSOUtils.findKolonOneHR(getBaseContext(),type)
                var installed = isFindKolonApps||isFindIkenApp||isFindIkenMail||isFindKolonTalk||isFindKolonSign||isFindOneHR;
                if (installed)
                    result.success("success")
                else
                    result.success("notFind")
            }

            else if(methodCall.method == "isSaveId") {
                val  isSaveId = SSOUtils.getKolonProviderValue(getBaseContext(), "SAVEID", "",
                    methodCall.arguments as String?).replace("&eq;", "=").replace("&pi;", "|")
                    .replace("&sq;", "^").replace("&ps;", "%");
                result.success(isSaveId)
            }
            else if(methodCall.method == "isAutoLogin") {
                val  isAutoLogin = SSOUtils.getKolonProviderValue(getBaseContext(), "AUTOLOGIN", "",
                    methodCall.arguments as String?).replace("&eq;", "=").replace("&pi;", "|")
                    .replace("&sq;", "^").replace("&ps;", "%");
                result.success(isAutoLogin)
            } else if(methodCall.method == "setIsSaveId") {
              
                val arguments =  methodCall.arguments as  HashMap<String, String>;
                SSOUtils.putKolonProviderValue(getBaseContext(),"SAVEID",arguments.get("isSaveId"), arguments.get("type") );
                result.success("success")
            } else if(methodCall.method == "saveAutoLogin") {
               
                val arguments =  methodCall.arguments as  HashMap<String, String>;
                SSOUtils.putKolonProviderValue(getBaseContext(),"AUTOLOGIN",arguments.get("isAutoLogin"), arguments.get("type") );
                result.success("success")
            }
            else if(methodCall.method == "userAgent") {
               result.success(System.getProperty("http.agent"))
            }  else if(methodCall.method == "saveIdAndPasswordToAndroidSSO") {
               
                val arguments =  methodCall.arguments as  HashMap<String, String>;
                SSOUtils.putKolonProviderValue(getBaseContext(),"ID",arguments.get("userAccount"), arguments.get("type") );
                SSOUtils.putKolonProviderValue(getBaseContext(),"PW",arguments.get("password"), arguments.get("type") );
                result.success("success")
            } else  {
                result.notImplemented()
            }
        }
}
