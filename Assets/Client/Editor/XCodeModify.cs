using System;

using UnityEngine;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.Build;
#if UNITY_IPHONE
using UnityEditor.iOS.Xcode;
#endif
using System.Collections;
using System.Collections.Generic;
using System.IO;

public class XCodeModify
{
	public XCodeModify ()
	{
	}
		
	[PostProcessBuild(1)]
	public static void OnPostprocessBuild(BuildTarget bildTarget, string path) {
#if UNITY_IPHONE
		// 修改xcode工程
		string projPath = PBXProject.GetPBXProjectPath(path);
		PBXProject proj = new PBXProject();
		proj.ReadFromString(File.ReadAllText(projPath));
		string target = proj.TargetGuidByName("Unity-iPhone");

		string manualAddIOSFileDir = Application.dataPath.Replace("Assets", "ManualAddIOSFile");

		try {
			string filepath = Path.Combine(manualAddIOSFileDir, "OpenUDID.m");
			string projpath = Path.Combine(path, "Libraries/Plugins/iOS/utils/OpenUDID.m");
			File.Copy(filepath, projpath);
			string fileguid = proj.AddFile("Libraries/Plugins/iOS/utils/OpenUDID.m", "Libraries/Plugins/iOS/utils/OpenUDID.m", PBXSourceTree.Source);
			proj.AddFileToBuildWithFlags(target, fileguid, "-fno-objc-arc");

			filepath = Path.Combine(manualAddIOSFileDir, "GTMBase64.m");
			projpath = Path.Combine(path, "Libraries/Plugins/iOS/utils/GTMBase64.m");
			File.Copy(filepath, projpath);
			fileguid = proj.AddFile("Libraries/Plugins/iOS/utils/GTMBase64.m", "Libraries/Plugins/iOS/utils/GTMBase64.m", PBXSourceTree.Source);
			proj.AddFileToBuildWithFlags(target, fileguid, "-fno-objc-arc");
		} catch(Exception e) {
		}

		//添加xcode默认framework引用
		proj.AddFrameworkToProject(target, "libz.tbd", false);
		proj.AddFrameworkToProject(target, "libsqlite3.0.tbd", false);
		proj.AddFrameworkToProject(target, "libc++.tbd", false);
		proj.AddFrameworkToProject(target, "libstdc++.6.0.9.tbd", false);
		proj.AddFrameworkToProject(target, "Security.framework", false);
		proj.AddFrameworkToProject(target, "CoreTelephony.framework", false);
		proj.AddFrameworkToProject(target, "CoreAudio.framework", false);
		proj.AddFrameworkToProject(target, "SystemConfiguration.framework", false);
		proj.AddFrameworkToProject(target, "CoreLocation.framework", false);
		proj.AddFrameworkToProject(target, "AudioToolbox.framework", false);
		proj.AddFrameworkToProject(target, "AVFoundation.framework", false);

		//File.Delete(Path.Combine(path, "Classes/UnityAppController.h"));
		File.Delete(Path.Combine(path, "Classes/UnityAppController.mm"));
		//File.Copy(Application.dataPath.Replace("Assets", "iOS/UnityAppController.h"), Path.Combine(path, "Classes/UnityAppController.h"));
		File.Copy(Application.dataPath.Replace("Assets", "modifyForIOS/UnityAppController.mm"), Path.Combine(path, "Classes/UnityAppController.mm"));
		//File.Move(Path.Combine(path, "Libraries/Plugins/OpenSDK1.8.1/libWeChatSDK.a"), Path.Combine(path, "Classes/libWeChatSDK.a"));

		proj.UpdateBuildProperty(target, "OTHER_LDFLAGS", new List<string>() { "-Objc", "-all_load" }, new List<string>() { "-Objc" });
		//proj.SetBuildProperty(target, "IPHONEOS_DEPLOYMENT_TARGET", "8.0");
		proj.SetBuildProperty(target, "ENABLE_BITCODE", "NO");

	
		string debugConfig = proj.BuildConfigByName(target, "Debug");
		string releaseConfig = proj.BuildConfigByName(target, "Release");
		//1207                 CODE_SIGN_STYLE = Manual;
		proj.SetBuildProperty(target, "CODE_SIGN_STYLE", "Manual");
													 
		proj.SetBuildPropertyForConfig(debugConfig, "PROVISIONING_PROFILE_SPECIFIER", "mj_development");
		proj.SetBuildPropertyForConfig(releaseConfig, "PROVISIONING_PROFILE", "mj_distribution");
		proj.SetBuildPropertyForConfig(debugConfig, "CODE_SIGN_IDENTITY", "iPhone Developer: jun dai (U493TM8SDC)");
		proj.SetBuildPropertyForConfig(releaseConfig, "CODE_SIGN_IDENTITY", "iPhone Distribution: jun dai (ECJJEKLSES)");

		proj.SetTeamId(target, "ECJJEKLSES");
		proj.WriteToFile(projPath);

		//获取info.plist
		string plistPath = path + "/Info.plist";
		PlistDocument plist = new PlistDocument();
		plist.ReadFromString(File.ReadAllText(plistPath));
		PlistElementDict rootDict = plist.root;

		AddUrlType(rootDict, "Editor", "weixin", "wx2ca58653c3f50625");
		AddUrlType(rootDict, "Editor", "xianliao", "xianliaoMVGhscFdSy3OO7KG");

		/*<key>NSLocationAlwaysUsageDescription</key>
		<string>开启定位，防止作弊打牌</string>
		<key>NSLocationUsageDescription</key>
		<string>开启定位，防止作弊打牌</string>
		<key>NSLocationWhenInUseUsageDescription</key>
		<string>开启定位，防止作弊打牌</string>
		<key>NSMicrophoneUsageDescription</key>
		<string>开启麦克风进行语音聊天</string>*/
		rootDict.SetString("NSLocationAlwaysUsageDescription", "开启定位，防止作弊打牌");
		rootDict.SetString("NSLocationUsageDescription", "开启定位，防止作弊打牌");
		rootDict.SetString("NSLocationWhenInUseUsageDescription", "开启定位，防止作弊打牌");
		rootDict.SetString("NSMicrophoneUsageDescription", "开启麦克风进行语音聊天");


		//这个在addurltype里面已经被添加了
		//AddKeyArray(rootDict, "LSApplicationQueriesSchemes", "weixin");

		plist.WriteToFile(plistPath);
#endif
	}

#if UNITY_IPHONE
	private static void AddKeyArray(PlistElementDict dict, string key, string value)
	{
		PlistElementArray array;
		if (dict.values.ContainsKey (key)) {
			array = dict [key].AsArray ();
		} else {
			array = dict.CreateArray (key);
		}
		array.AddString (value);
	}
	private static void AddUrlType(PlistElementDict dict, string role, string name, string scheme)
	{
		//添加URLTypes
		PlistElementArray URLTypes;
		if (dict.values.ContainsKey("CFBundleURLTypes"))
			URLTypes = dict["CFBundleURLTypes"].AsArray();
		else
			URLTypes = dict.CreateArray("CFBundleURLTypes");

		PlistElementDict elementDict = new PlistElementDict();
		elementDict.SetString("CFBundleTypeRole", role);
		elementDict.SetString("CFBundleURLName", name);
		elementDict.CreateArray("CFBundleURLSchemes").AddString(scheme);

		URLTypes.values.Add(elementDict);

		//添加LSApplicationQueriesSchemes
		PlistElementArray schemes;
		if (dict.values.ContainsKey("LSApplicationQueriesSchemes"))
			schemes = dict["LSApplicationQueriesSchemes"].AsArray();
		else
			schemes = dict.CreateArray("LSApplicationQueriesSchemes");
		schemes.AddString(name);
	}
#endif

}

