## Mesh script to create a rubik cube model with various grain numbers and sizes:
import os, sys

sys.path.append("/Applications/Cubit-15.3/Cubit.app/Contents/MacOS/")
import cubit
cubit.init(['cubit','-info','off','-warning','off'])

def main(linear_number_grains,grain_size,num_elements_grain):
    ## Create the brick and move the back corner to the origin
    cubit.cmd("create brick x " + str(linear_number_grains * grain_size))
    cubit.cmd("move vertex 7 location 0 0 0 include_merged")
    xmin,xmax,xrange,ymin,ymax,yrange,zmin,zmax,zrange,diagMeasure = cubit.get_bounding_box("volume",1)

    ## Create the boundary conditions
    cubit.cmd("sideset 100 surface 3")
    cubit.cmd('sideset 100 name "bottom"')
    cubit.cmd("sideset 200 surface 4")
    cubit.cmd('sideset 200 name "left"')
    cubit.cmd("sideset 300 surface 2")
    cubit.cmd('sideset 300 name "back"')
    cubit.cmd("sideset 400 surface 5")
    cubit.cmd('sideset 400 name "top"')
    cubit.cmd("sideset 500 surface 6")
    cubit.cmd('sideset 500 name "right"')
    cubit.cmd("sideset 600 surface 1")
    cubit.cmd('sideset 600 name "front"')

    ## Webcut sections to make the grains
    for i in range(0,linear_number_grains):
      cubit.cmd("webcut volume all with plane xplane offset " + str(grain_size * (i+1)))
      cubit.cmd("webcut volume all with plane yplane offset " + str(grain_size * (i+1)))
      cubit.cmd("webcut volume all with plane zplane offset " + str(grain_size * (i+1)))

    cubit.cmd("imprint all")
    cubit.cmd("merge all")

    ## check visually that all interior surfaces are merged
    cubit.cmd("draw surf with is_merged")

    ## Set mesh up
    cubit.cmd("volume all scheme submap")
    cubit.cmd("volume all size " + str(grain_size / num_elements_grain))
    cubit.cmd("mesh volume all")

    ## Create a separate block for each grain
    VOL = cubit.get_entities("volume")
    for i in range(0,len(VOL)):
        cubit.cmd("Block " + str(i+1) + " Volume " + str(i+1))

    cubit.cmd("block all element type HEX8")

    ## And now save the generated mesh
    cubit.cmd('export mesh "~/projects/anteater/problems/geom/rubik_polyxtal.e" dimension 3 block all overwrite')

    ## DO EULER ANGLE GENERATION

if __name__ == '__main__':
    if len(sys.argv) < 4:
        linear_number_grains = 2
        grain_size = .5
        num_elements_grain = 1
    else:
        linear_number_grains = int(sys.argv[-3])
        grain_size = float(sys.argv[-2])
        num_elements_grain = int(sys.argv[-1])

    print "Making geometry with:"
    print "\tlinear_number_grains = " + str(linear_number_grains)
    print "\tgrain_size = " + str(grain_size)
    print "\tnum_elements_grain = " + str(num_elements_grain)
    main(linear_number_grains,grain_size,num_elements_grain)
