# Import some utilities
import numpy as np
import argparse
import sys, traceback

# Read the input file
def readInputFile(filename):
    """
    Method to read the input file and return the data as string.
    """
    try:
        inpFile = open(filename, "r")
        content = list(inpFile.readlines())
        inpFile.close()
    except:
        raise IOError
    return content

def getElementID():
    bdf       = readInputFile(inputfile)
    tag  = []
    for line in bdf:
        entry = line.split()
        if entry[0] == "CQUAD9":
            # print entry[0], entry[1], int(entry[2])
            tag.append(int(entry[2]))
    return remove_duplicates(tag)

def remove_duplicates(x):
    a = []
    for i in x:
        if i not in a:
            a.append(i)
    return a

def getNodesForElementID(id):
    bdf       = readInputFile(inputfile)
    node_idx  = []
    skip = False
    for line in bdf:
        entry = line.split()
        if entry[0] == "CQUAD9" and int(entry[2]) == id:
            # Append the BC node indices to the list
            node_idx.append(int(entry[3]))
            node_idx.append(int(entry[4]))
            node_idx.append(int(entry[5]))
            node_idx.append(int(entry[6]))
            node_idx.append(int(entry[7]))
            node_idx.append(int(entry[8]))
            
            # parse the continuations next time
            skip = True
        elif skip:
            # Append the BC node indices to the list
            node_idx.append(int(entry[1]))
            node_idx.append(int(entry[2]))
            node_idx.append(int(entry[3]))
            
            # Now turn off the continuations
            skip = False
            
    return sorted(remove_duplicates(node_idx))

def writeSPC(id):
    bc_nodes = getNodesForElementID(id)
    # open file
    fp = open('wing.bdf.bc', 'w')
    # If BC nodes are present write as SPC entries
    num_bc = len(bc_nodes)
    if num_bc != 0:
        # Set up the plate so that it is fully clamped
        for i in xrange(num_bc):
            # Set the y = const edges
            spc = '123'
            fp.write('%-8s%8d%8d%8s%8.6f\n'%
                     ('SPC', 1, bc_nodes[i], spc, 0.0))

        fp.write('END BULK')
        fp.close()
    return

parser = argparse.ArgumentParser()
parser.add_argument('--input', type=str, default='wing.bdf',
                    help='BDF Input file')

# Retrieve the arguments and set them for later use
args = parser.parse_args()
inputfile = args.input

# Get all the elementID tags defined in the mesh
print "Element IDs in the mesh"
eid = getElementID()
print eid
print len(eid)

# Look for the Boundary condition surface using two idenfying nodes
bc_index = [1,1]
for id in eid:
    nodes = getNodesForElementID(id)  
    if bc_index[0] in nodes and bc_index[1] in nodes:
        bc_id = id
        print "BC ID", id
        break

# Print all the nodes in the BC surface
id = bc_id
print "Nodes belonging to ID:", id
nodes = getNodesForElementID(id)
print nodes
print "Total nodes", len(nodes)

# Write out the BC as a separate file
print "BCs writted out as "+ inputfile + ".bc"
writeSPC(id)
