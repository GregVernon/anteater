import numpy
f = open("/Users/greg/Documents/maximal_sample_2.txt","r")
fLines = f.readlines()
f.close()

nPoints = len(fLines)
EulerAngles = numpy.zeros(shape=(nPoints,3),dtype='double')
for i in range(0,nPoints):
    EulerAngles[i,:] = [numpy.random.uniform(0.,360.),
                        numpy.random.uniform(0.,180.),
                        numpy.random.uniform(0.,360.)]

f = open("/Users/greg/Documents/maximal_sample_2_euler.txt","w+")
for i in range(0,nPoints):
    f.write(str(EulerAngles[i,0]) + " " + str(EulerAngles[i,1]) + " " + str(EulerAngles[i,2]) + "\n")

f.close()
