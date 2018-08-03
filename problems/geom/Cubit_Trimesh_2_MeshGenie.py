import os
import sys
import numpy
import scipy

sys.path.append("/Applications/Cubit-15.3/Cubit.app/Contents/MacOS/")
import cubit
cubit.init(['cubit','-info','off','-warning','off'])

def displayHelp():
    print "About:"
    print "This script uses Cubit-Python to generate an input file for MeshGenie Maximal Poisson Grid Solver" + "\n"
    print "Syntax:"
    print "python Cubit_Trimesh_2_MeshGenie.py mode geom_type method meshsize fileoutput" + "\n"
    print "Arguments:"
    print "mode: Used to define which geometry creation method user wants"
    print "\t" + "Simple: Use one of Cubit's geometry primitives"
    print "\t" + "UserSpecified: User will supply a geometry model"
    print "geom_type: Used to specify which geometry should be made, dependent on value of <mode>"
    print "\t" + "If <mode> is 'Simple', user must supply a valid Cubit syntax for creating a primitive using " + '"cubit command here"' + " syntax"
    print "\t" + "If <mode> is 'UserSpecified', user must provide a path to a valid geometry file that Cubit can read"
    print "\t\t" + "CAD format must be one of the following types:"
    print "\t\t\t" + "ACIS (.sat) | STEP (.stp) | STL (.stl) | Exodus (.g | .e)"
    print "method: Used to specify which mesh generation method to use:"
    print "\t" + "Tri: Uses a surface tri-mesher to construct surface mesh"
    print "\t" + "Tet: Uses a volumetric tet-mesher, which may result in higher quality surface mesh, and extracts surface triangles"
    print "meshsize: Specifies the approximate element size for the selected mesh techniqe"
    print "radius: The radius to use in MeshGenie Maximal Poisson Grid Solver"
    print "rseed: The random seed to use in MeshGenie Maximal Poisson Grid Solver"
    print "fileoutput: The path and name of the output file"

def main(mode, geom_type, method, meshsize, radius, rseed, fileoutput):
    # mode = "UserSpecified"
    # geom_type = '/Users/greg/projects/anteater/problems/geom/holey_cylinder.sat'
    # method = "tetmesh"
    # size = 0.1
    # filebase = "/Users/greg/projects/anteater/problems/geom/"
    makeGeom(mode, geom_type)
    meshGeom(method, meshsize)
    ELEM, NODE, eCONNECT, COORD = getMeshData()
    outputFile(eCONNECT, COORD, ELEM, NODE, radius, rseed, fileoutput)

def makeGeom(mode,geom_type):
    cubit.cmd("reset")
    if mode == "Simple":
        try:
            cubit.cmd(geom_type)
        except:
            raise SystemExit(geom_type + "... is an invalid Cubit command!\nPlease review proper syntax!")

    elif mode == "UserSpecified":
        filename = geom_type
        filepath,filename = os.path.split(filename)
        if filepath == '':
            filepath = os.getcwd()

        fileext = os.path.splitext(filename)[-1].lower()
        print os.path.join(filepath,filename)
        if fileext == ".sat":
            cubit.cmd('import acis "' + os.path.join(filepath,filename) + '" separate_bodies')
        elif fileext == ".stp":
            cubit.cmd('import step "' + os.path.join(filepath,filename) + '" heal')
        elif fileext == ".stl":
            cubit.cmd('import stl "' + os.path.join(filepath,filename) + '" feature_angle 135.00 merge ')
        elif fileext in [".g", ".e"]:
            cubit.cmd('import exodus "' + os.path.join(filepath,filename) + '" feature_angle 135.00 merge')
            cubit.cmd('delete mesh')



def meshGeom(method, size):
    cubit.cmd("block 1 surf all")
    if method.lower() == "tetmesh":
        cubit.cmd("vol all size " + str(size))
        cubit.cmd("volume all Scheme Tetmesh proximity layers on 3 geometry approximation angle 15 ")
        cubit.cmd("volume all tetmesh growth_factor 1 ")
        cubit.cmd("Trimesher surface gradation 1.3")
        cubit.cmd("Trimesher volume gradation 1.3")
        cubit.cmd("Set Tetmesher Optimize Level 6 Overconstrained ON Sliver ON")
        cubit.cmd("Set Tetmesher Interior Points On")
        cubit.cmd("Set Tetmesher Boundary Recovery OFF")
        cubit.cmd("Mesh vol all")
    elif method.lower() == "trimesh":
        cubit.cmd("surf all size " + str(size))
        cubit.cmd("surf all scheme trimesh")
        cubit.cmd("mesh surf all")

def getMeshData():
    ELEM = cubit.get_entities("tri")
    NODE = cubit.get_entities("node")

    nELEM = len(ELEM)
    nNODE = len(NODE)

    eCONNECT = numpy.zeros(shape=(nELEM,3),dtype="int64")
    COORD = numpy.zeros(shape=(nNODE,3),dtype="double")

    for i in range(0,nELEM):
      eCONNECT[i,:] = list(cubit.get_connectivity("tri",ELEM[i]))
    eCONNECT = eCONNECT - 1

    for i in range(0,nNODE):
      COORD[i,:] = list(cubit.get_nodal_coordinates(NODE[i]))

    return ELEM, NODE, eCONNECT, COORD

def outputFile(eCONNECT, COORD, ELEM, NODE, radius, rseed, fileoutput):
    nDim = 3
    # radius = 0.5
    # random_seed = 0
    filepath,filename = os.path.split(fileoutput)
    cubit.cmd('export STL ASCII "' + os.path.join(filepath, filename) + '.stl' + '" mesh  overwrite ')
    f = open(os.path.join(filepath, filename) + '.txt',"w+")
    f.write("p" + "\n")
    f.write(str(nDim) + " " + radius + " " + rseed + " " + str(len(NODE)) + " " + str(len(ELEM)) + "\n")
    for i in range(0,len(NODE)):
        f.write(str(COORD[i,0]) + " " + str(COORD[i,1]) + " " + str(COORD[i,2]) + "\n")
    for i in range(0,len(ELEM)):
        f.write(str(eCONNECT[i,0]) + " " + str(eCONNECT[i,1]) + " " + str(eCONNECT[i,2]) + "\n")

    f.close()

if __name__ == "__main__":
    if sys.argv[-1] == "-h":
        displayHelp()
    else:
        # print sys.argv[1:]
        mode, geom_type, method, size, radius, rseed, fileoutput = sys.argv[1:]
        main(mode, geom_type, method, size, radius, rseed, fileoutput)
