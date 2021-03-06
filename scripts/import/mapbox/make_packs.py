#!/usr/bin/env python2.7

import os, glob, shutil

planet_tiles = "mapbox/importer/tiles"
packages_dir = "mapbox/packages"
packages_meta = packages_dir + "_meta"
packages_timestamp = packages_dir + "/timestamp"
version = "2"

os.system("rm -rf %s %s" % (packages_dir, packages_meta))
for d in [packages_dir, packages_meta]:
    if not os.path.exists(d):
        os.makedirs(d)

os.system("date +'%%Y-%%m-%%d_%%H:%%M' > %s" % packages_timestamp)

for tile in glob.glob(planet_tiles + "/*sqlite"):
    dname, bname = os.path.split(tile)
    bbox = os.path.join(dname, "meta", bname + ".bbox")
    shutil.copy(tile, packages_dir)
    if os.path.exists(bbox): shutil.copy(bbox, packages_meta)
    cmd = "./pack.sh " + os.path.join(packages_dir, bname) + " " + version
    print cmd
    os.system(cmd)

print "Made Mapbox GL packages"
