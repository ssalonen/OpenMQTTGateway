# Adapted from https://github.com/doctea/usb_midi_clocker/blob/main/add_git_branch.py
# 2024-02-03 
import datetime

import subprocess

def populate_version_info():
    now = datetime.datetime.now()
    
    # dont track changesto the output file
    subprocess.run(["git", "update-index", "--skip-worktree", "build_info_env.ini"])

    build_version = now.strftime("%y-%m-%d")
    ret = subprocess.run(["git", "rev-parse", "--short", "HEAD"], stdout=subprocess.PIPE, text=True)
    build_version += "-"
    build_version += ret.stdout.strip()

    # add dirty/clean flag
    ret = subprocess.run(["git", "diff", "HEAD"], stdout=subprocess.PIPE, text=True)
    status = "-c" if ret.stdout.strip()=="" else "-d"
    build_version += status

    print ("build_version = " + build_version)

    # write to file
    with open("build_info_env.ini","w") as f:
        f.write("# do not edit this file - automatically generated during build\n")
        f.write("# regenerated at %s\n\n" % now)
        f.write("[build_info]\ncommit_info = " + build_version + "\n\n")

populate_version_info()