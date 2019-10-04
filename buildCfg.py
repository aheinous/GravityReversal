import os
import subprocess
import shutil
import re
import sys
import configparser
import io
import zipfile
import glob


gamedir = 'gravityReversal'
enginedir = 'godotengine'
enginepath = 'godotengine/bin/godot.x11.opt.tools.64'
projectCfgPath = gamedir + '/project.godot'
exportPresetsPath = gamedir + '/export_presets.cfg'


def _runCmd(args, directory='.'):
    subprocess.run(args, cwd=directory, check=True)


def _buildEngine():
    _runCmd(['scons', '-j', '8', 'platform=x11', 'target=release_debug'], directory=enginedir)


def _writeCfg_AndroidARM32(vname, code):
    projectCfg = _readGodotCfg(projectCfgPath)
    exportPresets = _readGodotCfg(exportPresetsPath)

    projectCfg['rendering']['quality/driver/driver_name'] = '"GLES3"'

    exportPresets['preset.0.options']['version/name'] = '"' + vname + '"'
    exportPresets['preset.0.options']['version/code'] = str(code)
    exportPresets['preset.0.options']['architectures/armeabi-v7a'] = 'true'
    exportPresets['preset.0.options']['architectures/arm64-v8a'] = 'false'

    _writeGodotCfg(projectCfgPath, projectCfg)
    _writeGodotCfg(exportPresetsPath, exportPresets)


def _writeCfg_AndroidARM64(vname, code):
    projectCfg = _readGodotCfg(projectCfgPath)
    exportPresets = _readGodotCfg(exportPresetsPath)

    projectCfg['rendering']['quality/driver/driver_name'] = '"GLES3"'

    exportPresets['preset.0.options']['version/name'] = '"' + vname + '"'
    exportPresets['preset.0.options']['version/code'] = str(code)
    exportPresets['preset.0.options']['architectures/armeabi-v7a'] = 'false'
    exportPresets['preset.0.options']['architectures/arm64-v8a'] = 'true'

    _writeGodotCfg(projectCfgPath, projectCfg)
    _writeGodotCfg(exportPresetsPath, exportPresets)

def _writeCfg_HTML5(vname):
    projectCfg = _readGodotCfg(projectCfgPath)
    exportPresets = _readGodotCfg(exportPresetsPath)

    projectCfg['rendering']['quality/driver/driver_name'] = '"GLES2"'

    _writeGodotCfg(projectCfgPath, projectCfg)
    _writeGodotCfg(exportPresetsPath, exportPresets)


def _actualBuild(cfg, path):
    if cfg == "HTML5":
        outdir = os.path.dirname(path)
        outfile = os.path.basename(path)
        startdir = os.getcwd()
        _runCmd([enginepath, '--debug', '--editor', gamedir + '/project.godot', '--export', cfg, outdir+'/index.html'])
        os.chdir(outdir)
        zf = zipfile.ZipFile(outfile, 'w')
        for fname in glob.glob('index.*'):
            zf.write(fname)


        zf.close()
        os.chdir(startdir)

    else:
        _runCmd([enginepath, '--debug', '--editor', gamedir + '/project.godot', '--export', cfg, 'tmp.apk'])
        # this move worksaround a godot bug with certain output paths
        shutil.move(gamedir + '/tmp.apk', path)


def _getVars(tag, path):
    var = {}
    m = re.match('(v\d+(\.\d+)*)_(\d+)', tag)
    var['vname'] = m.group(1)
    var['androidCode'] = int(m.group(3))
    var['apk32_path'] = '{path}/Android/gravityReversal_{name}_{code}_arm32.apk'.format(
                    path=path, name=var['vname'], code=var['androidCode'])
    var['apk64_path'] = '{path}/Android/gravityReversal_{name}_{code}_arm64.apk'.format(
                    path=path, name=var['vname'], code=var['androidCode'])
    var['html5_path'] = '{path}/HTML5/gravityReversal_{name}_HTML5/gravityReversal_{name}_web.zip'.format(
                    path=path, name=var['vname'])
    return var


def _readGodotCfg(path):
    with open(path, 'r') as f:
        s = '[_dummy_section_]\n'
        for ln in f.readlines():
            if ln.startswith('}'):
                s += '\t'
            s += ln

        parser = configparser.ConfigParser()
        parser.optionxform = lambda option : option
        parser.read_string(s)
        return parser


def _writeGodotCfg(path, parser):
    with io.StringIO() as strbuff, open(path, 'w') as f:
        parser.write(strbuff)
        for ln in strbuff.getvalue().splitlines():
            if ln.find('[_dummy_section_]') == -1:
                f.write(ln+"\n")


def alreadyBuilt(tag, path):
    field = _getVars(tag, path)
    for output in (field['apk32_path'], field['apk64_path']):
        if not os.path.isfile(output):
            return False
    return True


def build(tag, path):
    field = _getVars(tag, path)

    os.makedirs(os.path.dirname(field['apk32_path']), exist_ok=True)
    os.makedirs(os.path.dirname(field['apk64_path']), exist_ok=True)
    os.makedirs(os.path.dirname(field['html5_path']), exist_ok=True)

    _buildEngine()

    _writeCfg_AndroidARM32(field['vname'], field['androidCode'])
    _actualBuild("Android", field['apk32_path'])

    _writeCfg_AndroidARM64(field['vname'], field['androidCode'])
    _actualBuild("Android", field['apk64_path'])

    _writeCfg_HTML5(field['vname'])
    _actualBuild("HTML5", field['html5_path'])


if __name__ == '__main__':
    build('v123.456_789', '/home/alex/buildtest')
