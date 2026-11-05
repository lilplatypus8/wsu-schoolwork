#include <vtkNamedColors.h>
#include <vtkNew.h>
#include <vtkOBJImporter.h>
#include <vtkPolyData.h>
#include <vtkPolyDataMapper.h>
#include <vtkRenderWindow.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkRenderer.h>
#include <vtkTexture.h>

#include <iostream>

std::list<float> latitudes;
std::list<float> longitudes;

int main(int argc, char* argv[])
{

    // Create a renderer, render window, and interactor
    vtkNew<vtkRenderer> renderer;
    vtkNew<vtkRenderWindow> renderWindow;
    renderWindow->AddRenderer(renderer);
    vtkNew<vtkRenderWindowInteractor> renderWindowInteractor;
    renderWindowInteractor->SetRenderWindow(renderWindow);

    // Import the OBJ file
    vtkNew<vtkOBJImporter> reader;
    reader->SetFileName("globe.obj");
    reader->SetFileNameMTL("globe.mtl");
    reader->SetRenderWindow(renderWindow);
    reader->Update();

    ifstream file("locations.dat.txt");

    while (getline(file, line)) {
        std::istringstream iss(line);
        double lat, lon;
        
        

    }

    // Set background color
    renderer->SetBackground(0.1, 0.1, 0.5);

    // Render and start interaction
    renderWindow->Render();
    renderWindowInteractor->Start();

    return EXIT_SUCCESS;
}