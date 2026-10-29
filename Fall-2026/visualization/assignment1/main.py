import vtk

reader = vtk.vtkOBJImporter()
reader.SetFileName("globe.obj")
reader.SetFileNameMTL("globe.mtl")

renderer = vtk.vtkRenderer()
renderer.SetBackground(0.1, 0.2, 0.3)

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