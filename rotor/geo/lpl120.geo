// Geometry and mesh characteristics
SetFactory("OpenCASCADE");

Include "../Parameters.geo";
Include "../Functions.geo";
Include "../naca.geo";
Include "../CreateComponents.geo";

// Create geometry
aoffset = 0;
theta = upper_swash_angle;
Call CreateLowerPitchLink;

out[] = Rotate {{0, 0, 1}, {xo, yo, zo}, Pi/2.0} {
Volume{vlowerpitch0};
};
vlowerpitch120 = out[0];

// Translate the blade to offset
out[] = Translate {xtrans, ytrans, ztrans} { Volume{vlowerpitch120}; };
vlowerpitch120 = out[0];

// Specify mesh characteristics
Mesh.CharacteristicLengthExtendFromBoundary = 1; 
Mesh.CharacteristicLengthFactor = 0.2; 
Mesh.CharacteristicLengthMin = 0; 
Mesh.CharacteristicLengthMax = 1.0; 
Mesh.CharacteristicLengthFromCurvature = 0; 
Mesh.CharacteristicLengthFromPoints = 1; 
Mesh.Optimize = 1; 
Mesh.SubdivisionAlgorithm = 1; 
Mesh.RecombinationAlgorithm = 1; 
Mesh.RecombineAll = 1; 
Mesh.RemeshAlgorithm = 0; 
Mesh.RemeshParametrization = 0; 
Mesh.RefineSteps = 10; 
Mesh.Smoothing = 5;
Mesh.ElementOrder=2; 
Mesh.BdfFieldFormat=2; 
Mesh.Format=31; 
Mesh.SaveElementTagType=1;