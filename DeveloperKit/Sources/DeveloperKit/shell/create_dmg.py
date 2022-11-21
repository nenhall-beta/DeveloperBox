# 这是一个示例 Python 脚本。

# 按 ⌃R 执行或将其替换为您的代码。
# 按 双击 ⇧ 在所有地方搜索类、文件、工具窗口、操作和设置。
import os
import sys
import time

dmg_name = "AirBrushStudio%s.dmg"


def printHelp():
    print("")
    print("--------------------------help--------------------------")
    print("-t output     输出路径（可选参数）")
    print("-i input      app/pkg 文件路径")
    print("-t template   DMG 模版文件路径（eg.: app.dmgCanvas）")
    print("-h help       帮助")
    print("--------------------------------------------------------")
    print("")


# 生成导出路径
def makeDestination_path_from(path):
    root_dir = os.path.dirname(path)
    full_name = os.path.basename(path)
    file_name = os.path.splitext(full_name)[0]
    des_path = root_dir + "/" + file_name + ".dmg"
    if os.path.exists(des_path):
        now = time.localtime(time.time())
        time_strimg = time.strftime("-%H-%M-%S", now)
        des_path = root_dir + "/" + file_name + time_strimg + ".dmg"
    return des_path


def copy_dmg_command():
    path = "/usr/local/bin/dmgcanvas"
    if os.path.exists(path):
        return
    result = os.system('sudo -S ln -s "/Applications/DMG Canvas.app/Contents/Resources/dmgcanvas" /usr/local/bin/')
    print("dmg 快捷命令已创建：", "成功" if result == 0 else "失败")


def create_dmg_from(app, template, des):
    print("")
    print("❤️❤️❤️❤️❤️❤️❤️❤️❤️  开始生成 dmg 安装包 ❤️❤️❤️❤️❤️❤️❤️❤️❤️")
    print("")
    cmd = '/usr/local/bin/dmgcanvas \"%s\" \"%s\"' % (template, des)
    cmd = '/usr/local/bin/dmgcanvas \"%s\" \"%s\" -setFilePath \"AirBrush Studio.app\" \"%s\"' % (template, des, app)

    result = os.system(cmd)
    print("dmg 安装包生成结束：", "✅" if result == 0 else "❌", cmd)
    sys.exit(1)
    

if __name__ == '__main__':
    output_path = ""
    app_path = ""
    template_path = ""

    for index, item in enumerate(sys.argv[1:]):
        if (item.startswith("-output")) | (item.startswith("-o")):
            output_path = sys.argv[index+2]
        elif (item.startswith("-input")) | (item.startswith("-i")):
            app_path = sys.argv[index+2]
        elif (item.startswith("-template")) | (item.startswith("-t")):
            template_path = sys.argv[index+2]
        elif (item == "--help") | (item == "-h"):
            printHelp()
            sys.exit(1)

    if template_path == "":
        print("⚠️  模版路径不能为空")
        sys.exit(1)
    elif os.path.isdir(template_path):
        items = os.listdir(template_path)
        for item in items:
            if item.endswith(".dmgCanvas"):
                if template_path.endswith("/"):
                    template_path += item
                else:
                    template_path += "/" + item
    if app_path == "":
        print("⚠️  文件路径不能为空")
        sys.exit(1)
    if output_path == "":
        output_path = makeDestination_path_from(app_path)

    print("...")
    print("文件路径：", app_path)
    print("输出路径：", output_path)
    print("模版路径：", template_path)

    copy_dmg_command()
    create_dmg_from(app_path, template_path, output_path)
