import math
import vtk
import pathlib

coords_file = pathlib.Path("locations.dat.txt")

lla_coords = []

with open(coords_file, "r") as f:
    for line in f:
        if not line.strip():
            continue
    
        line = line.split()
        try:
            lon, lat = float(line[0]), float(line[1])
            lla_coords.append((lon, lat))
        except:
            continue

xyz_coords = []

sphere_transform = vtk.vtkSphericalTransform()
vtk_points = vtk.vtkPoints()

for lon, lat in lla_coords:
    lon_rad = math.radians(lon)
    lat_rad = math.radians(90-lat)

    x, y, z = sphere_transform.TransformPoint(60.0, lat_rad, lon_rad)
    xyz_coords.append((x, y, z))

for x, y, z in xyz_coords:
    vtk_points.InsertNextPoint(x, y, z)

polydata = vtk.vtkPolyData()
polydata.SetPoints(vtk_points)

glyph_source = vtk.vtkSphereSource()
glyph_source.SetRadius(0.6)

glyph3D = vtk.vtkGlyph3D()
glyph3D.SetSourceConnection(glyph_source.GetOutputPort())
glyph3D.SetInputData(polydata)
glyph3D.Update()

mapper = vtk.vtkPolyDataMapper()
mapper.SetInputConnection(glyph3D.GetOutputPort())

actor = vtk.vtkActor()
actor.SetMapper(mapper)
actor.GetProperty().SetColor(1.0, 0.0, 0.0)
actor.SetPosition(13, 7.5, -22)
actor.RotateY(-120)
actor.RotateX(-90)

globe_source = vtk.vtkSphereSource()
globe_source.SetRadius(58)
globe_source.SetThetaResolution(100)
globe_source.SetPhiResolution(100)

globe_mapper = vtk.vtkDataSetMapper()
globe_mapper.SetInputConnection(globe_source.GetOutputPort())

globe_actor = vtk.vtkActor()
globe_actor.SetMapper(globe_mapper)
globe_actor.GetProperty().SetColor(0.0, 0.0, 1.0)
globe_actor.SetPosition(13, 7.5, -22)

reader = vtk.vtkOBJImporter()
reader.SetFileName("globe.obj")
reader.SetFileNameMTL("globe.mtl")

renderer = vtk.vtkRenderer()
renderer.SetBackground(0.5, 0.5, 0.5)
renderer.AddActor(actor)
renderer.AddActor(globe_actor)

window = vtk.vtkRenderWindow()
window.AddRenderer(renderer)
window.SetSize(800, 600)

reader.SetRenderWindow(window)
reader.Update()

renderer.ResetCamera()

interactor = vtk.vtkRenderWindowInteractor()
interactor.SetRenderWindow(window)
window.Render()
interactor.Start()