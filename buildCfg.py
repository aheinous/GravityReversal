import os
import subprocess
import shutil
import re
import sys


gamedir = 'gravityReversal'
enginedir = 'godotengine'
enginepath = 'godotengine/bin/godot.x11.opt.tools.64'


def _runCmd(args, directory='.'):
    subprocess.run(args, cwd=directory, check=True)


def _buildEngine():
    _runCmd(['scons', '-j', '8', 'platform=x11', 'target=release_debug'], directory=enginedir)



def _writeExportPresets_AndroidARM32(vname, code):
    with open('export_presets.cfg.pytemplate', 'r') as template, \
            open( gamedir + '/export_presets.cfg', 'w') as cfgfile:
        cfgfile.write(''.join(template.readlines()).format(
                name=vname, code=(code*10), enableArm32='true', enableArm64='false'))




def _writeExportPresets_AndroidARM64(vname, code):
    with open('export_presets.cfg.pytemplate', 'r') as template, \
            open( gamedir + '/export_presets.cfg', 'w') as cfgfile:
        cfgfile.write(''.join(template.readlines()).format(
                name=vname, code=(code*10+1), enableArm32='false', enableArm64='true'))



def _actualBuild(cfg, path):
    _runCmd([enginepath, '--debug', '--editor', gamedir + '/project.godot', '--export', cfg, 'tmp.apk'])
    # this move worksaround a godot bug with certain output paths
    shutil.move(gamedir + '/tmp.apk', path)


def _getFields(tag, path):
    field = {}
    m = re.match('(v\d+(\.\d+)*)_(\d+)', tag)
    field['vname'] = m.group(1)
    field['androidCode'] = int(m.group(3))
    field['apk32_path'] = '{path}/Android/gravityReversal_{name}_{code}_arm32.apk'.format(
                    path=path, name=field['vname'], code=field['androidCode'])
    field['apk64_path'] = '{path}/Android/gravityReversal_{name}_{code}_arm64.apk'.format(
                    path=path, name=field['vname'], code=field['androidCode'])
    return field


def alreadyBuilt(tag, path):
    field = _getFields(tag, path)
    for output in (field['apk32_path'], field['apk64_path']):
        if not os.path.isfile(output):
            return False
    return True

def build(tag, path):
    field = _getFields(tag, path)

    os.makedirs(os.path.dirname(field['apk32_path']), exist_ok=True)
    os.makedirs(os.path.dirname(field['apk64_path']), exist_ok=True)


    _buildEngine()

    _writeExportPresets_AndroidARM32(field['vname'], field['androidCode'])
    _actualBuild("Android", field['apk32_path'])

    _writeExportPresets_AndroidARM64(field['vname'], field['androidCode'])
    _actualBuild("Android", field['apk64_path'])




