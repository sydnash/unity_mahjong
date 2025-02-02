#!/usr/bin/sh python
#-*- coding:utf-8 -*-

#./autobuild.py -p youproject.xcodeproj -s schemename
#./autobuild.py -w youproject.xcworkspace -s schemename

import argparse
import subprocess
#import requests
import os

#configuration for iOS build setting
CONFIGURATION = "Release"
EXPORT_OPTIONS_PLIST = "develop.plist"
#会在桌面创建输出ipa文件的目录
EXPORT_MAIN_DIRECTORY = "~/Documents/"

def cleanArchiveFile(archiveFile):
	cleanCmd = "rm -r %s" %(archiveFile)
	process = subprocess.Popen(cleanCmd, shell = True)
	process.wait()
	print "cleaned archiveFile: %s" %(archiveFile)


def parserUploadResult(jsonResult):
	resultCode = jsonResult['code']
	if resultCode == 0:
		downUrl = DOWNLOAD_BASE_URL +"/"+jsonResult['data']['appShortcutUrl']
		print "Upload Success"
		print "DownUrl is:" + downUrl
	else:
		print "Upload Fail!"
		print "Reason:"+jsonResult['message']

#def uploadIpaToPgyer(ipaPath):
#	print "ipaPath:"+ipaPath
#	ipaPath = os.path.expanduser(ipaPath)
#	files = {'file': open(ipaPath, 'rb')}
#	headers = {'enctype':'multipart/form-data'}
#	payload = {'uKey':USER_KEY,'_api_key':API_KEY,'publishRange':'2','isPublishToPublic':'2', 'password':PYGER_PASSWORD}
#	print "uploading...."
#	r = requests.post(PGYER_UPLOAD_URL, data = payload ,files=files,headers=headers)
#	if r.status_code == requests.codes.ok:
#		result = r.json()
#		parserUploadResult(result)
#	else:
#		print 'HTTPError,Code:'+r.status_code

#创建输出ipa文件路径: ~/Desktop/{scheme}{2016-12-28_08-08-10}
def buildExportDirectory(scheme):
	dateCmd = 'date "+%Y-%m-%d_%H-%M-%S"'
	process = subprocess.Popen(dateCmd, stdout=subprocess.PIPE, shell=True)
	(stdoutdata, stderrdata) = process.communicate()
	exportDirectory = "%s%s%s" %(EXPORT_MAIN_DIRECTORY, scheme, stdoutdata.strip())
	return exportDirectory

def buildArchivePath(tempName):
	process = subprocess.Popen("pwd", stdout=subprocess.PIPE)
	(stdoutdata, stderrdata) = process.communicate()
	archiveName = "%s.xcarchive" %(tempName)
	archivePath = stdoutdata.strip() + '/' + archiveName
	return archivePath

def getIpaPath(exportPath):
	cmd = "ls %s" %(exportPath)
	process = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
	(stdoutdata, stderrdata) = process.communicate()
	ipaName = stdoutdata.strip()
	ipaPath = exportPath + "/" + ipaName
	return ipaPath

def exportArchive(scheme, archivePath, plist):
	exportDirectory = buildExportDirectory(scheme)
	exportCmd = "xcodebuild -exportArchive -archivePath %s -exportPath %s -exportOptionsPlist %s" %(archivePath, exportDirectory, plist)#EXPORT_OPTIONS_PLIST)
	process = subprocess.Popen(exportCmd, shell=True)
	(stdoutdata, stderrdata) = process.communicate()

	signReturnCode = process.returncode
	if signReturnCode != 0:
		print "export %s failed" %(scheme)
	 	return ""
	else:
		return exportDirectory

def buildProject(project, scheme, plist, conf):
	archivePath = buildArchivePath(scheme)
	print "archivePath: " + archivePath
	archiveCmd = 'xcodebuild -project %s -scheme %s -configuration %s archive -archivePath %s -destination generic/platform=iOS' %(project, scheme, conf, archivePath)
	#archiveCmd = 'xcodebuild -project %s -scheme %s -configuration %s archive -archivePath %s -destination generic/platform=iOS' %(project, scheme, CONFIGURATION, archivePath)
	process = subprocess.Popen(archiveCmd, shell=True)
	process.wait()

	archiveReturnCode = process.returncode
	if archiveReturnCode != 0:
		print "archive project %s failed" %(project)
		cleanArchiveFile(archivePath)
	else:
		exportDirectory = exportArchive(scheme, archivePath, plist)
		cleanArchiveFile(archivePath)
#if exportDirectory != "":		
#			ipaPath = getIpaPath(exportDirectory)
#			uploadIpaToPgyer(ipaPath)

def buildWorkspace(workspace, scheme, plist, conf):
	archivePath = buildArchivePath(scheme)
	print "archivePath: " + archivePath
	archiveCmd = 'xcodebuild -workspace %s -scheme %s -configuration %s archive -archivePath %s -destination generic/platform=iOS' %(workspace, scheme, conf, archivePath)
	#archiveCmd = 'xcodebuild -workspace %s -scheme %s -configuration %s archive -archivePath %s -destination generic/platform=iOS' %(workspace, scheme, CONFIGURATION, archivePath)
	process = subprocess.Popen(archiveCmd, shell=True)
	process.wait()

	archiveReturnCode = process.returncode
	if archiveReturnCode != 0:
		print "archive workspace %s failed" %(workspace)
		cleanArchiveFile(archivePath)
	else:
		exportDirectory = exportArchive(scheme, archivePath, plist)
		cleanArchiveFile(archivePath)
#if exportDirectory != "":		
#	ipaPath = getIpaPath(exportDirectory)
#			uploadIpaToPgyer(ipaPath)

def xcbuild(options):
	project = options.project
	workspace = options.workspace
	scheme = options.scheme
	plist = options.archieve
        conf = options.configure

        if conf is not None:
            CONFIGURATION = conf

	if project is None and workspace is None:
		pass
	elif project is not None:
		buildProject(project, scheme, plist, conf)
	elif workspace is not None:
		buildWorkspace(workspace, scheme, plist, conf)

def renameDir(o, n):
	cleanCmd = "mv %s %s" %(o, n)
	process = subprocess.Popen(cleanCmd, shell = True)
	process.wait()
	
def main():
	parser = argparse.ArgumentParser()
	parser.add_argument("-w", "--workspace", help="Build the workspace name.xcworkspace.", metavar="name.xcworkspace")
	parser.add_argument("-p", "--project", help="Build the project name.xcodeproj.", metavar="name.xcodeproj")
	parser.add_argument("-s", "--scheme", help="Build the scheme specified by schemename. Required if building a workspace.", metavar="schemename")
	parser.add_argument("-a", "--archieve", help="set the exportOptionsPlist path", metavar="develop.plist")
        parser.add_argument("-c", "--configure", help="set compile Release or Debug", metavar = "Release Debug")

	options = parser.parse_args()

	print "options: %s" % (options)

	#renameDir('src', 'src_bk')
	#renameDir('src_en', 'src')
	#renameDir('res', 'res_bk')
	#renameDir('res_en', 'res')
	try:
		xcbuild(options)
	except:
		print "failed"
	finally:
                print "final"
		#renameDir('src', 'src_en')
		#renameDir('src_bk', 'src')
		#renameDir('res', 'res_en')
		#renameDir('res_bk', 'res')

if __name__ == '__main__':
	main()
