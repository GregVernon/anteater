import os
import sys
import numpy
import scipy

sys.path.append("/Applications/Cubit-15.3/Cubit.app/Contents/MacOS/")
import cubit
cubit.init(['cubit'])

def main():
    cubit.cmd('reset')
    cubit.cmd('create cylinder height 30 radius 5')
    cubit.cmd('create cylinder height 30 radius 4')
    cubit.cmd('subtract volume 2 from volume 1')
    cubit.cmd('compress ids')
    cubit.cmd('cylinder radius 2.5 height 10')
    cubit.cmd('rotate volume 2 angle 90 about y include_merged')
    cubit.cmd('subtract volume 2 from volume 1')
    cubit.cmd('compress ids')
    cubit.cmd('set attribute off')
    cubit.cmd('export acis "~/projects/anteater/problems/geom/holey_cylinder.sat" overwrite')
    cubit.cmd('export step "~/projects/anteater/problems/geom/holey_cylinder.stp" overwrite')
    cubit.cmd('webcut volume all with plane xplane offset 0')
    cubit.cmd('webcut volume all with plane zplane offset 0')
    cubit.cmd('webcut volume all with plane zplane offset 5')
    cubit.cmd('webcut volume all with plane zplane offset -5')
    cubit.cmd('webcut volume all with plane zplane offset 0 rotate 90 about x')
    cubit.cmd('imprint all')
    cubit.cmd('merge all')
    cubit.cmd('compress ids')

    cubit.cmd('block 1 add volume all')
    
    cubit.cmd('Sideset 1 add surface 21 14 23 30')
    cubit.cmd('sideset 1 name "left"')

    cubit.cmd('Sideset 2 add surface 64 71 76 69')
    cubit.cmd('sideset 2 name "right"')

    for i in xrange(0,4):
        if i == 0:
            cubit.cmd('volume all size 0.5')
            cubit.cmd('mesh volume all')
        else:
            cubit.cmd('refine volume all numsplit 1 bias 1 depth 1 smooth')
        cubit.cmd('export genesis "~/projects/anteater/problems/geom/hollow_cyl_hole_r' + str(i) + '.e" overwrite')




if __name__ == '__main__':
    main()
